import Foundation
import FirebaseAuth

protocol AuthenticationProtocol {
    @discardableResult
    func createUser (email: String, password: String) async throws -> AuthDataResultModel
    
    @discardableResult
    func signIn (email: String, password: String) async throws -> AuthDataResultModel
    
    func getAuthenticatedUser() throws -> AuthDataResultModel
    
    func resetPassword(email: String) async throws
    
    func updatePassword(password: String) async throws
    
    func updateEmail(email: String) async throws
    
    func signOut() throws
    
}

final class AuthenticationManager : AuthenticationProtocol {
    
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
    
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badURL)
        }
        
        return AuthDataResultModel(user: user)
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

    func signOut() throws {
        try Auth.auth().signOut()
    }
}
