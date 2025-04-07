import SwiftUI

class MockUserManager : UserManagerProtocol {
    var shouldFailToGetUserFromFirebase = false
    
    func getUser(userId: String) async throws -> DBUser {
        if shouldFailToGetUserFromFirebase {
            throw UserError.noFirebaseUser
        }
        
        return DBUser(userId: "HBFAJN1841N8TNFSOnfjn9Fn", email: "test@gmail.com", photoURL: nil, displayName: "Luka", dateCreated: nil, biography: nil, preferences: nil, languages: nil, obsessed: nil, location: nil, work: nil, pets: nil, interests: nil)
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
    
    
}
