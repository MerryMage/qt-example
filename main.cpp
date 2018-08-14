#include <QApplication>
#include <QDebug>
#include <QPushButton>

int main(int argc, char *argv[]) {
    QApplication a(argc, argv);
    qDebug() << QT_VERSION_STR;

    QPushButton button("Hello world !");
    button.setText("My text");
    button.setToolTip("A tooltip");
    button.show();

    return a.exec();
}
