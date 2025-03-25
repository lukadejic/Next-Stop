import SwiftUI
import SwiftData

struct MainTabView: View {
    @StateObject private var profileViewModel =
    ProfileViewModel(authManager: AuthenticationManager())
    
    @EnvironmentObject var vm: HomeViewModel

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
            
            ProfileView(vm: profileViewModel)
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
