#ifndef WINDOW_H
#define WINDOW_H

#include <QObject>
#include <QApplication>
#include <QIcon>
#include <QQuickItemGrabResult>

class Window : public QObject
{
    Q_OBJECT
private:
    QApplication *app;
public:
    Window(QApplication *app){
        this->app=app;
    }
    Q_INVOKABLE void setIcon(QObject* result){
        QQuickItemGrabResult *item = qobject_cast<QQuickItemGrabResult*>(result);
        app->setWindowIcon(QIcon(QPixmap::fromImage(item->image())));
    }
signals:

public slots:
};

#endif // WINDOW_H
