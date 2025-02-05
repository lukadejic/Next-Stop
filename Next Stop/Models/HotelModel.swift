import Foundation

// MARK: - Welcome
struct HotelsResponse: Codable {
    let status: Bool
    let message: String
    let timestamp: Int
    let data: HotelData
}

// MARK: - DataClass
struct HotelData: Codable {
    let hotels: [Hotel]
}

// MARK: - Hotel
struct Hotel: Codable {
    let accessibilityLabel: String
    let property: Property
}

// MARK: - Property
struct Property: Codable {
    let reviewScoreWord: String?
    let rankingPosition: Int?
    let id: Int
    
    enum CodingKeys: String, CodingKey {
        case reviewScoreWord
        case rankingPosition
        case id
    }
}
