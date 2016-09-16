TEMPLATE = app

QT += qml quick widgets network xml

SOURCES += main.cpp \
    webpageviewer.cpp \
    clientsender.cpp

RESOURCES += qml.qrc


# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH += $$PWD

# Default rules for deployment.
include(vendor/vendor.pri)
include(deployment.pri)

DISTFILES +=

HEADERS += \
    webpageviewer.h \
    clientsender.h
