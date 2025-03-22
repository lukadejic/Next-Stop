import Foundation
import FirebaseAuth

@MainActor
final class ProfileViewModel : ObservableObject {
    @Published var user: AuthDataResultModel? = nil
    @Published var isLoading = false
    
    private let authManager : AuthenticationProtocol
    private var authStateListenerHandle: AuthStateDidChangeListenerHandle?
    
    init(authManager: AuthenticationProtocol) {
        self.authManager = authManager
        self.getAuthenticatedUser()
        self.listenForAuthStateChanges()
    }
    
    func getAuthenticatedUser() {
        Task{
            do{
                self.user = try authManager.getAuthenticatedUser()
            }catch{
                throw SignUpError.firebaseError(error: error)
            }
        }
    }
    
    func signOut() {
        do {
            try authManager.signOut()
            user = nil
        } catch {
            print("Failed to sign out: \(error)")
        }
    }
    
    func listenForAuthStateChanges() {
        authStateListenerHandle = Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                self.user = AuthDataResultModel(user: user)
            } else {
                self.user = nil
            }
        }
    }
    
    deinit {
        if let handle = authStateListenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}
