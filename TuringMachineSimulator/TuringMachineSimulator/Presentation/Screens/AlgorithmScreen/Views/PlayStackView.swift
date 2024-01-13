//
//  PlayStackView.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 16.12.2023.
//

import SwiftUI

struct PlayStackView: View {

    @ObservedObject var viewModel: AlgorithmViewModel

    init(viewModel: AlgorithmViewModel) {
        self.viewModel = viewModel
    }

    @State var isPlaying = false
    @State var isPlayOptionOn = false

    var body: some View {
        ZStack {
            ZStack {
                playButton
                    .offset(y: isPlayOptionOn ? -180 : 0)
                stepButton
                    .offset(y: isPlayOptionOn ? -120 : 0)
                resetButton
                    .offset(y: isPlayOptionOn ? -60 : 0)
            }.opacity(isPlayOptionOn ? 1 : 0)
            sectionButton
        }
    }
}

// #Preview {
//    let algorithmService = FakeAlgorithmService()
//    let machineStateService = FakeMachineStateCDService()
//    let tapeService = FakeTapeCDService()
//    let algorithmRepository = AlgorithmRepository(service: algorithmService)
//    let machineStateRepository = MachineStateRepository(service: machineStateService)
//    let tapeRepository = TapeRepository(service: tapeService)
//    let viewModel = AlgorithmViewModel(
//        algorithm: Algorithm.sample,
//        algorithmRepository: algorithmRepository,
//        machineStateRepository: machineStateRepository,
//        tapeRepository: tapeRepository
//    )
//    return PlayStackView(viewModel: viewModel)
// }

extension PlayStackView {

    private var playButton: some View {
        Button {
            withAnimation {
                isPlaying.toggle()
                if isPlaying {
                    viewModel.startAutoSteps()
                } else {
                    viewModel.pauseAutoSteps()
                }
            }
        } label: {
            Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                .makeCircly()
        }.buttonStyle(.plain)
    }

    private var sectionButton: some View {
        Button {
            withAnimation(.bouncy) {
                isPlayOptionOn.toggle()
            }
        } label: {
            Image(systemName: "chevron.up")
                .makeCircly(foreground: .primary, background: .secondaryBackground)
                .rotationEffect(.degrees(isPlayOptionOn ? -180 : 0))
        }.buttonStyle(.plain)
    }

    private var stepButton: some View {
        Button {
            withAnimation {
                viewModel.makeStep()
            }
        } label: {
            Image(systemName: "forward.frame.fill")
                .makeCircly()
        }
        .buttonStyle(.plain)
        .disabled(isPlaying)
        .opacity(isPlaying ? 0.6 : 1)
    }

    private var resetButton: some View {
        Button {
            withAnimation {
                viewModel.reset()
            }
        } label: {
            Image(systemName: "stop.fill")
                .makeCircly(background: .red)
        }
        .buttonStyle(.plain)
        .disabled(isPlaying)
        .opacity(isPlaying ? 0.6 : 1)
    }
}
