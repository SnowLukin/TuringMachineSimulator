//
//  String+Extension.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 28.12.2023.
//

import Foundation

extension String {
    func at(_ index: Int, defaultValue: Character? = nil) -> String {
        if index > self.count || index < 0 {
            guard let defaultValue else { return "" }
            return String(defaultValue)
        }
        let strIndex = self.index(self.startIndex, offsetBy: index)
        return String(self[strIndex])
    }

    func includePadding(_ char: Character = "_", count: Int = 200) -> String {
        let padding = String(repeating: char, count: count)
        return padding + self + padding
    }

    func trim(_ char: String = "_") -> String {
        self.trimmingCharacters(in: CharacterSet(charactersIn: char))
    }
}
