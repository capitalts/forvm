TEMPLATE = app

QT += qml quick widgets network xml

SOURCES += main.cpp \
    webpageviewer.cpp \
    clientsender.cpp

RESOURCES += qml.qrc


# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH +=

# Default rules for deployment.
include(deployment.pri)

DISTFILES += \
    ../../Qtprojects/QmlTutorials/file.qml

HEADERS += \
    webpageviewer.h \
    clientsender.h
