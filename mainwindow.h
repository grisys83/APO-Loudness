#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QLabel>
#include <QMenu>
#include <QAction>
#include <QWheelEvent>
#include <QMouseEvent>
#include <QContextMenuEvent>
#include <QVector>
#include <QPoint>
#include <QTimer>
#include "optimaloffsetcalculator.h"

#ifdef Q_OS_WIN
#include <windows.h>
#endif

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

protected:
    void wheelEvent(QWheelEvent *event) override;
    void mousePressEvent(QMouseEvent *event) override;
    void mouseMoveEvent(QMouseEvent *event) override;
    void mouseReleaseEvent(QMouseEvent *event) override;
    void mouseDoubleClickEvent(QMouseEvent *event) override;
    void contextMenuEvent(QContextMenuEvent *event) override;
    bool nativeEvent(const QByteArray &eventType, void *message, qintptr *result) override;

private slots:
    void toggleAlwaysOnTop();
    void toggleAutoOffset();
    void toggleCalibrationMode();
    void showInfo();
    void exitApplication();
    void checkGlobalMouseState();

private:
    void createContextMenu();
    void updateConfig();
    void readConfig();
    double getRecommendedPreamp(double targetPhon, double referencePhon);
    double findClosestTargetToRealSPL(double currentRealSPL);
    void handleGlobalWheel(int delta);
    void installGlobalHook();
    void uninstallGlobalHook();

    // UI 컴포넌트
    QLabel *label;

    // 메뉴 관련
    QMenu *contextMenu;
    QAction *alwaysOnTopAction;
    QAction *autoOffsetAction;
    QAction *calibrationModeAction;
    QAction *infoAction;
    QAction *exitAction;

    // 상태 변수들
    QVector<double> targetLoudness;
    int loudnessIndex;
    double targetPhonValue;
    double preampUserOffset;

    // 마우스 드래그 관련
    bool leftMouseButtonPressed;
    QPoint dragPosition;

    // 옵션 플래그들
    bool isAlwaysOnTop;
    bool isAutoOffset;
    bool isCalibrationMode;
    
    // Optimal Offset Calculator
    OptimalOffsetCalculator optimalCalculator;
    
    // 글로벌 마우스 후킹
    QTimer *globalMouseTimer;
    bool globalRightMousePressed;
    
#ifdef Q_OS_WIN
    static HHOOK mouseHook;
    static MainWindow* instance;
    static LRESULT CALLBACK MouseProc(int nCode, WPARAM wParam, LPARAM lParam);
#endif
};

#endif // MAINWINDOW_H
