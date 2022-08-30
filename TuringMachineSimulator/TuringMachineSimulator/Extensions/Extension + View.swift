//
//  Extension + View.swift
//  TuringMachineSimulator
//
//  Created by Snow Lukin on 29.08.2022.
//

import SwiftUI

extension View {
    func withoutAnimation(action: @escaping () -> Void) {
        var transaction = Transaction()
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            action()
        }
    }
}
