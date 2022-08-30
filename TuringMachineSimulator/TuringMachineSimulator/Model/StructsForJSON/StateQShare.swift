//
//  StateQShare.swift
//  TuringMachineSimulator
//
//  Created by Snow Lukin on 29.08.2022.
//

import Foundation

struct StateQShare: Codable {
    let id: Int64
    let isForReset: Bool
    let isStarting: Bool
    let options: [OptionShare]
}
