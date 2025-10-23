import Foundation

struct MockData {
    static let mockHotelImages : [ImageModel] = [
        .init(id: 1,
              url: "https://cf.bstatic.com/xdata/images/hotel/square1024/613758026.jpg?k=248663299c505b8cdd98caa01e915fa2559e0013ce3fa70cde0f1ca9dad6e581&o="),
        .init(id: 2,
              url: "https://cf.bstatic.com/xdata/images/hotel/square1024/613758080.jpg?k=a5e48375f5f377df7813999021f662da2e8d67ce3bcd692f3032adb1524c4165&o=")
    ]
    
    static let mockHotel : Hotel = .init(hotelID: 1, accessibilityLabel: "", property: .init(checkinDate: "2025-4-15", isPreferred: nil, checkin: CheckIn(untilTime: "00:00", fromTime: "14:00"), wishlistName: nil, photoUrls: nil, rankingPosition: nil, mainPhotoID: nil, reviewCount: nil, currency: nil, reviewScoreWord: nil, latitude: nil, propertyClass: nil, isFirstPage: nil, position: nil, checkoutDate: "2025-4-22", ufi: nil, name: "Mock hotel", qualityClass: nil, longitude: nil, accuratePropertyClass: nil, id: 1, reviewScore: 10.0, blockIDS: nil, isPreferredPlus: nil, countryCode: nil, optOutFromGalleryChanges: nil))
}
