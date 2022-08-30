//
//  TapeShare.swift
//  TuringMachineSimulator
//
//  Created by Snow Lukin on 29.08.2022.
//

import Foundation

struct TapeShare: Codable {
    let id: Int64
    let headIndex: Int64
    let alphabet: String
    let input: String
}
