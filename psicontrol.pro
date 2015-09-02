TARGET = psicontrol

CONFIG += sailfishapp
QT += network

SOURCES += src/psicontrol.cpp \
    src/psic.cpp

HEADERS += \
    src/psic.h

OTHER_FILES += qml/psicontrol.qml \
    qml/cover/CoverPage.qml \
    rpm/psicontrol.spec \
    psicontrol.desktop \
    qml/pages/MainPage.qml


