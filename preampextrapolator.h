#ifndef PREAMPEXTRAPOLATOR_H
#define PREAMPEXTRAPOLATOR_H

#include <QMap>
#include <QPair>
#include <QVector>
#include <cmath>

class PreampExtrapolator
{
public:
    PreampExtrapolator();
    
    // Add a measured data point
    void addMeasurement(double referencePhon, double targetPhon, double measuredSPL);
    
    // Extrapolate preamp for a given reference/target combination
    double extrapolatePreamp(double referencePhon, double targetPhon);
    
    // Generate full preamp map for a reference level based on partial measurements
    QMap<double, double> generatePreampMap(double referencePhon, double minTarget = 40.0, double maxTarget = 85.0, double step = 0.1);
    
    // Check if we have enough data for reliable extrapolation
    bool hasEnoughData(double referencePhon) const;
    
    // Clear all measurements
    void clear();
    
private:
    // Storage: <reference, target> -> measured SPL
    QMap<QPair<double, double>, double> measurements;
    
    // Helper functions
    double calculatePreamp(double targetPhon, double measuredSPL, double referencePhon);
    
    // Polynomial fitting for extrapolation
    QVector<double> fitPolynomial(const QVector<double> &x, const QVector<double> &y, int degree = 2);
    double evaluatePolynomial(const QVector<double> &coeffs, double x);
    
    // Linear interpolation/extrapolation
    double linearInterpolate(double x1, double y1, double x2, double y2, double x);
    
    // Find the two closest measured points for interpolation
    QPair<QPair<double, double>, QPair<double, double>> findClosestPoints(double referencePhon, double targetPhon);
};

#endif // PREAMPEXTRAPOLATOR_H