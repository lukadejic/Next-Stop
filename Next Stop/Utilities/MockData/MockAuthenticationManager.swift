import Foundation
import FirebaseAuth

class MockAuthenticationManager : AuthenticationProtocol {
    
    var shouldFailToGetAuthenticatedUser = false
    var shouldFailToSignOut = false
    
    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
        return AuthDataResultModel(uid: "1", email: "test@gmail.com",photoURL: nil, displayName: nil)
    }
    
    func signIn(email: String, password: String) async throws -> AuthDataResultModel {
        return AuthDataResultModel(uid: "1", email: "test@gmail.com",photoURL: nil, displayName: nil)
    }
    
    func signIn(credential: FirebaseAuth.AuthCredential) async throws -> AuthDataResultModel {
        return AuthDataResultModel(uid: "1", email: "test@gmail.com",photoURL: nil, displayName: nil)
    }
    
    func signInWithGoogle(tokens: GoogleSignInResultModel) async throws -> AuthDataResultModel {
        return AuthDataResultModel(uid: "HBFAJN1841N8TNFSOnfjn9Fn",
                                   email: "test@gmail.com",
                                   photoURL: nil,
                                   displayName: "Test")
    }
    
    func getProviders() throws -> [AuthProviderOption] {
        return [.google,.email]
    }
    
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        if shouldFailToGetAuthenticatedUser {
            throw UserError.noCurrentUser
        }
        
        return AuthDataResultModel(uid: "1", email: "test@gmail.com",
                                   photoURL: nil, displayName: nil)
    }
    
    func resetPassword(email: String) async throws {
        
    }
    
    func updatePassword(password: String) async throws {
        
    }
    
    func updateEmail(email: String) async throws {
        
    }
    
    func signOut() throws {
        if shouldFailToSignOut {
            throw UserError.cantSignOut
        }
        
        print("User sign out succesful")
    }
    
    func deleteUser() async throws {
        
    }
    
    
}
