#include "psic.h"
#include <QDebug>
#include <QThread>

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
        lastHost = host;
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

    /* If connection dropped, brutally reconnect */
    if(socket->state() != QAbstractSocket::ConnectedState)
        connectToHost(lastHost);

    socket->write(data.toLocal8Bit());

    QThread::msleep(25);

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

