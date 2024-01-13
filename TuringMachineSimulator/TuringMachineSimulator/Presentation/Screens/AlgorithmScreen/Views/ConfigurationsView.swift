//
//  ConfigurationsView.swift
//  TestTuringMachine
//
//  Created by Snow Lukin on 16.12.2023.
//

import SwiftUI

struct ConfigurationsView: View {

    @EnvironmentObject var coordinator: Coordinator

    let algorithm: Algorithm
    let activeStateName: String
    @Binding var isOpened: Bool

    var body: some View {
        VStack(spacing: 0) {
            Button {
                withAnimation(.bouncy(duration: 0.4)) {
                    isOpened.toggle()
                }
            } label: {
                HStack {
                    AppImages.downChevron
                        .rotationEffect(.degrees(isOpened ? 180 : 0))
                    Text((isOpened ? "Hide" : "Show") + " settings")
                }
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .padding(.vertical, 15)
                .alignHorizontally(.center)
                .background(.blue, in: .capsule)
            }
            .buttonStyle(.plain)
            .padding()

            VStack {
                configButton("Tapes", subtitle: "\(algorithm.tapes.count) tapes available") {
                    coordinator.push(.tapeConfig(algorithm))
                }

                configButton("States", subtitle: "\(algorithm.states.count) states available") {
                    coordinator.push(.stateList(algorithm))
                }

                configButton("Active State", subtitle: activeStateName) {
                    coordinator.push(.activeStateList(algorithm))
                }
            }
            .scaleEffect(y: isOpened ? 1 : 0)
            .frame(height: isOpened ? nil : 0)
        }
    }
}

extension ConfigurationsView {
    @ViewBuilder
    private func configButton(
        _ title: String,
        subtitle: String,
        action: @escaping () -> Void
    ) -> some View {
        Button {
            action()
        } label: {
            HStack {
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                }
                Spacer()
                AppImages.rightChevron
                    .bold()
            }
            .foregroundStyle(.blue)
            .alignHorizontally(.center)
            .padding()
            .background(Color.secondaryBackground, in: .rect(cornerRadius: 10))
            .padding(.horizontal)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    struct Container: View {
        @State var isOpened = true
        let algorithm: Algorithm
        var body: some View {
            ConfigurationsView(
                algorithm: algorithm,
                activeStateName: "Mock State",
                isOpened: $isOpened
            )
        }
    }

    let algorithm = Algorithm(
        id: UUID().uuidString,
        name: "Test Algorithm",
        algDescription: "",
        createdDate: .now,
        lastEditDate: .now,
        startingStateId: "",
        activeStateId: "",
        tapes: [],
        states: []
    )

    return Container(algorithm: algorithm)
}
