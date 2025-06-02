#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QLabel>
#include <QVector>
#include <QMap>
#include <QPoint>
#include <QMenu>
#include <QAction>

// QMouseEvent, QWheelEvent, QContextMenuEvent 헤더 추가
QT_BEGIN_NAMESPACE
class QMouseEvent;
class QWheelEvent;
class QContextMenuEvent;
QT_END_NAMESPACE

class MainWindow : public QMainWindow {
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

protected:
    // 이벤트 핸들러 프로토타입 추가
    void wheelEvent(QWheelEvent *event) override;
    void mousePressEvent(QMouseEvent *event) override;
    void mouseReleaseEvent(QMouseEvent *event) override;
    void mouseDoubleClickEvent(QMouseEvent *event) override;
    void mouseMoveEvent(QMouseEvent *event) override;
    void contextMenuEvent(QContextMenuEvent *event) override;

private slots:
    void toggleAlwaysOnTop();
    void showInfo();
    void exitApplication();

private:
    void updateConfig();
    void readConfig();
    double getRecommendedPreamp(double targetPhon, double referencePhon);
    void createContextMenu();

    QLabel *label;
    QMenu *contextMenu;
    QAction *alwaysOnTopAction;
    QAction *infoAction;
    QAction *exitAction;

    QVector<double> targetLoudness; // Reference Phon 목록
    int loudnessIndex;              // 현재 선택된 Reference Phon의 인덱스
    double targetPhonValue;         // 현재 선택된 Target Phon 값
    double preampUserOffset;        // 사용자가 권장 프리앰프 값에서 조정한 오프셋
    bool leftMouseButtonPressed;    // 좌클릭 버튼 눌림 상태
    QPoint dragPosition;            // 창 드래그 시작 위치
    bool isAlwaysOnTop;             // Always on top 상태
};

#endif // MAINWINDOW_H