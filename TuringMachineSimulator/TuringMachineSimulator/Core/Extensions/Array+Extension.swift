//
//  Array+Extension.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 28.12.2023.
//

import Foundation

extension Array {
    func at(_ index: Int) -> Element? {
        if index > self.count || index < 0 {
            return nil
        }
        return self[index]
    }
}
