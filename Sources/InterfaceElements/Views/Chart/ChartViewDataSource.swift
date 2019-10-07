//
//  ChartViewDataSource.swift
//  
//
//  Created by Neil Smith on 07/10/2019.
//

import Foundation

public protocol ChartViewDataSource: AnyObject {
    func bars(for chartView: ChartView) -> [ChartBar]
    func state(forBarAt index: Int) -> ChartView.CellState?
}
