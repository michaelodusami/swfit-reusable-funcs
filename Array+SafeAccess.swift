//
//  Array+SafeAccess.swift
//  YourProject
//
//

import Foundation

public extension Array {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
    /// Returns a subarray safely for the given Range if valid; otherwise, returns an empty array.
    func safeSubarray(range: Range<Int>) -> [Element] {
        let lowerBound = Swift.max(range.lowerBound, startIndex)
        let upperBound = Swift.min(range.upperBound, endIndex)
        guard lowerBound < upperBound else { return [] }
        return Array(self[lowerBound..<upperBound])
    }
    
    /// Returns a subarray safely for the given ClosedRange if valid; otherwise, returns an empty array.
    func safeSubarray(range: ClosedRange<Int>) -> [Element] {
        let lowerBound = Swift.max(range.lowerBound, startIndex)
        let upperBound = Swift.min(range.upperBound, endIndex - 1)
        guard lowerBound <= upperBound else { return [] }
        return Array(self[lowerBound...upperBound])
    }
}
