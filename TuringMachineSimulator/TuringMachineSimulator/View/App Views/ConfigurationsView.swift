//
//  ConfigurationsView.swift
//  TuringMachineSimulator
//
//  Created by Snow Lukin on 24.08.2022.
//

import SwiftUI

struct ConfigurationsView: View {
    
    @ObservedObject var algorithm: Algorithm
    
    @Binding var showSettings: Bool
    
    var body: some View {
        VStack {
            Button {
                withAnimation {
                    showSettings.toggle()
                }
            } label: {
                Text(showSettings ? "Hide settings" : "Show settings")
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(uiColor: .secondarySystemBackground))
            .cornerRadius(12)
            .padding([.leading, .trailing])
            
            if showSettings {
                VStack {
                    customSection(header: "Configurations", content: AnyView(customTwoCells))
                    customSection(header: "Current state", content: AnyView(customCell))
                }.padding([.top, .bottom])
            }
        }.background(Color(uiColor: .secondarySystemBackground))
    }
}

struct ConfigurationsView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let folder = context.registeredObjects.first(where: { $0 is Folder }) as! Folder
        let algorithm = folder.wrappedAlgorithms[0]
        ConfigurationsView(algorithm: algorithm, showSettings: .constant(false))
    }
}

extension ConfigurationsView {
    private func customSection(header: String = "", content: AnyView) -> some View {
        VStack(spacing: 6) {
            customHeaderView(header)
            content
        }
    }
    
    private var customCell: some View {
        VStack {
            customCellButtonView(
                "State \(0)",
                destination: AnyView(StartStateListView(algorithm: algorithm))
            )
        }.padding()
            .frame(maxWidth: .infinity)
            .background(Color(uiColor: .systemBackground))
            .cornerRadius(12)
            .padding([.leading, .trailing])
    }
    
    private var customTwoCells: some View {
        VStack(alignment: .leading, spacing: 7) {
            customCellButtonView("Tapes", destination: AnyView(TapesView(algorithm: algorithm)))
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding(.bottom, 5)
            Divider()
                .padding(.leading)
            customCellButtonView("States", destination: AnyView(StateListView(algorithm: algorithm)))
                .padding(.top, 5)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(uiColor: .systemBackground))
        .cornerRadius(12)
        .padding([.leading, .trailing])
    }
    
    private func customHeaderView(_ text: String) -> some View {
        HStack {
            Text(text)
                .font(.system(size: 14))
                .foregroundColor(.gray)
            
            Spacer()
        }.padding([.leading, .trailing], 35)
    }
    
    // TODO: Get rid of AnyView
    private func customCellButtonView(_ text: String, destination: AnyView) -> some View {
        NavigationLink {
            destination
        } label: {
            Text(text)
                .foregroundColor(.primary)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.footnote)
                .foregroundColor(.primary)
        }.padding([.leading, .trailing])
    }
}
