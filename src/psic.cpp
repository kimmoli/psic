#include "psic.h"
#include <QDebug>

psic::psic(QObject *parent) :
    QObject(parent)
{
    qDebug() << "initialising";

    socket = new QTcpSocket(this);
    connect(socket, SIGNAL(readyRead()), this, SLOT(readyRead()));
}

psic::~psic()
{
    socket->disconnectFromHost();
    qDebug() << "quitting";
}

void psic::readyRead()
{
    QByteArray temp = socket->readAll();
    rxBuffer = QString(temp);

    qDebug() << "reading" << temp;
    emit newDataAvailable();

}

void psic::connectToHost(QString host)
{
    qDebug() << "connecting to host" << host;

    socket->connectToHost(host, 5025);

    if (socket->waitForConnected())
    {
        qDebug() << "success";
        emit connectSuccess();
    }
    else
    {
        qDebug() << "fail -" << socket->errorString();
        emit connectFail();
    }
}

void psic::writeData(QString data)
{
    qDebug() << "writing" << data;

    if(socket->state() != QAbstractSocket::ConnectedState)
    {
        qDebug() << "fail - not connected";
        emit writeFail();
        return;
    }

    socket->write(data.toLocal8Bit());

    if (socket->waitForBytesWritten())
    {
        qDebug() << "success";
        emit writeSuccess();
    }
    else
    {
        qDebug() << "fail -" << socket->errorString();
        emit writeFail();
    }
}

QString psic::readData()
{
    return rxBuffer;
}

