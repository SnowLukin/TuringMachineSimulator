//
//  AlertWithTextField.swift
//  TuringMachineSimulator
//
//  Created by Snow Lukin on 27.08.2022.
//

import SwiftUI

extension View {
    func textfieldAlert(
        show: Binding<Bool>, text: Binding<String>, title: String = "",
        textfieldPlaceholder: String = "", disabledWhenEmpty: Bool = false,
        cancelAction: @escaping () -> (), saveAction: @escaping () -> ()
    ) -> some View {
        self.modifier(
            AlertTextFieldModifier(show: show, text: text, title: title, textfieldPlaceholder: textfieldPlaceholder, disabledWhenEmpty: disabledWhenEmpty, cancelAction: cancelAction, saveAction: saveAction)
        )
    }
}

struct AlertTextFieldModifier: ViewModifier {
    
    @Binding var show: Bool
    @Binding var text: String
    let title: String
    let textfieldPlaceholder: String
    let disabledWhenEmpty: Bool
    var cancelAction: () -> ()
    var saveAction: () -> ()
    
    func body(content: Content) -> some View {
        content
            .disabled(show)
            .transparentFullScreenCover(isPresented: $show) {
                AlertWithTextField(text: $text, title: title, textfieldPlaceholder: textfieldPlaceholder, disabledWhenEmpty: disabledWhenEmpty) {
                    cancelAction()
                } saveAction: {
                    saveAction()
                }
            }
//            .transaction({ transaction in
//                transaction.disablesAnimations = true
//            })
    }
}

struct AlertWithTextField: View {
    @Binding var text: String
    let title: String
    let textfieldPlaceholder: String
    let disabledWhenEmpty: Bool
    var cancelAction: () -> ()
    var saveAction: () -> ()
    
    @Environment(\.dismiss) private var dismiss
    @State private var opacity: CGFloat = 0
    @State private var backgroundOpacity: CGFloat = 1
    @State private var scale: CGFloat = 0.001
    @FocusState var focused: Bool
    
    var body: some View {
        ZStack {
            Color.black
                .opacity(0.12)
                .opacity(backgroundOpacity)
            VStack(spacing: 12) {
                VStack {
                    messageTitle()
                    textField()
                }
                .padding(.top)
                .padding(.horizontal)
                actionButtons()
            }
            .frame(width: 300)
            .background(Color(uiColor: .secondarySystemBackground))
            .cornerRadius(12)
            .padding(.bottom, focused ? 20 : 0)
        }
        .ignoresSafeArea()
        .transition(.opacity)
//        .onAppear {
//            focused = true
//        }
        .task {
            animate(isShown: true)
            focused = true
        }
    }
}

struct AlertWithTextField_Previews: PreviewProvider {
    static var previews: some View {
        AlertWithTextField(
            text: .constant(""), title: "Title",
            textfieldPlaceholder: "Placeholder", disabledWhenEmpty: false,
            cancelAction: {}, saveAction: {}
        )
    }
}

extension AlertWithTextField {
    @ViewBuilder
    private func actionButtons() -> some View {
        VStack(spacing: 0) {
            Divider()
            HStack(spacing: 3) {
                Button {
                    animate(isShown: false) {
                        dismiss()
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                        cancelAction()
                        text = ""
                    }
                } label: {
                    Text("Cancel")
                        .frame(height: 40)
                        .frame(maxWidth: .infinity)
                        .background(Color(uiColor: .secondarySystemBackground))
                }.background(Color(uiColor: .gray).opacity(0.1))
                
                Divider().frame(height: 40)
                
                Button {
                    animate(isShown: false) {
                        dismiss()
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                        saveAction()
                        text = ""
                    }
                } label: {
                    Text("Save")
                        .fontWeight(.semibold)
                        .frame(height: 40)
                        .frame(maxWidth: .infinity)
                        .background(Color(uiColor: .secondarySystemBackground))
                }
                .background(Color(uiColor: .gray).opacity(0.1))
                .disabled(
                    disabledWhenEmpty
                    ? text.trimmingCharacters(in: .whitespaces).isEmpty
                    : false
                )
            }
        }
    }
    
    @ViewBuilder
    private func textField() -> some View {
        ZStack {
            TextField(textfieldPlaceholder, text: $text)
                .focused($focused)
                .font(.subheadline)
                .padding(7)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(uiColor: .systemBackground))
        .cornerRadius(7)
        .overlay {
            RoundedRectangle(cornerRadius: 7)
                .strokeBorder(.gray, lineWidth: 1)
        }
    }
    
    @ViewBuilder
    private func messageTitle() ->  some View {
        Text(title)
            .font(.headline)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func animate(isShown: Bool, completion: (() -> Void)? = nil) {
        switch isShown {
        case true:
            opacity = 1
            
            withAnimation(.spring(response: 0.3, dampingFraction: 0.9, blendDuration: 0).delay(0.5)) {
                backgroundOpacity = 1
                scale             = 1
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                completion?()
            }
            
        case false:
            withAnimation(.easeOut(duration: 0.2)) {
                backgroundOpacity = 0
                opacity = 0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                completion?()
            }
        }
    }
}
