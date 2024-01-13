//
//  String+Extension.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 15.12.2023.
//

import Foundation

extension Optional {
    func withDefaultValue(_ value: Wrapped) -> Wrapped {
        self ?? value
    }
}
