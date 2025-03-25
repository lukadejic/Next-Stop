import Foundation
import FirebaseAuth

enum AuthProviderOption: String {
    case email = "password"
    case google = "google.com"
}

protocol AuthenticationProtocol {
    @discardableResult
    func createUser (email: String, password: String) async throws -> AuthDataResultModel
    
    @discardableResult
    func signIn (email: String, password: String) async throws -> AuthDataResultModel
    
    func signIn(credential: AuthCredential) async throws -> AuthDataResultModel
    
    @discardableResult
    func signInWithGoogle(tokens: GoogleSignInResultModel) async throws -> AuthDataResultModel
    
    func getProviders() throws -> [AuthProviderOption]
    
    func getAuthenticatedUser() throws -> AuthDataResultModel
    
    func resetPassword(email: String) async throws
    
    func updatePassword(password: String) async throws
    
    func updateEmail(email: String) async throws
    
    func signOut() throws
    
    func deleteUser() async throws
}

final class AuthenticationManager : AuthenticationProtocol {
    
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badURL)
        }
        
        return AuthDataResultModel(user: user)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    func deleteUser() async throws {
        guard let user = Auth.auth().currentUser else {
            throw UserError.noCurrentUser
        }
        
        try await user.delete()
    }
    
    func getProviders() throws -> [AuthProviderOption] {
        guard let providerData = Auth.auth().currentUser?.providerData else {
            throw URLError(.badURL)
        }
        
        var providers: [AuthProviderOption] = []
        
        for provider in providerData {
            print(provider.providerID)
            if let option = AuthProviderOption(rawValue: provider.providerID) {
                providers.append(option)
            }else{
                assertionFailure("Provider option not found: \(provider.providerID)")
            }
        }
        
        return providers
    }
    
}

// MARK: Sign in email
extension AuthenticationManager {
    
    @discardableResult
    func createUser (email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    @discardableResult
    func signIn(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }

    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    func updatePassword(password: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw UserError.noCurrentUser
        }
        
        try await user.updatePassword(to: password)
    }
    
    func updateEmail(email: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw UserError.noCurrentUser
        }
        
        try await user.sendEmailVerification(beforeUpdatingEmail: email)
    }
}

// MARK: Sign in SSO
extension AuthenticationManager {
    
    @discardableResult
    func signInWithGoogle(tokens: GoogleSignInResultModel) async throws -> AuthDataResultModel {
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken,
                                                       accessToken: tokens.accessToken)
        return try await signIn(credential: credential)
    }
    
    func signIn(credential: AuthCredential) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(with: credential)
        return AuthDataResultModel(user: authDataResult.user)
    }
}
