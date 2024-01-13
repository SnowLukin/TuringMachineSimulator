//
//  Direction.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 24.12.2023.
//

import SwiftUI

enum Direction: String, Identifiable, Hashable, Codable, CaseIterable {

    case stay
    case left
    case right

    var id: String {
        self.rawValue
    }

    var image: Image {
        switch self {
        case .stay: AppImages.stayDirection
        case .left: AppImages.leftDirection
        case .right: AppImages.rightDirection
        }
    }

    var intValue: Int {
        switch self {
        case .stay: 0
        case .left: 1
        case .right: 2
        }
    }

    static func make(from int: Int) -> Direction {
        switch int {
        case 1: Direction.left
        case 2: Direction.right
        default: Direction.stay
        }
    }
}
