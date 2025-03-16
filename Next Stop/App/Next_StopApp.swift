import SwiftUI
import Firebase

@main
struct Next_StopApp: App {
    @StateObject private var homeVM = HomeViewModel(hotelsService: HotelsService())
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack{
                MainTabView()
            }
            .environmentObject(homeVM)
        }
    }
}
