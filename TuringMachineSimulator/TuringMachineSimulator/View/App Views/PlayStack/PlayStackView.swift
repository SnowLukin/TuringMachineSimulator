//
//  PlayStack.swift
//  TuringMachineSimulator
//
//  Created by Snow Lukin on 24.08.2022.
//

import SwiftUI

struct PlayStackView: View {
    
    @ObservedObject var algorithm: Algorithm
    
    @Binding var isChanged: Bool
    
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel = PlayStackViewModel()
    @State private var isPlaying: Bool = false
    @State private var isPlayOptionOn: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                VStack(spacing: 20) {
                    if isPlayOptionOn {
                        playButton
                            .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.2)))
                        makeStepButton
                            .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.2)))
                        resetButton
                            .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.2)))
                    }
                    playOptionButton
                }.padding(30)
            }
        }
    }
}

struct PlayStack_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let folder = context.registeredObjects.first(where: { $0 is Folder }) as! Folder
        let algorithm = folder.wrappedAlgorithms[0]
        PlayStackView(algorithm: algorithm, isChanged: .constant(false))
            .environment(\.managedObjectContext, context)
    }
}

extension PlayStackView {
    
    private func autoPlay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            if isPlaying {
                viewModel.makeStep(algorithm: algorithm, viewContext: viewContext)
                autoPlay()
            }
        }
    }
    
    private func makeStep() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            viewModel.makeStep(algorithm: algorithm, viewContext: viewContext)
        }
    }
    
    private var playButton: some View {
        Button {
            withAnimation {
                isChanged = true
                isPlaying.toggle()
            }
            autoPlay()
        } label: {
            Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                .font(.title2)
                .frame(width: 50, height: 50)
                .foregroundColor(.blue)
                .background(Color(uiColor: .secondarySystemBackground))
                .clipShape(Circle())
                .shadow(radius: 10)
        }
    }
    
    private var playOptionButton: some View {
        Button {
            withAnimation {
                isPlayOptionOn.toggle()
            }
        } label: {
            Image(systemName: "chevron.up")
                .font(.title2.bold())
                .frame(width: 50, height: 50)
                .foregroundColor(.blue)
                .background(Color(uiColor: .secondarySystemBackground))
                .clipShape(Circle())
                .shadow(radius: 10)
                .rotationEffect(.degrees(isPlayOptionOn ? -180 : 0))
        }
    }
    
    private var makeStepButton: some View {
        Button {
            withAnimation {
                isChanged = true
                makeStep()
            }
        } label: {
            Image(systemName: "forward.frame.fill")
                .font(.title2)
                .frame(width: 50, height: 50)
                .foregroundColor(.blue)
                .background(Color(uiColor: .secondarySystemBackground))
                .clipShape(Circle())
                .shadow(radius: 10)
        }
    }
    
    private var resetButton: some View {
        Button {
            withAnimation {
                isChanged = false
                viewModel.reset(algorithm: algorithm, viewContext: viewContext)
            }
        } label: {
            Image(systemName: "stop.fill")
                .font(.title2)
                .frame(width: 50, height: 50)
                .foregroundColor(.red)
                .background(Color(uiColor: .secondarySystemBackground))
                .clipShape(Circle())
                .shadow(radius: 10)
        }
        .disabled(isPlaying)
        .opacity(isPlaying ? 0.6 : 1)
    }
}
