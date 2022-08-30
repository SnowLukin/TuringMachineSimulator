//
//  CustomSidebar.swift
//  TuringMachineSimulator
//
//  Created by Snow Lukin on 24.08.2022.
//

import SwiftUI

extension EnvironmentValues {
    var splitViewPreferredDisplayMode: UISplitViewController.DisplayMode {
        get { self[PreferredDisplayModeKey.self] }
        set { self[PreferredDisplayModeKey.self] = newValue }
    }
}

extension View {
    func splitViewPreferredDisplayMode(_ mode: UISplitViewController.DisplayMode) -> some View {
        self.environment(\.splitViewPreferredDisplayMode, mode)
    }
}

struct PreferredDisplayModeKey: EnvironmentKey {
    static var defaultValue: UISplitViewController.DisplayMode = .automatic
}

struct Sidebar<Master: View, Detail: View, Secondary: View>: View {
    var master: Master
    var detail: Detail
    var secondary: Secondary

    init(@ViewBuilder master: () -> Master,
         @ViewBuilder detail: () -> Detail,
         @ViewBuilder secondary: () -> Secondary) {
        self.master = master()
        self.detail = detail()
        self.secondary = secondary()
    }
    
    var body: some View {
        let viewControllers = [
            getNavigationController(from: AnyView(master), backButtonTitle: ""),
            getNavigationController(from: AnyView(detail)),
            getNavigationController(from: AnyView(secondary))
        ]
        return SplitViewController(viewControllers: viewControllers)
    }
    
    func getNavigationController(from view: AnyView, backButtonTitle: String? = nil) -> UINavigationController {
        let viewController = UIHostingController(rootView: view)
        viewController.navigationItem.backButtonTitle = backButtonTitle
        let nav = UINavigationController(rootViewController: viewController)
        nav.navigationBar.prefersLargeTitles = true
        return nav
    }
}

struct SplitViewController: UIViewControllerRepresentable {
    @Environment(\.splitViewPreferredDisplayMode) var preferredDisplayMode: UISplitViewController.DisplayMode
    
    var viewControllers: [UINavigationController]

    func makeUIViewController(context: Context) -> UISplitViewController {
        return UISplitViewController(style: .tripleColumn)
    }

    func updateUIViewController(_ splitController: UISplitViewController, context: Context) {
        splitController.preferredDisplayMode = preferredDisplayMode
        splitController.viewControllers = viewControllers
        splitController.showsSecondaryOnlyButton = true
    }
}
