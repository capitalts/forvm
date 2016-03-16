#include <QApplication>
#include <QQmlApplicationEngine>
#include <QDesktopServices>
#include <QQuickView>
#include <QQmlContext>
#include "webpageviewer.h"
int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    webPageViewer web;
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("web", &web);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
