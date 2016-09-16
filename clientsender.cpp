#include "clientsender.h"
#include <QtCore/QDebug>
clientSender::clientSender(QObject *parent) : QObject(parent)
{
}
void clientSender::doConnect()
{
    socket = new QTcpSocket(this);

    connect(socket, SIGNAL(connected()),this, SLOT(connected()));
    connect(socket, SIGNAL(disconnected()),this, SLOT(disconnected()));
    connect(socket, SIGNAL(bytesWritten(qint64)),this, SLOT(bytesWritten(qint64)));
    connect(socket, SIGNAL(readyRead()),this, SLOT(readyToRead()));

    qDebug() << "connecting...";

    // this is not blocking call

//    socket->connectToHost("75.118.98.81", 8080);
    socket->connectToHost("127.0.0.1", 8080);

    // we need to wait...
    if(!socket->waitForConnected(5000))
    {
        qDebug() << "Error: " << socket->errorString();
    }
}

void clientSender::connected()
{
    qDebug() << "connected...";

}

void clientSender::disconnected()
{

    qDebug() << "disconnected...";
}

void clientSender::bytesWritten(qint64 bytes)
{
    qDebug() << bytes << " bytes written...";
}

void clientSender::readyToRead()
{
    qDebug() << "reading...";

    QByteArray data = socket->readAll();
    QDomDocument serverDoc;
    serverDoc.setContent(data);
    QDomElement thread = serverDoc.firstChildElement("threads");
    if(serverDoc.firstChildElement("threads").isNull()){
        thread = serverDoc.firstChildElement("thread");
    }
    QString fileName = thread.firstChildElement("fileName").text();
    QFile file(appDir.absoluteFilePath(fileName));
    file.open(QIODevice::ReadWrite);
    qDebug() << file.exists();
    if(onStart){
        QDir fileDir;
        fileDir.setPath(appDir.absolutePath());
        QStringList filters;
        filters.append("*.xml");
        QFileInfoList fileList = fileDir.entryInfoList(filters);
        QDomNodeList fileNodes = serverDoc.firstChildElement("threads").childNodes();
        QFileInfo fileInfo;
        for(int i = 0; i < fileList.size(); i++){
            bool fileFound = false;
            for(int j = 0; j < fileNodes.size(); j++){
                fileInfo.setFile(fileDir, fileNodes.at(j).firstChildElement("source").text());
                if(fileInfo == fileList.at(i) || fileList.at(i).fileName() == "MainThreads.xml"){
                    fileFound = true;
                    break;
                }
            }
            if(!fileFound){
                qDebug() << "file to be removed" << fileList.at(i).fileName();
                fileDir.remove(fileList.at(i).fileName());
            }
        }
        onStart = false;
    }
    if(fileName != "MainThreads.xml"){
        QDomDocument clientDoc;
        clientDoc.setContent(&file);
        QDomNodeList clientArticles = clientDoc.firstChildElement("thread").firstChildElement("articles").elementsByTagName("article");
        QDomNodeList serverArticles = thread.firstChildElement("articles").elementsByTagName("article");
        for(int i = 0; i < clientArticles.size(); i++){
            serverArticles.at(i).appendChild(clientArticles.at(i).firstChildElement("enabled"));
        }
    }
    file.resize(0);
    if(file.isOpen()){
    // read the data from the socket
        file.write(serverDoc.toByteArray());
    }else{
        qDebug() << "file not open";
    }
    file.flush();
    file.close();

    emit finishedReading();

}


void clientSender::closing(){
    QFile file(appDir.absoluteFilePath("MainThreads.xml"));
    file.open(QFile::ReadWrite);
    QDomDocument doc;
    doc.setContent(&file);
    QDomNodeList threads = doc.firstChildElement("threads").elementsByTagName("thread");
    for(int i = 0; i< threads.size(); i++){
        QFile threadFile(appDir.absoluteFilePath(threads.at(i).firstChildElement("source").text()));
        threadFile.remove();

    }
    file.remove();
}

void clientSender::sendPost(QString fileName, QString articles, QString postText, QString icon)
{
    QFile file(appDir.absoluteFilePath(fileName));
    QDomDocument doc;
    file.open(QIODevice::ReadWrite);
    doc.setContent(&file);
    file.resize(0);
    QDomNode ele = doc.firstChildElement("thread");
    QDomElement header = doc.createElement("header");
    header.appendChild(doc.createTextNode("post"));
//    if(sizeof(articles) > 0){
//        for(int i = 0; i < sizeof(articles); i++){
//                articleAdder(doc, articles[i]);
//        }
//    }
    QDomElement posts = ele.firstChildElement("posts");
    QDomElement post = doc.createElement("post");
    QDomElement postTextEle = doc.createElement("postText");
    QDomElement postIcon = doc.createElement("icon");
    postTextEle.appendChild(doc.createTextNode(postText));
    postIcon.appendChild(doc.createTextNode(icon));
    post.appendChild(postIcon);
    post.appendChild(postTextEle);
    posts.appendChild(post);
    if(!ele.firstChildElement("header").isNull()){
        ele.insertBefore(header, ele.firstChildElement("header"));
    }else{
        ele.appendChild(header);
    }

    QByteArray array = doc.toByteArray();

    if(socket->isOpen()){
        qDebug() << "Writing...";
        socket->write(array);
        qDebug() << "Done Writing";
    }else{
       qDebug() << "Socket not open";
    }
    file.flush();
    file.close();
}

