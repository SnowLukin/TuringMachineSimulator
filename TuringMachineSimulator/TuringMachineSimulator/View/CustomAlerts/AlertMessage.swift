//
//  AlertMessage.swift
//  TuringMachineSimulator
//
//  Created by Snow Lukin on 27.08.2022.
//

import SwiftUI

extension View {
    func alert(show: Binding<Bool>, title: String = "", subTitle: String = "", action: @escaping () -> ()) -> some View {
        self.modifier(AlertModifier(show: show, title: title, subTitle: subTitle, action: action))
    }
}

struct AlertModifier: ViewModifier {
    
    @Binding var show: Bool
    let title: String
    let subTitle: String
    var action: () -> ()
    
    func body(content: Content) -> some View {
        content
            .disabled(show)
            .transparentFullScreenCover(isPresented: $show) {
                AlertMessage(title: title, subTitle: subTitle) {
                    action()
                }
            }
    }
}

struct AlertMessage: View {
    let title: String
    let subTitle: String
    let action: () -> ()
    
    init(title: String = "", subTitle: String = "", action: @escaping () -> ()) {
        self.title = title
        self.subTitle = subTitle
        self.action = action
    }
    
    @Environment(\.dismiss) private var dismiss
    @State private var opacity: CGFloat = 0
    @State private var backgroundOpacity: CGFloat = 1
    @State private var scale: CGFloat = 0.001
    
    var body: some View {
        ZStack {
            Color.black
                .opacity(0.12)
                .opacity(backgroundOpacity)
            VStack(spacing: 12) {
                VStack(spacing: 5) {
                    messageTitle()
                    messageDetails()
                }
                .padding(.top)
                .padding(.horizontal)
                actionButton()
            }
            .frame(width: 300)
            .background(Color(uiColor: .secondarySystemBackground))
            .cornerRadius(12)
        }
        .ignoresSafeArea()
        .transition(.opacity)
        .task {
            animate(isShown: true)
        }
    }
}

struct AlertMessage_Previews: PreviewProvider {
    static var previews: some View {
        AlertMessage(title: "Title", subTitle: "Message", action: {})
    }
}

extension AlertMessage {
    @ViewBuilder
    private func messageTitle() -> some View {
        Text(title)
            .font(.headline)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity, alignment: .center)
    }
    
    @ViewBuilder
    private func messageDetails() -> some View {
        Text(subTitle)
            .font(.subheadline)
            .frame(maxWidth: .infinity, alignment: .center)
    }
    
    @ViewBuilder
    private func actionButton() -> some View {
        VStack(spacing: 0) {
            Divider()
            Button {
                withAnimation {
                    animate(isShown: false) {
                        dismiss()
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                        action()
                    }
                }
            } label: {
                Text("OK")
                    .frame(height: 40)
                    .frame(maxWidth: .infinity)
                    .background(Color(uiColor: .secondarySystemBackground))
            }
            .background(Color(uiColor: .gray).opacity(0.1))
        }
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
                opacity           = 0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                completion?()
            }
        }
    }
}
