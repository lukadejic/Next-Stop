import Foundation

struct HotelImageResponse: Codable {
    let status: Bool
    let message: String?
    let timestamp: Int
    let data: [ImageModel]
}

struct ImageModel: Codable, Identifiable {
    let id: Int
    let url: String
}

