#ifndef CONNECTWINDOW_H
#define CONNECTWINDOW_H

#include <QObject>
#include <QQuickView>
#include <QQuickItem>

class ConnectWindow : public QObject
{
    Q_OBJECT
public:
    explicit ConnectWindow(QObject *parent = nullptr);
    ~ConnectWindow();

    void setWindow(QQuickWindow *window);
    void connectSignalSlot();

signals:
    void signalDeviceConnect(QVariant);

private:
    QQuickWindow *mainView;

};

#endif // CONNECTWINDOW_H
