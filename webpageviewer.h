#ifndef WEBPAGEVIEWER_H
#define WEBPAGEVIEWER_H

#include <QObject>
#include <QDesktopServices>
#include <QUrl>
class webPageViewer : public QObject
{
    Q_OBJECT
public:
    webPageViewer();
    Q_INVOKABLE void openWebPage(QUrl url){
        QDesktopServices::openUrl(url);
    }
};

#endif // WEBPAGEVIEWER_H
