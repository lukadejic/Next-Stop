import Foundation

struct HotelsResponse: Codable {
    let status: Bool?
    let message: String?
    let timestamp: Int?
    let data: HotelData
}

struct HotelData: Codable {
    let hotels: [Hotel]
}

struct Hotel: Identifiable, Codable {
    var id = UUID()
    let hotelID: Int?
    let accessibilityLabel: String?
    let property: Property?

    enum CodingKeys: String, CodingKey {
        case hotelID = "hotel_id"
        case accessibilityLabel, property
    }
}

struct Property: Codable {
    let checkinDate: String?
    let isPreferred: Bool?
    let wishlistName: String?
    let photoUrls: [String]?
    let rankingPosition, mainPhotoID, reviewCount: Int?
    let currency, reviewScoreWord: String?
    let latitude: Double?
    let propertyClass: Int?
    let isFirstPage: Bool?
    let position: Int?
    let checkoutDate: String?
    let ufi: Int?
    let name: String?
    let qualityClass: Int?
    let longitude: Double?
    let accuratePropertyClass, id: Int?
    let reviewScore: Double?
    let blockIDS: [String]?
    let isPreferredPlus: Bool?
    let countryCode: String?
    let optOutFromGalleryChanges: Int?

    enum CodingKeys: String, CodingKey {
        case checkinDate, isPreferred, wishlistName, photoUrls, rankingPosition
        case mainPhotoID = "mainPhotoId"
        case reviewCount, currency, reviewScoreWord, latitude, propertyClass, isFirstPage, position, checkoutDate, ufi, name, qualityClass, longitude,
             accuratePropertyClass, id, reviewScore
        case blockIDS = "blockIds"
        case isPreferredPlus, countryCode, optOutFromGalleryChanges
    }
}
