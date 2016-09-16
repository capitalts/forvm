#include <QApplication>
#include <QQmlApplicationEngine>
#include <QDesktopServices>
#include <QQuickView>
#include <QQmlContext>
#include "webpageviewer.h"
#include "clientsender.h"
#include "quickandroid.h"
int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    webPageViewer web;
    clientSender client;


    client.doConnect();
    client.update("MainThreads.xml");
//    QObject::connect(&app, SIGNAL(aboutToQuit()), &client, SLOT(closing()));
    QQmlApplicationEngine engine;
    engine.addImportPath("qrc:///");
    engine.rootContext()->setContextProperty("web", &web);
    engine.rootContext()->setContextProperty("client", &client);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
