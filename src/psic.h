#ifndef PSIC_H
#define PSIC_H

#include <QObject>
#include <qtcpsocket.h>

class psic : public QObject
{
    Q_OBJECT
public:
    explicit psic(QObject *parent = 0);
    ~psic();

    Q_INVOKABLE void connectToHost(QString host);
    Q_INVOKABLE void writeData(QString data);
    Q_INVOKABLE QString readData();

signals:
    void newDataAvailable();
    void connectSuccess();
    void connectFail();
    void writeSuccess();
    void writeFail();

public slots:
    void readyRead();

private:
    QTcpSocket *socket;
    QString rxBuffer;
};

#endif // PSIC_H
