import Foundation

struct DBUser: Codable {
    let userId: String
    let email: String?
    let photoURL: String?
    let displayName: String?
    let dateCreated: Date?
    let biography: String?
    let preferences: [String]?
    let languages: [String]?
    let obsessed : String?
    
    init(userId: String, email: String?, photoURL: String?, displayName: String?, dateCreated: Date?, biography: String?, preferences: [String]?,languages: [String]?,obsessed: String?) {
        self.userId = userId
        self.email = email
        self.photoURL = photoURL
        self.displayName = displayName
        self.dateCreated = dateCreated
        self.biography = biography
        self.preferences = preferences
        self.languages = languages
        self.obsessed = obsessed
    }
    
    init(user: AuthDataResultModel) {
        self.userId = user.uid
        self.email = user.email
        self.photoURL = user.photoURL
        self.displayName = user.displayName
        self.dateCreated = Date()
        self.biography = nil
        self.preferences = nil
        self.languages = nil
        self.obsessed = nil
    }
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email = "email"
        case photoURL = "photo_url"
        case displayName = "display_name"
        case dateCreated = "date_created"
        case biography = "biography"
        case preferences = "preferences"
        case languages = "languages"
        case obsessed = "obsessed"
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.photoURL, forKey: .photoURL)
        try container.encodeIfPresent(self.displayName, forKey: .displayName)
        try container.encodeIfPresent(self.dateCreated, forKey: .dateCreated)
        try container.encodeIfPresent(self.biography, forKey: .biography)
        try container.encodeIfPresent(self.preferences, forKey: .preferences)
        try container.encodeIfPresent(self.languages, forKey: .languages)
        try container.encodeIfPresent(self.obsessed, forKey: .obsessed)
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.photoURL = try container.decodeIfPresent(String.self, forKey: .photoURL)
        self.displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
        self.dateCreated = try container.decodeIfPresent(Date.self, forKey: .dateCreated)
        self.biography = try container.decodeIfPresent(String.self, forKey: .biography)
        self.preferences = try container.decodeIfPresent([String].self, forKey: .preferences)
        self.languages = try container.decodeIfPresent([String].self, forKey: .languages)
        self.obsessed = try container.decodeIfPresent(String.self, forKey: .obsessed)
    }
}
