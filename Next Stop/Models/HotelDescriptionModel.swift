import Foundation

struct HotelDescriptionResponse : Codable {
    let status: Bool?
    let message: String?
    let timestamp: Int?
    let data: [HotelDescriptionData]?
}

struct HotelDescriptionData: Codable, Hashable {
    let description: String?
    let languagecode: String?
    let hotel_id: String?
}
