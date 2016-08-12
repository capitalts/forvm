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
    socket->connectToHost("127.0.0.1", 1234);

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
    QDomDocument doc;
    doc.setContent(data);
    QDomElement thread = doc.firstChildElement("thread");
    QString filename = thread.firstChildElement("fileName").text();
    QFile file("/home/tory/Qtprojects/ForvmXMLFiles/" + filename);
    file.resize(0);
    if(file.open(QIODevice::WriteOnly)){
    // read the data from the socket
        file.write(data);
    }else{
        qDebug() << "file not open";
    }
    file.close();

}

void clientSender::sendPost(QString fileName, QString articles, QString postText, QString icon)
{
    currentFileName = "/home/tory/Qtprojects/ForvmXMLFiles/" + fileName;
    QFile file(currentFileName);
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
    ele.appendChild(header);

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
    currentFileName = "/home/tory/Qtprojects/ForvmXMLFiles/" + fileName;
    QFile file(currentFileName);
    file.open(QIODevice::ReadWrite);
    doc.setContent(&file);
    file.resize(0);
    QDomNode thrd = doc.firstChildElement("thread");
    QDomElement header = doc.createElement("header");
    header.appendChild(doc.createTextNode("article"));
    thrd.appendChild(header);
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
    currentFileName = "/home/tory/Qtprojects/ForvmXMLFiles/" + fileName;

    qDebug() << currentFileName;
    QFile file(currentFileName);
    QDomDocument doc;
    file.open(QIODevice::ReadWrite);
    doc.setContent(&file);
    file.resize(0);
    QDomNode ele = doc.firstChildElement("thread");
    QDomElement header = doc.createElement("header");
    header.appendChild(doc.createTextNode("fairChanged"));
    ele.appendChild(header);
    QDomElement articles = ele.firstChildElement("articles").toElement();
    QDomNodeList articleTags = articles.elementsByTagName("article");
    for(int i = 0; i < articleTags.size(); i++){
        if(articleTags.at(i).firstChildElement("source").text() == article){
            QDomElement fairTag = articleTags.at(i).firstChildElement("fair");
            int fairVal = fairTag.text().toInt();
            fairVal++;
            qDebug() << "fairVal" << fairVal;
            fairTag.replaceChild(doc.createTextNode(QString::number(fairVal)), fairTag.firstChild());
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
    currentFileName = "/home/tory/Qtprojects/ForvmXMLFiles/" + fileName;
    QFile file(currentFileName);
    file.open(QIODevice::ReadWrite);
    QDomDocument doc;
    doc.setContent(&file);
    file.resize(0);
    QDomNode ele = doc.firstChildElement("thread");
    QDomElement header = doc.createElement("header");
    header.appendChild(doc.createTextNode("biasChanged"));
    ele.appendChild(header);
    QDomElement articles = ele.firstChildElement("articles").toElement();
    QDomNodeList articleTags = articles.elementsByTagName("article");
    for(int i = 0; i < articleTags.size(); i++){
        if(articleTags.at(i).firstChildElement("source").text() == article){
            QDomElement biasTag = articleTags.at(i).firstChildElement("bias");
            int biasVal = biasTag.text().toInt();
            biasVal++;
            qDebug() << "biasVal" << biasVal;
            biasTag.replaceChild(doc.createTextNode(QString::number(biasVal)), biasTag.firstChild());
            break;
        }
    }
    QByteArray array = doc.toByteArray();
//    qDebug() << doc.toString();
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


void clientSender::newThread(QString title, QString articles[], QString text, QString icon)
{
    time_t now = time(0);
    QDomDocument doc;
    QDomProcessingInstruction procInst = doc.createProcessingInstruction("xml", "version=\"1.0\"");
    doc.appendChild(procInst);
    QDomElement root = doc.createElement("fileName");
    root.appendChild(doc.createTextNode(title + now + ".xml"));
    QDomElement header = doc.createElement("header");
    header.appendChild(doc.createTextNode("newThread"));
    QDomElement thread = doc.createElement("thread");
    QDomElement head = doc.createElement("head");
    head.appendChild(doc.createTextNode(title));
    QDomElement arts = doc.createElement("articles");
    if(sizeof(articles) > 0){
        for(int i = 0; i < sizeof(articles); i++){
                articleAdder(doc, articles[i]);
        }
    }

    QDomElement posts = doc.createElement("posts");
    QDomElement post = doc.createElement("postText");
    QDomElement postIcon = doc.createElement("icon");
    post.appendChild(doc.createTextNode(text));
    postIcon.appendChild(doc.createTextNode(icon));
    posts.appendChild(post);
    thread.appendChild(root);
    thread.appendChild(head);
    thread.appendChild(arts);
    thread.appendChild(posts);
    root.appendChild(thread);
    QByteArray array = doc.toByteArray();
    socket->write(array);

}

void clientSender::update(QString fileName)
{
    qDebug() << "update file";
    currentFileName = "/home/tory/Qtprojects/ForvmXMLFiles/" + fileName;
    QFile file(currentFileName);
    file.open(QIODevice::ReadWrite);
    QDomDocument doc;
    doc.setContent(&file);
    file.resize(0);
    QDomNode ele = doc.firstChildElement("thread");
    QDomElement header = doc.createElement("header");
    header.appendChild(doc.createTextNode("update"));
    ele.appendChild(header);
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

void clientSender::articleAdder(QDomDocument doc, QString article)
{
    QDomElement thread = doc.firstChildElement("thread");
    QDomElement articles = thread.firstChildElement("articles");
    QDomElement articleTag = doc.createElement("article");
    QDomElement source = doc.createElement("source");
    QDomElement fair = doc.createElement("fair");
    QDomElement bias = doc.createElement("bias");
    QString artString = article;
    if(!artString.contains("http://")){
        artString = "http://" + artString;
    }
    source.appendChild(doc.createTextNode(artString));
    fair.appendChild(doc.createTextNode("0"));
    bias.appendChild(doc.createTextNode("0"));
    articleTag.appendChild(source);
    articleTag.appendChild(fair);
    articleTag.appendChild(bias);
    articles.appendChild(articleTag);
}

