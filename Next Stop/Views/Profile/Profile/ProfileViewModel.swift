import Foundation
import FirebaseAuth

@MainActor
final class ProfileViewModel : ObservableObject {
    @Published var user: AuthDataResultModel? = nil
    @Published var isLoading = false
    @Published var alertItem: AlertItem? = nil
    @Published var authProviders: [AuthProviderOption] = []
    
    private let authManager : AuthenticationProtocol
    private var authStateListenerHandle: AuthStateDidChangeListenerHandle?
    
    init(authManager: AuthenticationProtocol) {
        self.authManager = authManager
        self.getAuthenticatedUser()
        self.listenForAuthStateChanges()
    }
    
    
    func loadAuthProviders(){
        if let providers = try? authManager.getProviders() {
            authProviders = providers
        }
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
    
    func deleteUser(){
        Task{
            do{
                try await authManager.deleteUser()
                alertItem = AlertContext.succesfulyDeletedUser
            }catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func resetPassword() {
        Task{
            do{
                let user = try authManager.getAuthenticatedUser()
                
                guard let email = user.email else {
                    throw UserError.emptyEmail
                }
                
                try await authManager.resetPassword(email: email)
                
            }catch let error as NSError {
                if let authErrorCode = AuthErrorCode(rawValue: error.code) {
                    switch authErrorCode {
                    case .invalidRecipientEmail:
                        alertItem = AlertContext.invalidEmail
                    default:
                        alertItem = AlertContext.defaultError
                    }
                }
                
            }
        }
    }
    
    func updateEmail() {
        let email = "lukadejic1234@gmail.com"
        Task{
            do{
                try await authManager.updateEmail(email: email)
                self.alertItem = AlertContext.succesfulEmailUpdate
            }catch{
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func updatePassword() {
        let password = "Password031."
        Task{
            do{
                try await authManager.updatePassword(password: password)
                self.alertItem = AlertContext.succesfulPasswordUpdate
            }catch{
                print("Error: \(error.localizedDescription)")
            }
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
