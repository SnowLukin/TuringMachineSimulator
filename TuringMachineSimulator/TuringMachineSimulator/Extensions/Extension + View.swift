//
//  Extension + View.swift
//  TuringMachineSimulator
//
//  Created by Snow Lukin on 29.08.2022.
//

import SwiftUI

extension View {
    // Root View Controller
    func getRootController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        return root
    }
    
    func alertTextField(title: String, message: String, hintText: String, primaryTitle: String, secondaryTitle: String, primaryAction: @escaping (String)->(), secondaryAction: @escaping ()->()) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addTextField { textfield in
            textfield.placeholder = hintText
        }
        
        alert.addAction(.init(title: secondaryTitle, style: .cancel) { _ in
            secondaryAction()
        })
        
        alert.addAction(.init(title: primaryTitle, style: .default) { _ in
            if let text = alert.textFields?[0].text {
                primaryAction(text)
            } else {
                primaryAction("")
            }
        })
        
        // Presenting alert
        getRootController().present(alert, animated: true)
    }
}
