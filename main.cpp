#include <QApplication>
#include <QQmlApplicationEngine>
#include <QDesktopServices>
#include <QQuickView>
#include <QQmlContext>
#include "webpageviewer.h"
#include "clientsender.h"
int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    webPageViewer web;
    clientSender client;
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("web", &web);
    engine.rootContext()->setContextProperty("client", &client);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