void clientSender::addArticle(QString fileName, QString article)
{
    QDomDocument doc;
    QFile file(appDir.absoluteFilePath(fileName));
    file.open(QIODevice::ReadWrite);
    doc.setContent(&file);
    file.resize(0);
    QDomNode thrd = doc.firstChildElement("thread");
    QDomElement header = doc.createElement("header");
    header.appendChild(doc.createTextNode("article"));
    if(!thrd.firstChildElement("header").isNull()){
        thrd.insertBefore(header, thrd.firstChildElement("header"));
    }else{
        thrd.appendChild(header);
    }

    articleAdder(doc, article);
    QByteArray array = doc.toByteArray();
    file.write(array);
    qDebug() << doc.toString();
    if(socket->isOpen()){
        qDebug() << "Writing...";
        socket->write(array);
        qDebug() << "Done Writing";
    }else{
       qDebug() << "Socket not open";
    }
    file.flush();
    file.close();
}

void clientSender::fairVote(QString fileName, QString article)
{
    qDebug() << "fairChanged";
    QFile file(appDir.absoluteFilePath(fileName));
    QDomDocument doc;
    file.open(QIODevice::ReadWrite);
    doc.setContent(&file);
    file.resize(0);
    QDomNode ele = doc.firstChildElement("thread");
    QDomElement header = doc.createElement("header");
    header.appendChild(doc.createTextNode("fairChanged"));
    if(!ele.firstChildElement("header").isNull()){
        ele.insertBefore(header, ele.firstChildElement("header"));
    }else{
        ele.appendChild(header);
    }

    QDomElement articles = ele.firstChildElement("articles").toElement();
    QDomNodeList articleTags = articles.elementsByTagName("article");
    for(int i = 0; i < articleTags.size(); i++){
        if(articleTags.at(i).firstChildElement("source").text() == article){
            QDomElement fairTag = articleTags.at(i).firstChildElement("fair");
            QDomElement enabledTag = articleTags.at(i).firstChildElement("enabled");
            int fairVal = fairTag.text().toInt();
            fairVal++;
            qDebug() << "fairVal" << fairVal;
            fairTag.replaceChild(doc.createTextNode(QString::number(fairVal)), fairTag.firstChild());
            enabledTag.replaceChild(doc.createTextNode("false"), enabledTag.firstChild());
            break;
        }
    }
    QByteArray array = doc.toByteArray();
    file.write(array);
    if(socket->isOpen()){
        qDebug() << "Writing...";
        socket->write(array);
        qDebug() << "Done Writing";
    }else{
       qDebug() << "Socket not open";
    }
    file.flush();
    file.close();
}

void clientSender::biasVote(QString fileName, QString article)
{
    qDebug() << "Bias Vote";
    qDebug() << fileName;
    qDebug() << "article" << article;
    QFile file(appDir.absoluteFilePath(fileName));
    file.open(QIODevice::ReadWrite);
    QDomDocument doc;
    doc.setContent(&file);
    file.resize(0);
    QDomNode ele = doc.firstChildElement("thread");

    QDomElement header = doc.createElement("header");
    header.appendChild(doc.createTextNode("biasChanged"));
    ele.insertBefore(header, ele.firstChildElement("header"));
    QDomElement articles = ele.firstChildElement("articles").toElement();
    QDomNodeList articleTags = articles.elementsByTagName("article");
    for(int i = 0; i < articleTags.size(); i++){
        if(articleTags.at(i).firstChildElement("source").text() == article){
            QDomElement biasTag = articleTags.at(i).firstChildElement("bias");
            QDomElement enabledTag = articleTags.at(i).firstChildElement("enabled");
            int biasVal = biasTag.text().toInt();
            biasVal++;
            qDebug() << "biasVal" << biasVal;
            biasTag.replaceChild(doc.createTextNode(QString::number(biasVal)), biasTag.firstChild());
            enabledTag.replaceChild(doc.createTextNode("false"), enabledTag.firstChild());
            break;
        }
    }
    QByteArray array = doc.toByteArray();
    file.write(array);
    if(socket->isOpen()){
        qDebug() << "Writing...";
        socket->write(array);
        qDebug() << "Done Writing";
    }else{
       qDebug() << "Socket not open";
    }
    file.flush();
    file.close();
}


