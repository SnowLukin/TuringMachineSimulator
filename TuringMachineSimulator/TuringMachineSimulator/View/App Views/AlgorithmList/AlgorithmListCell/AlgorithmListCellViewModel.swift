//
//  AlgorithmListCellViewModel.swift
//  TuringMachineSimulator
//
//  Created by Snow Lukin on 26.09.2022.
//

import SwiftUI

class AlgorithmListCellViewModel: ObservableObject {
    func getAlgorithmEditedTimeForTextView(_ date: Date) -> String {
        if Calendar.current.isDateInYesterday(date) {
            return "Yesterday"
        }
        
        let formatter = DateFormatter()
        if Calendar.current.isDateInToday(date) {
            formatter.dateFormat = "HH:mm"
            return formatter.string(from: date)
        }
        formatter.dateFormat = "d MMM y"
        return formatter.string(from: date)
    }
}
