//
//  AlgorithmShare.swift
//  TuringMachineSimulator
//
//  Created by Snow Lukin on 29.08.2022.
//

import Foundation

struct AlgorithmShare: Codable {
    let name: String
    let algorithmDescription: String
    let states: [StateQShare]
    let tapes: [TapeShare]
}
