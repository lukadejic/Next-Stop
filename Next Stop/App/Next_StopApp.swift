
import SwiftUI

@main
struct Next_StopApp: App {
    @StateObject private var homeVM = HomeViewModel(hotelsService: HotelsService())
    @StateObject private var wishlistManager = WishlistManager()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack{
                MainTabView()
            }
            .environmentObject(homeVM)
            .environmentObject(wishlistManager)
        }
    }
}
