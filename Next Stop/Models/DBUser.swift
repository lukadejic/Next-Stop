import Foundation

struct DBUser {
    let userId: String
    let email: String?
    let photoURL: String?
    let displayName: String?
    let dateCreated : Date?
    
    init(userId: String, email: String?, photoURL: String?, displayName: String?, dateCreated: Date?) {
        self.userId = userId
        self.email = email
        self.photoURL = photoURL
        self.displayName = displayName
        self.dateCreated = dateCreated
    }
}
