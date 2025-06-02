#include <QApplication>
#include "MainWindow.h"

int main(int argc, char *argv[]) {
    QApplication app(argc, argv);
    
    // 애플리케이션 정보 설정
    app.setApplicationName("ApoLoudness");
    app.setApplicationVersion("0.3");
    app.setOrganizationName("grisys");
    
    MainWindow window;
    window.show();
    return app.exec();
}