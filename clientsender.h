#ifndef CLIENTSENDER_H
#define CLIENTSENDER_H

#include <QObject>
#include <QFile>
#include <QTcpSocket>
#include <QAbstractSocket>
#include <QXmlStreamReader>
#include <QXmlStreamWriter>
#include <QtXml>
#include <ctime>
#include <QClipboard>
#include <QApplication>


class clientSender : public QObject
{
    Q_OBJECT
private:
    QTcpSocket* socket;
    bool onStart = true;
    QDir appDir;
    void articleAdder(QDomDocument file, QString article);


public:
    explicit clientSender(QObject *parent = 0);
    Q_INVOKABLE void sendPost(QString file, QString articles, QString postText, QString icon);
    Q_INVOKABLE void addArticle(QString file, QString article);
    Q_INVOKABLE void fairVote(QString file, QString article);
    Q_INVOKABLE void biasVote(QString file, QString article);
    Q_INVOKABLE void newThread(QString title, QString article, QString text, QString icon, QString fileName);
    Q_INVOKABLE void update(QString fileName);
    Q_INVOKABLE QString getAppPath(QString fileName);
    Q_INVOKABLE void copy(QString text);
    void doConnect();
signals:
    void finishedReading();
public slots:
    void connected();
    void disconnected();
    void bytesWritten(qint64 bytes);
    void readyToRead();
    void closing();
};

#endif // CLIENTSENDER_H
