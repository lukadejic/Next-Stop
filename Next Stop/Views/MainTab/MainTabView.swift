import SwiftUI
import SwiftData

struct MainTabView: View {
    @StateObject private var profileViewModel =
    ProfileViewModel(authManager: AuthenticationManager(),
                     userManager: UserManager())
    
    @EnvironmentObject var vm: HomeViewModel

    let authManager = AuthenticationManager()
    let userManager = UserManager()
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Explore", systemImage:"magnifyingglass")
                }
                
            WishlistView()
                .tabItem {
                    Label("Whishlist", systemImage:"heart")
                }
                .badge(vm.wishlist.count)
            
            ProfileView(vm: profileViewModel,
                        authManager: authManager,
                        userManager: userManager)
            
                .tabItem {
                    Label("Profile", systemImage:"person")
                }
        }
        .tint(.black)
    }
}

#Preview {
    MainTabView()
        .environmentObject(HomeViewModel(
            hotelsService: HotelsService()))
}
