#include <iostream>
#include <QCoreApplication>
#include "optimaloffsetcalculator.h"

int main(int argc, char *argv[])
{
    QCoreApplication app(argc, argv);
    
    OptimalOffsetCalculator calculator;
    
    // Test case: Target = 81.0, Reference = 81.0, basePreamp = -10.00, actualPreamp = -10.00
    double targetPhon = 81.0;
    double basePreamp = -10.00;
    double actualPreamp = -10.00;
    
    double realSPL = calculator.calculateRealDbSpl(targetPhon, basePreamp, actualPreamp);
    
    std::cout << "Test Case: Target = " << targetPhon << " phon" << std::endl;
    std::cout << "Base Preamp = " << basePreamp << " dB" << std::endl;
    std::cout << "Actual Preamp = " << actualPreamp << " dB" << std::endl;
    std::cout << "Calculated Real SPL = " << realSPL << " dB" << std::endl;
    std::cout << std::endl;
    
    // Expected: Should extrapolate from 70.0 (77.7) and 80.0 (83.0)
    // Slope = (83.0 - 77.7) / (80.0 - 70.0) = 5.3 / 10 = 0.53
    // For 81.0: 83.0 + 0.53 * (81.0 - 80.0) = 83.0 + 0.53 = 83.53
    std::cout << "Expected Real SPL ≈ 83.53 dB (extrapolated)" << std::endl;
    
    // Test more cases
    std::cout << "\nAdditional test cases:" << std::endl;
    for (double target = 79.0; target <= 85.0; target += 1.0) {
        double realSPL = calculator.calculateRealDbSpl(target, -10.0, -10.0);
        std::cout << "Target " << target << " phon -> Real SPL = " << realSPL << " dB" << std::endl;
    }
    
    return 0;
}