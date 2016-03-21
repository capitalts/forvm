#include "clientsender.h"
#include <QtCore/QDebug>
clientSender::clientSender(QObject *parent) : QObject(parent)
{

    socket = new QTcpSocket(this);
    socket->connectToHost("127.0.0.1", 1234);
}

void clientSender::sendPost(QString file, QString articles[], QString postText, QString icon)
{
    QDomDocument doc;
    QFile newFile(file);
    doc.setContent(&newFile);
    QDomProcessingInstruction procInst = doc.createProcessingInstruction("xml", "version=\"1.0\"");
    QDomElement header = doc.createElement("header");
    doc.appendChild(procInst);
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

void clientSender::addArticle(QString file, QString article)
{
    QDomDocument doc;
    QFile newFile(file);
    doc.setContent(&newFile);
    articleAdder(doc, article);
    QByteArray array = doc.toByteArray();
    socket->write(array);
}

void clientSender::fairVote(QString file, QString article)
{
    QDomDocument doc;
    QFile newFile(file);
    doc.setContent(&newFile);
    QDomProcessingInstruction procInst = doc.createProcessingInstruction("xml", "version=\"1.0\"");
    QDomElement header = doc.createElement("header");
    header.setNodeValue("fair");
    doc.appendChild(procInst);
    QDomNode ele = doc.firstChildElement("root");
    QDomElement articles = ele.firstChildElement("article");
    QDomNode articleTag = articles.firstChild();
    if(articleTag.firstChildElement("source").nodeValue() == article){
        QDomNode fairTag = articleTag.firstChildElement("fair");
        int fairVal = fairTag.nodeValue().toInt();
        fairVal++;
        fairTag.replaceChild(doc.createTextNode(QString::number(fairVal)), fairTag.firstChild());
    }else{
        articleTag = articleTag.nextSibling();
    }
    QByteArray array = doc.toByteArray();
    socket->write(array);
}

void clientSender::biasVote(QString fileName, QString article)
{
    QFile file(fileName);
    file.open(QIODevice::ReadWrite | QIODevice::Truncate);
    QDomDocument doc;
    doc.setContent(&file);
    QDomProcessingInstruction procInst = doc.createProcessingInstruction("xml", "version=\"1.0\"");
    QDomElement header = doc.firstChildElement("header");
    header.setNodeValue("bias");
    doc.appendChild(procInst);
    QDomNode ele = doc.firstChildElement("root");
    QDomElement articles = ele.firstChildElement("article");
    QDomNode articleTag = articles.firstChild();
    if(articleTag.firstChildElement("source").nodeValue() == article){
        QDomNode biasTag = articleTag.firstChildElement("bias");
        int biasVal = biasTag.nodeValue().toInt();
        biasVal++;
        biasTag.replaceChild(doc.createTextNode(QString::number(biasVal)), biasTag.firstChild());
    }else{
        articleTag = articleTag.nextSibling();
    }
    QByteArray array = doc.toByteArray();
    file.write(array);
    if(socket->isOpen()){
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
    QDomElement header = doc.elementById("header");
    header.setNodeValue("newThread");
    doc.appendChild(procInst);
    QDomElement root = doc.createElement("root");
    root.attribute(title + now);
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
    thread.appendChild(head);
    thread.appendChild(arts);
    thread.appendChild(posts);
    root.appendChild(thread);
    doc.appendChild(root);
    QByteArray array = doc.toByteArray();
    socket->write(array);

}

void clientSender::update(QString fileName)
{
    QFile file(fileName);

    if(file.open(QIODevice::ReadWrite)){
        socket->write(file.readAll());
        if(socket->waitForReadyRead()){
            if(socket->isReadable()){
                file.write(socket->readAll());
            }
            else{
                qDebug() << "Socket not readable";
            }
        }else{
            socket->error();
        }
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
    fair.setNodeValue("0");
    bias.setNodeValue("0");
    articleTag.appendChild(source);
    articleTag.appendChild(fair);
    articleTag.appendChild(bias);
    ele.appendChild(articleTag);
}

