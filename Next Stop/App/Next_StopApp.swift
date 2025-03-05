
import SwiftUI

@main
struct Next_StopApp: App {
    @StateObject private var homeVM = HomeViewModel(hotelsService: HotelsService())
    
    var body: some Scene {
        WindowGroup {
            NavigationStack{
                MainTabView()
            }
            .environmentObject(homeVM)
        }
    }
}
