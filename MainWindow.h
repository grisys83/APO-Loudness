#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QLabel>
#include <QTimer>
#include <QVector>
#include <QWheelEvent>
#include <QMouseEvent>

class MainWindow : public QMainWindow {
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);

protected:
    void wheelEvent(QWheelEvent *event) override;
    void mousePressEvent(QMouseEvent *event) override;
    void mouseReleaseEvent(QMouseEvent *event) override;
    void mouseDoubleClickEvent(QMouseEvent *event) override;

private:
    QLabel *label;
    QTimer *timer;
    QVector<float> targetLoudness;
    int loudnessIndex;
    float preampValue;
    bool rightButtonPressed;

    void updateConfig();
    void readConfig();
};

#endif // MAINWINDOW_H
