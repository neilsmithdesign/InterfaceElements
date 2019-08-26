//
//  ChartBar.swift
//  
//
//  Created by Neil Smith on 26/08/2019.
//

import UIKit

public struct ChartBar {
    let x: Double // time value (e.g. 300 == 5 minute segement)
    let y: Double // effort level value (e.g. between 1 and 10
    let color: UIColor
    public init(x: Double, y: Double, color: UIColor) {
        self.x = x
        self.y = y
        self.color = color
    }
}


// MARK: Convenience properties
public extension Array where Element == ChartBar {
    
    var minY: ChartBar? {
        return self.min(by: { $0.y < $1.y })
    }
    
    var maxY: ChartBar? {
        return self.max(by: { $0.y < $1.y })
    }
    
    var totalX: Double {
        return self.map { $0.x }.reduce(0, +)
    }
    
}
