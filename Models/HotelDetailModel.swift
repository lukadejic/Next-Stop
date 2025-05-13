import Foundation

struct HotelDetailResponse: Codable {
    let status: Bool?
    let message: String?
    let timestamp: Int?
    let data: HotelDetailData?
}

struct HotelDetailData: Codable {
    let hotel_id: Int?
    let hotel_name: String?
    let url : String?
    let review_nr: Int?
    let arrival_date: String?
    let departure_date: String?
    let latitude: Double?
    let longitude: Double?
    let address: String?
    let city: String?
    let country_trans: String?
    let zip: String?
    let available_rooms: Int?
    let family_facilities: [String]?
    let product_price_breakdown: ProductPriceBreakdown?
//  let property_highlight_strip: PropertyHighlightStrip?
    let top_ufi_benefits : [TopUfiBenefit]?
//  let hotel_important_information_with_codes: [HotelImportantInformation]?
//  let rooms: [Rooms]?
    let block: [Block]?
}


struct ProductPriceBreakdown: Codable {
    let charges_details: ChargesDetails?
}

struct ChargesDetails: Codable {
    let amount: Amount?
}

struct Amount: Codable {
    let value: Double
    let currency: String
}

struct PropertyHighlightStrip : Codable {
    let name: String
    let iconList: [IconList]
    
    enum CodingKeys : String, CodingKey {
        case name
        case iconList = "icon_list"
    }
}

struct IconList: Codable {
    let size: Int?
    let icon: String?
}

struct TopUfiBenefit: Codable {
    let translated_name: String?
    let icon: String?
}

struct HotelImportantInformation: Codable {
    let phrase: String?
    let executing_phase: Int?
    let sentence_id: Int?
}

struct Rooms: Codable {
    let facilities: [Facility]?
}

struct Facility: Codable {
    let id: Int
    let name: String
    let facilitytype_name: String
}

struct Block: Codable {
    let paymentterms: PaymentTerms?
}

struct PaymentTerms: Codable {
    let cancellation: Cancellation?
}

struct Cancellation: Codable {
    let description: String?
}
