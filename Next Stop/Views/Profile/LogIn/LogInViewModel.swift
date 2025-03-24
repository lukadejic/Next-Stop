import Foundation
import SwiftUI
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

@MainActor
final class LogInViewModel : ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    @Published var showSignUp = false
    @Published var alertItem: AlertItem?
    @Published var isLoading = false
    @Published var succesful = false
    
    let authManager: AuthenticationProtocol
    
    init(authManager: AuthenticationProtocol) {
        self.authManager = authManager
    }
    
    func signIn() async throws {
        do {
            try AuthValidator.validateFields(email: email, password: password)
            try await Auth.auth().signIn(withEmail: email, password: password)
            // Prijava je uspela, ne pozivaj dismiss ovde jer se koristi u View-u
            
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
        guard let topVC = Utilites.shared.topViewController() else {
            throw URLError(.cannotFindHost)
        }

        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)

        guard let idToken: String = gidSignInResult.user.idToken?.tokenString else {
            throw URLError(.badServerResponse)
        }

        let accessToken: String = gidSignInResult.user.accessToken.tokenString

        let tokens = GoogleSignInResultModel(idToken: idToken, accessToken: accessToken)

        try await authManager.signInWithGoogle(tokens: tokens)
    }
}
