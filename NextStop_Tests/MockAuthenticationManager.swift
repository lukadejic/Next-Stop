import XCTest
@testable
import FirebaseAuth
@testable
import Next_Stop

class MockAuthenticationManager : AuthenticationProtocol {
    var error: Error? = nil
    
    var user: AuthDataResultModel? = nil
    
    var expectation: XCTestExpectation? = nil
        
    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
        if let user {
            expectation?.fulfill()
            return user
        } else {
            expectation?.fulfill()
            throw error!
        }
    }
    
    @MainActor
    func signIn(email: String, password: String) async throws -> AuthDataResultModel {
        if let error {
            expectation?.fulfill()
            throw error
        }
        
        if let user {
            expectation?.fulfill()
            return user
        }
        
        return AuthDataResultModel(uid: UUID().uuidString, email: nil, photoURL: nil, displayName: nil)
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
        if let userModel = user {
            return userModel
        } else {
            throw error!
        }
    }
    
    @MainActor
    func resetPassword(email: String) async throws {
        if let error {
            expectation?.fulfill()
            throw error
        }
        
        expectation?.fulfill()
    }
    
    func updatePassword(password: String) async throws {
        
    }
    
    @MainActor
    func updateEmail(email: String) async throws {
        if let error {
            expectation?.fulfill()
            throw error
        }
        
        expectation?.fulfill()
    }
    
    func signOut() throws {
        if let error {
            throw error
        }
    }
    
    func deleteUser() async throws {
        
    }
    
    
}
