#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QLabel>
#include <QTimer> // QTimer는 현재 사용되지 않으므로 제거해도 됩니다.
#include <QVector>
#include <QMap>   // QMap 사용을 위해 추가
#include <QPoint>  // dragPosition 멤버 변수 타입을 위해 추가

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
    ~MainWindow(); // 소멸자 선언 추가

protected:
    // 이벤트 핸들러 프로토타입 추가
    void wheelEvent(QWheelEvent *event) override;
    void mousePressEvent(QMouseEvent *event) override;
    void mouseReleaseEvent(QMouseEvent *event) override;
    void mouseDoubleClickEvent(QMouseEvent *event) override;
    void mouseMoveEvent(QMouseEvent *event) override;       // mouseMoveEvent 선언 추가
    void contextMenuEvent(QContextMenuEvent *event) override; // contextMenuEvent 선언 추가 (선택 사항)

private:
    void updateConfig();
    void readConfig();
    double getRecommendedPreamp(double targetPhon, double referencePhon); // 함수 선언 추가

    QLabel *label;
    // QTimer *timer; // 사용되지 않으면 제거

    QVector<double> targetLoudness; // Reference Phon 목록
    int loudnessIndex;              // 현재 선택된 Reference Phon의 인덱스
    double targetPhonValue;         // 현재 선택된 Target Phon 값
    double preampUserOffset;        // 사용자가 권장 프리앰프 값에서 조정한 오프셋
    bool leftMouseButtonPressed;    // 좌클릭 버튼 눌림 상태
    QPoint dragPosition;            // 창 드래그 시작 위치 (FramelessWindowHint 사용 시)

    // recommendedPreampMap은 .cpp 파일에 const로 정의하는 것이 더 일반적일 수 있으나,
    // 헤더에 넣는다면 static const로 선언할 수 있습니다.
    // 여기서는 .cpp 파일에 두는 것을 가정합니다. (이전 코드처럼)
};

#endif // MAINWINDOW_H
