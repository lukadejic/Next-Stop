import Foundation
import SwiftData

protocol HotelsServiceProtocol {
    func fetchDestinations(query:String) async throws -> [Destination]
    func fetchHotels(for destination: Destination) async throws -> [Hotel]
    func fetchHotelsWithFilters(destination: Destination,
                                location: String,
                                arrivalDate: String?,
                                departureDate:String?,
                                adults: Int? ,
                                childrenAge: [Int]?,
                                roomQty: Int?) async throws -> [Hotel]
    func fetchHotelImages(hotelID: Int) async throws -> [ImageModel]
    func fetchHotelDetails(hotelId : Int) async throws -> HotelDetailData?
    func fetchHotelDescription(hotelId: Int) async throws -> [HotelDescriptionData]?
}

class HotelsService : HotelsServiceProtocol {
    
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    func fetchDestinations(query:String) async throws -> [Destination] {
        let parameters = ["query" : query]
        
        let response : Response = try await networkManager.fetchData(
            endpoint: "hotels/searchDestination",
            parameters: parameters)
        
        return response.data ?? []
    }
    

    func fetchHotels(for destination: Destination) async throws -> [Hotel] {
        let arivalDate = DateFormatter.yyyyMMdd.string(from: Date())
        let departureDate = DateFormatter.yyyyMMdd.string(from: Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date())
        
        let parameters : [String: String] = [
            "dest_id": destination.destid ?? "",
            "search_type" : destination.destType ?? "",
            "arrival_date" : arivalDate,
            "departure_date" : departureDate
        ]
        
        let response : HotelsResponse = try await networkManager.fetchData(
            endpoint: "hotels/searchHotels",
            parameters: parameters)
        
        return response.data.hotels 
    }
    
    func fetchHotelsWithFilters(destination: Destination,
                                location: String,
                                arrivalDate: String?,
                                departureDate:String?,
                                adults: Int? ,
                                childrenAge: [Int]?,
                                roomQty: Int?) async throws -> [Hotel] {
        let arrival_date : String
        let departure_date: String
        
        if let arrival = arrivalDate, let departure = departureDate {
            arrival_date = arrival
            departure_date = departure
        }else {
            arrival_date = DateFormatter.yyyyMMdd.string(from: Date())
            departure_date = DateFormatter.yyyyMMdd.string(from: Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date())
        }

        let adults = adults ?? 1
        let roomQty = roomQty ?? 1
        let childrenAgeJoined = childrenAge?.compactMap { "\($0)" }.joined(separator: ", ") ?? ""
        
        let parameters : [String: String] = [
            "dest_id": destination.destid ?? "",
            "search_type" : destination.destType ?? "",
            "arrival_date" : arrival_date,
            "departure_date" : departure_date,
            "adults": "\(adults)",
            "children_age" : "\(childrenAgeJoined)",
            "room_qty" : "\(roomQty)"
        ]
        
        let response : HotelsResponse = try await networkManager.fetchData(
            endpoint: "hotels/searchHotels",
            parameters: parameters)
        
        return response.data.hotels
    }
    
    func fetchHotelImages(hotelID: Int) async throws -> [ImageModel] {
        let parameters = ["hotel_id" : "\(hotelID)"]
        
        let response : HotelImageResponse = try await networkManager.fetchData(
            endpoint: "hotels/getHotelPhotos",
            parameters: parameters)
        
        return response.data
    }
    
    func fetchHotelDetails(hotelId : Int) async throws -> HotelDetailData? {
        let arivalDate = DateFormatter.yyyyMMdd.string(from: Date())
        let departureDate = DateFormatter.yyyyMMdd.string(from: Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date())
        
        let parameters : [String: String] = [
            "hotel_id": "\(hotelId)",
            "arrival_date" : arivalDate,
            "departure_date" : departureDate
        ]
        
        let response : HotelDetailResponse = try await networkManager.fetchData(
            endpoint: "hotels/getHotelDetails",
            parameters: parameters)
        
        return response.data
    }
    
    func fetchHotelDescription(hotelId: Int) async throws -> [HotelDescriptionData]? {
        
        let parameters: [String : String] = [
            "hotel_id": "\(hotelId)"
        ]
        
        let response : HotelDescriptionResponse = try await networkManager.fetchData(
            endpoint: "hotels/getDescriptionAndInfo",
            parameters: parameters)
        
        return response.data
    }
}


