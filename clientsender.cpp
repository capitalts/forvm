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
    connect(socket, SIGNAL(readyRead()),this, SLOT(readyRead()));

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

void clientSender::readyRead()
{
    qDebug() << "reading...";
    QFile file(currentFileName);
    if(file.open(QIODevice::ReadWrite | QIODevice::Truncate)){
    // read the data from the socket
    file.write(socket->readAll());
    }else{
        qDebug() << "file not open";
    }
    file.close();

}

void clientSender::sendPost(QString fileName, QString articles[], QString postText, QString icon)
{
    QDomDocument doc;
    currentFileName = "/home/tory/Qtprojects/ForvmXMLFiles/" + fileName;
    QFile file(currentFileName);
    doc.setContent(&file);
    QDomElement header = doc.firstChildElement("header");
    header.setNodeValue("post");
    if(sizeof(articles) > 0){
        for(int i = 0; i < sizeof(articles); i++){
                articleAdder(doc, articles[i]);
        }
    }
    QDomElement root = doc.firstChildElement("root");
    QDomElement posts = root.firstChildElement("posts");
    QDomElement post = doc.createElement("postText");
    QDomElement postIcon = doc.createElement("icon");
    post.appendChild(doc.createTextNode(postText));
    postIcon.appendChild(doc.createTextNode(icon));
    posts.appendChild(post);

    QByteArray array = doc.toByteArray();
    socket->write(array);
}

void clientSender::addArticle(QString fileName, QString article)
{
    QDomDocument doc;
    currentFileName = "/home/tory/Qtprojects/ForvmXMLFiles/" + fileName;
    QFile file(currentFileName);

    doc.setContent(&file);
    articleAdder(doc, article);
    QByteArray array = doc.toByteArray();
    socket->write(array);
}

void clientSender::fairVote(QString fileName, QString article)
{
    qDebug() << "fairChanged";
    currentFileName.clear();
    currentFileName.append("/home/tory/Qtprojects/ForvmXMLFiles/" + fileName);

    qDebug() << currentFileName;
    QFile file(currentFileName);
    file.open(QIODevice::ReadWrite | QIODevice::Truncate);
    QDomDocument doc;
    doc.setContent(&file);
    qDebug() << file.size();
    qDebug() << doc.toString();
//    QDomNode ele = doc.firstChildElement("thread");
//    QDomElement header = doc.createElement("header");
//    header.appendChild(doc.createTextNode("fairChanged"));
//    ele.appendChild(header);
//    QDomElement articles = ele.firstChildElement("articles").toElement();
//    QDomNode articleTag = articles.firstChild();
//    do{
//        if(articleTag.firstChildElement("source").text() == article){
//            QDomElement fairTag = articleTag.firstChildElement("fair");
//            int fairVal = fairTag.text().toInt();
//            fairVal++;
//            fairTag.replaceChild(doc.createTextNode(QString::number(fairVal)), fairTag.firstChild());
//        }
//        articleTag = articleTag.nextSibling();
//    }while(articleTag.firstChildElement("source").text() != article && !articleTag.isNull());
//    qDebug() << doc.toString();
//    QByteArray array = doc.toByteArray();
//    file.write(array);
//    qDebug() << "Writing...";
//    socket->write(file.readAll());
    file.close();
}

void clientSender::biasVote(QString fileName, QString article)
{
    qDebug() << "Bias Vote";
    qDebug() << fileName;
    qDebug() << article;
    currentFileName = "/home/tory/Qtprojects/ForvmXMLFiles/" + fileName;
    QFile file(currentFileName);
    file.open(QIODevice::ReadWrite | QIODevice::Truncate);
    QDomDocument doc;
    doc.setContent(&file);
    QDomNode ele = doc.firstChildElement("thread");
    QDomElement header = doc.createElement("header");
    header.appendChild(doc.createTextNode("biasChanged"));
    doc.insertBefore(header,ele);
    QDomElement articles = ele.firstChildElement("articles").toElement();
    QDomNode articleTag = articles.firstChild();
    do{
        if(articleTag.firstChildElement("source").text() == article){
            QDomElement biasTag = articleTag.firstChildElement("bias");
            int biasVal = biasTag.text().toInt();
            biasVal++;
            biasTag.replaceChild(doc.createTextNode(QString::number(biasVal)), biasTag.firstChild());
        }
        articleTag = articleTag.nextSibling();
    }while(articleTag.firstChildElement("source").text() != article && !articleTag.isNull());
    QByteArray array = doc.toByteArray();
    file.write(array);
    if(socket->isOpen()){
        qDebug() << "Writing...";
        socket->write(file.readAll());
    }else{
       qDebug() << "Socket not open";
    }
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
    currentFileName = "/home/tory/Qtprojects/ForvmXMLFiles/" + fileName;
    QFile file(currentFileName);
    qDebug() << "update file";
    if(file.open(QIODevice::ReadWrite | QIODevice::Truncate)){
        socket->write(file.readAll());
    }else{
        qDebug() << "file not open";
    }
    file.close();

}

void clientSender::articleAdder(QDomDocument doc, QString article)
{
    QDomElement ele = doc.firstChildElement("articles");
    QDomElement articleTag = doc.createElement("article");
    QDomElement source = doc.createElement("source");
    QDomElement fair = doc.createElement("fair");
    QDomElement bias = doc.createElement("bias");
    source.appendChild(doc.createTextNode(article));
    fair.appendChild(doc.createTextNode(0));
    bias.appendChild(doc.createTextNode(0));
    articleTag.appendChild(source);
    articleTag.appendChild(fair);
    articleTag.appendChild(bias);
    ele.appendChild(articleTag);
}

