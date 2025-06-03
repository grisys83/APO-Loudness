#include "preampextrapolator.h"
#include <QDebug>
#include <algorithm>
#include <limits>

PreampExtrapolator::PreampExtrapolator()
{
}

void PreampExtrapolator::addMeasurement(double referencePhon, double targetPhon, double measuredSPL)
{
    QPair<double, double> key(referencePhon, targetPhon);
    measurements[key] = measuredSPL;
    qDebug() << "Added measurement: Ref" << referencePhon << "Target" << targetPhon << "SPL" << measuredSPL;
}

double PreampExtrapolator::calculatePreamp(double targetPhon, double measuredSPL, double referencePhon)
{
    // Basic formula: preamp = measuredSPL - referencePhon
    // This ensures that when we apply the preamp, we get the measured SPL
    double baseOffset = measuredSPL - referencePhon;
    
    // Additional correction based on equal loudness contours
    // This is simplified - in reality, you'd use the full equal loudness curve data
    double correction = 0.0;
    
    if (targetPhon < referencePhon) {
        // Lower volumes need more boost in low frequencies
        correction = (referencePhon - targetPhon) * 0.1; // Simplified
    }
    
    return baseOffset + correction;
}

double PreampExtrapolator::extrapolatePreamp(double referencePhon, double targetPhon)
{
    QPair<double, double> key(referencePhon, targetPhon);
    
    // Check if we have exact measurement
    if (measurements.contains(key)) {
        double measuredSPL = measurements[key];
        return calculatePreamp(targetPhon, measuredSPL, referencePhon);
    }
    
    // Find measurements for this reference level
    QVector<double> targets;
    QVector<double> preamps;
    
    for (auto it = measurements.begin(); it != measurements.end(); ++it) {
        if (it.key().first == referencePhon) {
            double target = it.key().second;
            double spl = it.value();
            double preamp = calculatePreamp(target, spl, referencePhon);
            
            targets.append(target);
            preamps.append(preamp);
        }
    }
    
    if (targets.size() < 2) {
        qDebug() << "Not enough data for reference" << referencePhon;
        
        // Try to use data from nearby reference levels
        for (double refOffset = 1.0; refOffset <= 5.0; refOffset += 1.0) {
            for (double refSign : {-1.0, 1.0}) {
                double nearbyRef = referencePhon + refSign * refOffset;
                
                for (auto it = measurements.begin(); it != measurements.end(); ++it) {
                    if (std::abs(it.key().first - nearbyRef) < 0.1) {
                        double target = it.key().second;
                        double spl = it.value();
                        // Adjust for different reference level
                        double adjustedPreamp = calculatePreamp(target, spl, nearbyRef) + (nearbyRef - referencePhon);
                        
                        targets.append(target);
                        preamps.append(adjustedPreamp);
                    }
                }
                
                if (targets.size() >= 2) break;
            }
            if (targets.size() >= 2) break;
        }
    }
    
    if (targets.size() < 2) {
        // Fallback: use default curve
        return targetPhon - referencePhon;
    }
    
    // Sort by target for proper interpolation
    QVector<int> indices(targets.size());
    std::iota(indices.begin(), indices.end(), 0);
    std::sort(indices.begin(), indices.end(), [&targets](int i, int j) {
        return targets[i] < targets[j];
    });
    
    QVector<double> sortedTargets, sortedPreamps;
    for (int idx : indices) {
        sortedTargets.append(targets[idx]);
        sortedPreamps.append(preamps[idx]);
    }
    
    // Find interpolation range
    int lowerIdx = -1, upperIdx = -1;
    for (int i = 0; i < sortedTargets.size() - 1; ++i) {
        if (targetPhon >= sortedTargets[i] && targetPhon <= sortedTargets[i + 1]) {
            lowerIdx = i;
            upperIdx = i + 1;
            break;
        }
    }
    
    if (lowerIdx >= 0) {
        // Interpolate
        return linearInterpolate(sortedTargets[lowerIdx], sortedPreamps[lowerIdx],
                                sortedTargets[upperIdx], sortedPreamps[upperIdx],
                                targetPhon);
    } else {
        // Extrapolate using polynomial fitting
        QVector<double> coeffs = fitPolynomial(sortedTargets, sortedPreamps, std::min(2, static_cast<int>(sortedTargets.size() - 1)));
        return evaluatePolynomial(coeffs, targetPhon);
    }
}

QMap<double, double> PreampExtrapolator::generatePreampMap(double referencePhon, double minTarget, double maxTarget, double step)
{
    QMap<double, double> preampMap;
    
    for (double target = minTarget; target <= maxTarget; target += step) {
        double preamp = extrapolatePreamp(referencePhon, target);
        preampMap[target] = preamp;
    }
    
    return preampMap;
}

bool PreampExtrapolator::hasEnoughData(double referencePhon) const
{
    int count = 0;
    for (auto it = measurements.begin(); it != measurements.end(); ++it) {
        if (std::abs(it.key().first - referencePhon) < 0.1) {
            count++;
        }
    }
    return count >= 3; // At least 3 points for reasonable extrapolation
}

void PreampExtrapolator::clear()
{
    measurements.clear();
}

double PreampExtrapolator::linearInterpolate(double x1, double y1, double x2, double y2, double x)
{
    if (std::abs(x2 - x1) < 1e-10) return y1;
    return y1 + (y2 - y1) * (x - x1) / (x2 - x1);
}

QVector<double> PreampExtrapolator::fitPolynomial(const QVector<double> &x, const QVector<double> &y, int degree)
{
    Q_UNUSED(degree); // Currently only linear fitting is implemented
    
    // Simple polynomial fitting using least squares
    // For now, just do linear fitting (degree = 1)
    if (x.size() < 2) return {0.0};
    
    double sumX = 0, sumY = 0, sumXY = 0, sumX2 = 0;
    int n = x.size();
    
    for (int i = 0; i < n; ++i) {
        sumX += x[i];
        sumY += y[i];
        sumXY += x[i] * y[i];
        sumX2 += x[i] * x[i];
    }
    
    double denom = n * sumX2 - sumX * sumX;
    if (std::abs(denom) < 1e-10) {
        return {sumY / n}; // Constant function
    }
    
    double a = (n * sumXY - sumX * sumY) / denom; // Slope
    double b = (sumY - a * sumX) / n; // Intercept
    
    return {b, a}; // y = b + a*x
}

double PreampExtrapolator::evaluatePolynomial(const QVector<double> &coeffs, double x)
{
    if (coeffs.isEmpty()) return 0.0;
    
    double result = 0.0;
    double xPower = 1.0;
    
    for (double coeff : coeffs) {
        result += coeff * xPower;
        xPower *= x;
    }
    
    return result;
}

QPair<QPair<double, double>, QPair<double, double>> PreampExtrapolator::findClosestPoints(double referencePhon, double targetPhon)
{
    QPair<double, double> point1, point2;
    double minDist1 = std::numeric_limits<double>::max();
    double minDist2 = std::numeric_limits<double>::max();
    
    for (auto it = measurements.begin(); it != measurements.end(); ++it) {
        double ref = it.key().first;
        double target = it.key().second;
        
        // Calculate distance in ref-target space
        double dist = std::sqrt(std::pow(ref - referencePhon, 2) + std::pow(target - targetPhon, 2));
        
        if (dist < minDist1) {
            minDist2 = minDist1;
            point2 = point1;
            minDist1 = dist;
            point1 = it.key();
        } else if (dist < minDist2) {
            minDist2 = dist;
            point2 = it.key();
        }
    }
    
    return {point1, point2};
}