void clientSender::newThread(QString title, QString article, QString text, QString icon, QString fileName)
{
    qDebug() << "New Thread";
    QFile file(appDir.absoluteFilePath(fileName));
    file.open(QIODevice::ReadWrite);

    QDomDocument doc;
    QDomProcessingInstruction procInst = doc.createProcessingInstruction("xml", "version=\"1.0\" encoding=\"UTF-8\"");
    doc.appendChild(procInst);
    QDomElement root = doc.createElement("fileName");
    root.appendChild(doc.createTextNode(fileName));
    QDomElement header = doc.createElement("header");
    header.appendChild(doc.createTextNode("New Thread"));
    QDomElement thread = doc.createElement("thread");
    QDomElement head = doc.createElement("head");
    head.appendChild(doc.createTextNode(title));
    thread.appendChild(header);
    thread.appendChild(root);
    thread.appendChild(head);
    doc.appendChild(thread);
    qDebug() << article;
    if(!article.isEmpty()){
          articleAdder(doc, article);
    }
    QDomElement posts = doc.createElement("posts");
    QDomElement post = doc.createElement("post");
    QDomElement postText = doc.createElement("postText");
    QDomElement postIcon = doc.createElement("icon");
    postText.appendChild(doc.createTextNode(text));
    postIcon.appendChild(doc.createTextNode(icon));
    post.appendChild(postIcon);
    post.appendChild(postText);
    posts.appendChild(post);
    thread.appendChild(posts);
    qDebug() << doc.toString();
    file.write(doc.toByteArray());
    QByteArray array = doc.toByteArray();
    if(socket->isOpen()){
        qDebug() << "Writing...";
        socket->write(array);
        qDebug() << "Done Writing";
    }else{
       qDebug() << "Socket not open";
    }
    file.close();
    file.flush();

}

void clientSender::update(QString fileName)
{

    QFile file(appDir.absoluteFilePath(fileName));
    qDebug() << "update:" << fileName;
    file.open(QIODevice::ReadWrite);
    QDomDocument doc;
    doc.setContent(&file);
    if (!doc.hasChildNodes()){
        QDomProcessingInstruction procInst = doc.createProcessingInstruction("xml", "version=\"1.0\" encoding=\"UTF-8\"");
        doc.appendChild(procInst);
        QDomElement root = doc.createElement("fileName");
        root.appendChild(doc.createTextNode(fileName));
        QDomElement thread = doc.createElement("thread");
        QDomElement head = doc.createElement("title");

        QFile mainThreadsFile(appDir.absoluteFilePath("MainThreads.xml"));
        mainThreadsFile.open(QIODevice::ReadOnly);
        qDebug() << mainThreadsFile.objectName();
        QDomDocument mainThreadsDoc;
        mainThreadsDoc.setContent(&mainThreadsFile);
        mainThreadsFile.close();
        QDomNodeList threads = mainThreadsDoc.firstChildElement("threads").childNodes();
        for(int i = 0; i < threads.size(); i++){
            if(threads.at(i).firstChildElement("source").text() == fileName){
                head.appendChild(doc.createTextNode(threads.at(i).firstChildElement("title").text()));
                break;
            }
        }
        thread.appendChild(root);
        thread.appendChild(head);
        thread.appendChild(doc.createElement("articles"));
        thread.appendChild(doc.createElement("posts"));
        doc.appendChild(thread);
    }
    qDebug() << file.objectName();
    file.resize(0);
    QDomNode ele = doc.firstChildElement("thread");
    if(ele.isNull()){
        ele = doc.firstChildElement("threads");
    }
    QDomElement header = doc.createElement("header");
    header.appendChild(doc.createTextNode("update"));
    if(!ele.firstChildElement("header").isNull()){
        ele.insertBefore(header, ele.firstChildElement("header"));
    }else{
        ele.appendChild(header);
    }

    QByteArray array = doc.toByteArray();
    file.write(array);
    if(socket->isOpen()){
        qDebug() << "Writing...";
        socket->write(array);
        qDebug() << "Done Writing";
    }else{
       qDebug() << "Socket not open";
    }
    file.flush();
    file.close();

}

QString clientSender::getAppPath(QString fileName)
{
    return appDir.absoluteFilePath(fileName);
}

void clientSender::copy(QString text)
{
    QClipboard *clipBoard = QApplication::clipboard();
    clipBoard->text(text);
}

void clientSender::articleAdder(QDomDocument doc, QString article)
{
    QDomElement thread = doc.firstChildElement("thread");
    QDomElement articles = thread.firstChildElement("articles");
    if(thread.firstChildElement("articles").isNull()){
        articles = doc.createElement("articles");
        thread.appendChild(articles);
    }
    QDomElement articleTag = doc.createElement("article");
    QDomElement source = doc.createElement("source");
    QDomElement fair = doc.createElement("fair");
    QDomElement bias = doc.createElement("bias");
    QDomElement enabled = doc.createElement("enabled");
    QString artString = article;
    if(!artString.contains("http://")){

        artString.insert(0, "http://");
    }
    source.appendChild(doc.createTextNode(artString));
    fair.appendChild(doc.createTextNode("0"));
    bias.appendChild(doc.createTextNode("0"));
    enabled.appendChild(doc.createTextNode("true"));
    articleTag.appendChild(enabled);
    articleTag.appendChild(source);
    articleTag.appendChild(fair);
    articleTag.appendChild(bias);
    articles.appendChild(articleTag);
}



