#include "MainWindow.h"
#include <QFont>
#include <QPalette>
#include <QFile>
#include <QTextStream>
#include <QStringList>
#include <QString>
#include <cmath>
#include <QIcon>
#include <QDebug>

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent), loudnessIndex(0), preampValue(-23.0) {
    setWindowTitle("ApoLoudness");
    setFixedSize(200, 50);
    setWindowFlags(Qt::WindowStaysOnTopHint);
    setWindowIcon(QIcon(":/Icons/ApoLoudness.ico"));


    label = new QLabel(this);
    label->setGeometry(0, 0, 200, 50);
    label->setFont(QFont("Arial", 20));
    label->setStyleSheet("QLabel { color: yellow; background-color: black; }");
    label->setAlignment(Qt::AlignCenter);


    timer = new QTimer(this);

    targetLoudness = {80.0, 81.0, 82.0, 83.0, 84.0, 85.0, 86.0, 87.0, 88.0, 89.0, 90.0};

    readConfig();
    updateConfig();
}

void MainWindow::updateConfig() {
    float ActualVol = std::round((preampValue + 83) * 10) / 10;
    ActualVol = std::min(ActualVol, targetLoudness[loudnessIndex]);

    label->setText(QString::number(ActualVol, 'f', 1) + "/" + QString::number(targetLoudness[loudnessIndex], 'f', 1) + " dB");

    QFile configFile("C:/Program Files/EqualizerAPO/config/Loudness.txt");
    if (!configFile.open(QIODevice::WriteOnly | QIODevice::Text)) {
        return;
    }
    QTextStream out(&configFile);

    out << "Preamp: " << preampValue << " dB\n";
    QString convFile = QString::number(ActualVol, 'f', 1) + "-" + QString::number(targetLoudness[loudnessIndex], 'f', 1) + "_filter.wav";
    out << "Convolution: " << convFile;

    configFile.close();
}

void MainWindow::wheelEvent(QWheelEvent *event) {
    if (rightButtonPressed && loudnessIndex >= 0 && loudnessIndex < targetLoudness.size()) {
        const float scrollDelta = 0.1;
        if (event->angleDelta().y() > 0) {
            preampValue += scrollDelta;
        } else {
            preampValue -= scrollDelta;
        }

        preampValue = std::max(std::min(preampValue, targetLoudness[loudnessIndex] - 83), -23.0f);
        updateConfig();
        event->accept();
    }
}

void MainWindow::mousePressEvent(QMouseEvent *event) {
    if (event->button() == Qt::RightButton) {
        rightButtonPressed = true;
    }
}

void MainWindow::mouseReleaseEvent(QMouseEvent *event) {
    if (event->button() == Qt::RightButton) {
        rightButtonPressed = false;
    } else if (event->button() == Qt::LeftButton && rightButtonPressed) {
        loudnessIndex = (loudnessIndex + 1) % targetLoudness.size();
        updateConfig();
        event->accept();
    }
}

void MainWindow::mouseDoubleClickEvent(QMouseEvent *event) {
    if (event->button() == Qt::LeftButton) {
        preampValue = -23;
        loudnessIndex = 0;
        updateConfig();

        event->accept();
    }
}

void MainWindow::readConfig() {
    QFile configFile("C:/Program Files/EqualizerAPO/config/Loudness.txt");
    if (!configFile.open(QIODevice::ReadOnly | QIODevice::Text)) {
        return;
    }

    QTextStream in(&configFile);
    QString preampLine = in.readLine();
    QString convLine = in.readLine();

    if (!preampLine.isEmpty()) {
        QStringList preampParts = preampLine.split(' ');
        if (preampParts.size() >= 2) {
            preampValue = preampParts[1].toDouble();
        }
    }

    double convVolumeA = -1;
    double convVolumeB = -1;

    if (!convLine.isEmpty()) {
        QRegExp regex("([0-9]+(?:\\.[0-9]*)?)-([0-9]+(?:\\.[0-9]*)?)");
        if (regex.indexIn(convLine) != -1) {
            convVolumeA = regex.cap(1).toDouble();
            convVolumeB = regex.cap(2).toDouble();
        }
    }

    configFile.close();

    loudnessIndex = -1;
    double minDifference = std::numeric_limits<double>::max();

    for (int i = 0; i < targetLoudness.size(); ++i) {
        double difference = std::abs(targetLoudness[i] - convVolumeB);
        if (difference < minDifference) {
            minDifference = difference;
            loudnessIndex = i;
        }
    }

    if (loudnessIndex != -1) {
        qDebug() << "Closest loudnessIndex found: " << loudnessIndex;
    } else {
        qDebug() << "No close loudnessIndex found. Defaulting to 0.";
        loudnessIndex = 0;
    }

    const double tolerance = 0.1;

    if (std::abs(-preampValue + convVolumeA - 83) > tolerance) {
        qDebug() << "Invalid values. Resetting...";
        preampValue = -23;
    } else {
        qDebug() << "Valid values. No reset needed.";
    }

    updateConfig();
}
