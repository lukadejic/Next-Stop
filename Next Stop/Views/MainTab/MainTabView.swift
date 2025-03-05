import SwiftUI
import SwiftData

struct MainTabView: View {
    
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
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage:"person")
                }
        }
        .tint(.black)
    }
}

#Preview {
    MainTabView()
}
