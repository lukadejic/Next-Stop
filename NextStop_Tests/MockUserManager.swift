import UIKit
@testable
import Next_Stop
import XCTest

class MockUserManager : UserManagerProtocol {
    var dbUser : DBUser? = nil
    
    var error: Error? = nil
    
    var expectation: XCTestExpectation? = nil
    
    @MainActor
    func getUser(userId: String) async throws -> DBUser {
        if let dbUser {
            return dbUser
        } else {
            throw error!
        }
    }
    
    func createNewUser(user: DBUser) async throws {
        
    }
    
    func updateUserBiography(userId: String, biography: String) async throws {
        
    }
    
    func updatePreferences(userId: String, preference: String) async throws {
        
    }
    
    func removePreferences(userId: String, preference: String) async throws {
        
    }
    
    func updateLanguages(userId: String, languages: [String]) async throws {
        
    }
    
    func updateObsessed(userId: String, text: String) async throws {
        
    }
    
    func updateLocation(userId: String, location: String) async throws {
        
    }
    
    func updateWork(userId: String, work: String) async throws {
        
    }
    
    func updatePets(userId: String, pets: String) async throws {
        
    }
    
    func updateUserInterests(userId: String, interests: [Interest]) async throws {
        
    }
    
    func updateUserProfilePicture(userId: String, picture: UIImage) async throws {
        
    }

    @MainActor
    func updateUser(userId: String, with data: [String : Any]) async throws {
        if let error {
            expectation?.fulfill()
            throw error
        }
        
        expectation?.fulfill()
    }
    
}
