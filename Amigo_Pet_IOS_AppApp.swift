import SwiftUI

@main
struct Amigo_Pet_IOS_AppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            let viewModel = AuthViewModel()
            AuthGuard1View()
                .environmentObject(viewModel)
                .environment(\.colorScheme, .light)
                .onAppear {
                    //UIScrollView.appearance().keyboardDismissMode = .onDrag
                }
        }
    }
}


