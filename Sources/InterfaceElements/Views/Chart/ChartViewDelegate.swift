//
//  ChartViewDelegate.swift
//  
//
//  Created by Neil Smith on 17/09/2019.
//

import UIKit

public protocol ChartViewDelegate: AnyObject {
    func chartView(_ chartView: ChartView, didUpdateCurrentlyActiveBarAt indexPath: IndexPath?)
}
