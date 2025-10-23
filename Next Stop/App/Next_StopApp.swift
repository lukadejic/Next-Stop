import SwiftUI
import Firebase

@main
struct Next_StopApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject private var homeVM = HomeViewModel(hotelsService: HotelsService(networkManager: NetworkManager()))
    
    var body: some Scene {
        WindowGroup {
            NavigationStack{
                MainTabView()
            }
            .environmentObject(homeVM)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        print("Firebase configured...")
        return true
    }
}
