//
//  RangeReplaceableCollection+Ext.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

extension RangeReplaceableCollection {
    
    var kShuffled: Self {
        var element = self
        return element.shuffledInPlace()
    }
    
    @discardableResult
    mutating func shuffledInPlace() -> Self {
        indices.dropLast().forEach({
            let subSequence = self[$0...$0]
            let distance = self.distance(from: startIndex, to: $0)
            let index = self.index(indices[..<self.index(endIndex, offsetBy: -distance)].randomElement()!, offsetBy: distance)
            replaceSubrange($0...$0, with: self[index...index])
            replaceSubrange(index...index, with: subSequence)
        })
        
        return self
    }
    
    //Chọn 3 số ngẫu nhiên
    func shoose(_ n: Int) -> SubSequence { kShuffled.prefix(n) }
}
