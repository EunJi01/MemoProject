//
//  Array+Extension.swift
//  MemoProject
//
//  Created by 황은지 on 2022/09/03.
//

import Foundation

extension Array where Element: Hashable {
    func uniqueArrItems() -> [Element] {
        var dictAdded = [Element: Bool]()
        
        return filter {
            dictAdded.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.uniqueArrItems()
    }
}
