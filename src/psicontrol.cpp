
#include <sailfishapp.h>
#include <QtQml>
#include <QScopedPointer>
#include <QQuickView>
#include <QQmlEngine>
#include <QGuiApplication>
#include <QQmlContext>
#include <QCoreApplication>

#include "psic.h"

int main(int argc, char *argv[])
{
    qmlRegisterType<psic>("harbour.psicontrol", 1, 0, "Psic");

    QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));
    QScopedPointer<QQuickView> view(SailfishApp::createView());
    view->setSource(SailfishApp::pathTo("qml/psicontrol.qml"));
    view->show();

    return app->exec();
}

