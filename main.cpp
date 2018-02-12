#include <QApplication>
#include <QQmlApplicationEngine>
#include <QtWebEngine/QtWebEngine>
#include "./window.h"


int main(int argc, char *argv[])
{
    QApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QApplication app(argc, argv);

    QtWebEngine::initialize();

    QQmlApplicationEngine engine;

    Window *w=new Window(&app);
    engine.rootContext()->setContextProperty("window", w);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
