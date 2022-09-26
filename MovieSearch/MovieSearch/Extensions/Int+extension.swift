//
//  Int+extension.swift
//  MovieSearch
//
//  Created by Seul Mac on 2022/08/31.
//

import Foundation

extension Int {
    func addComma() -> String {
        let numberformatter = NumberFormatter()
        numberformatter.numberStyle = .decimal
        let convertedNumber = numberformatter.string(for: self) ?? ""
        return convertedNumber
    }
}
