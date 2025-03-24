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
    
    let authManager: AuthenticationProtocol
    
    init(authManager: AuthenticationProtocol) {
        self.authManager = authManager
    }
    
    func signIn() {
        do{
            try AuthValidator.validateFields(email: email, password: password)
            
            Task{
                do{
                    try await Auth.auth().signIn(withEmail: email, password: password)
                    DispatchQueue.main.async {
                        self.succesful = true
                        self.alertItem = nil
                    }
                }catch let error as NSError {
                    if let authErrorCode = AuthErrorCode(rawValue: error.code) {
                        switch authErrorCode {
                        case .invalidCredential:
                            alertItem = AlertContext.userNotFound
                        default:
                            alertItem = AlertContext.firebaseError
                        }
                    }
                }
            }
        }catch let error as SignUpError {
            alertItem = AuthValidator.mapErrorToAlert(error)
        }catch {
            self.alertItem = AlertContext.firebaseError
        }
    }

}
