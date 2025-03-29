import Foundation
import SwiftUI
import FirebaseAuth

@MainActor
final class LogInViewModel : ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    @Published var showSignUp = false
    @Published var alertItem: AlertItem?
    @Published var isLoading = false
    @Published var succesful = false
    
    private let authManager: AuthenticationProtocol
    private let userManager: UserManagerProtocol
    
    init(authManager: AuthenticationProtocol, userManager : UserManagerProtocol) {
        self.authManager = authManager
        self.userManager = userManager
    }
    
    func signIn() async throws {
        do {
            try AuthValidator.validateFields(email: email, password: password)
            let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
            
            try await userManager.createUser(auth: AuthDataResultModel(user: authDataResult.user))
            
            self.succesful = true
            
        } catch let error as SignUpError {
            alertItem = AuthValidator.mapErrorToAlert(error)
        } catch let error as NSError {
            if let authErrorCode = AuthErrorCode(rawValue: error.code) {
                switch authErrorCode {
                case .invalidCredential:
                    alertItem = AlertContext.userNotFound
                default:
                    alertItem = AlertContext.firebaseError
                }
            }
            self.succesful = false
        }
    }
    
    func signInWithGoogle() async throws {
        let tokens = try await SignInGoogleHelper.signIn()
        
        let authDataResult = try await authManager.signInWithGoogle(tokens: tokens)
        
        try await userManager.createUser(auth: authDataResult)
    }
}
