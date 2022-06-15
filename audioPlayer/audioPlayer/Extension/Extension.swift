//
//  View.swift
//  audioPlayer
//
//  Created by Vitaliy Shmelev on 14.06.2022.
//

import Foundation

extension TimeInterval {
    func getFormattedTime() -> String {
        let mins = self / 60
        let secs = self.truncatingRemainder(dividingBy: 60)
        let timeFormatter = NumberFormatter()
        timeFormatter.minimumIntegerDigits = 2
        timeFormatter.minimumFractionDigits = 0
        timeFormatter.roundingMode = .down
        
        guard let minStr = timeFormatter.string(from: NSNumber(value: mins)), let secStr = timeFormatter.string(from: NSNumber(value: secs)) else {
            return "00:00"
        }
        
        return "\(minStr):\(secStr)"
    }
}
