//
//  OptionShare.swift
//  TuringMachineSimulator
//
//  Created by Snow Lukin on 29.08.2022.
//

import Foundation

struct OptionShare: Codable {
    let id: Int64
    let toStateID: Int64
    let combinations: [CombinationShare]
}
