import Foundation
import SwiftUI

@MainActor
class HomeViewModel : ObservableObject {
    @Published var destinations : [Destination] = []
    @Published var hotels : [Hotel] = []
    @Published var selectedDestination: Destination? {
        didSet {
            if oldValue?.id != selectedDestination?.id {
                fetchHotelsIfNeeded()
            }
        }
    }
    @Published var hotelImages : [Int : [ImageModel]] = [:]
    @Published var hotelDetail : HotelDetailData? = nil
    @Published var hotelDescription: [HotelDescriptionData] = []
    @Published var startDate: Date? = nil
    @Published var endDate: Date? = nil
    @Published var arrivalDay: Date? = nil
    @Published var isLoading : Bool = false
    
    var wishlistManager = WishlistManager()

    private let hotelsService : HotelsService
    
    init(hotelsService: HotelsService) {
        self.hotelsService = hotelsService
    }
    
    func getDestinations(query: String) {
        
        Task{
            do{
                let fetchedDestinations = try await hotelsService.fetchDestinations(query: query)
                
                let destinationsWithAddedQuery = fetchedDestinations.map { destination in
                    var destinationWithQuery = destination
                    destinationWithQuery.query = query
                    return destinationWithQuery
                }
                
                self.destinations = destinationsWithAddedQuery
                
            }catch{
                throw error
            }
        }
    }
    
    
    func getHotels(){
        
        guard let destination = selectedDestination else {
            print("No selected destination, cannot fetch hotels")
            return
        }
        
        Task{
            do{
                let hotels = try await hotelsService.fetchHotels(for: destination)
                
                DispatchQueue.main.async {
                    self.hotels = hotels
                }
            }catch{
                print("Error while fetching hotels: \(error.localizedDescription)")
            }
        }
    }
    
    func searchHotels(location: String,
                      arrivalDate: Date?,
                      departureDate:Date?,
                      adults: Int? ,
                      childredAge: [Int]?,
                      roomQty: Int?) {
        Task{
            do{
                isLoading = true
                guard let destination = try await hotelsService.fetchDestinations(query: location).first else {
                    return
                }
                
                print(destination.name)
                
                let arrivalDateToUse = arrivalDate ?? Date()
                let departureDateToUse = departureDate ?? Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()
                
                let arrivalDate = CalendarHelpers.convertDateToString(date: arrivalDateToUse)
                let departureDate = CalendarHelpers.convertDateToString(date: departureDateToUse)
                            
                
                let hotels = try await hotelsService.fetchHotelsWithFilters(
                    destination: destination,
                    location: location,
                    arrivalDate: arrivalDate,
                    departureDate: departureDate,
                    adults: adults,
                    childrenAge: childredAge,
                    roomQty: roomQty)
                
                DispatchQueue.main.async {
                    self.hotels = hotels
                    self.isLoading = false
                }
            }catch {
                print("Error while fetching hotels with filters \(error.localizedDescription)")
                isLoading = false
            }
        }
       
    }
    
    func selectDestination(for query: String) {
        if let selectedDest = destinations.first(where: { $0.query?.lowercased() == query.lowercased() }) {
            if selectedDestination?.id != selectedDest.id {
                self.selectedDestination = selectedDest
                self.getHotels()
            }
        } else {
            print("Destination not found for query: \(query)")
        }
    }
    
    func getHotelImages(hotelID: Int) {
        if hotelImages[hotelID] != nil { return }
        
        Task{
            do{
                let images = try await hotelsService.fetchHotelImages(hotelID: hotelID)
                self.hotelImages[hotelID] = images
                
            }catch{
                print("Error while fetching the images for hotelID: \(hotelID) : \(error.localizedDescription)" )
            }
        }
    }
    
    func getHotelDetails(hotelId : Int) {
        Task{
            do{
                let hotelDetails = try await hotelsService.fetchHotelDetails(hotelId: hotelId)
                
                self.hotelDetail = hotelDetails
            }catch{
                print("error while fetching hotel details : \(error.localizedDescription)")
            }
        }
    }
    
    func getHotelDescription(hotelId: Int) {
        Task{
            do{
                guard let hotelDescriptions = try await hotelsService.fetchHotelDescription(hotelId: hotelId) else { return }
                
                self.hotelDescription = hotelDescriptions
                
            }catch{
                print("Failed to fetch hotel description data: \(error.localizedDescription)")
            }
        }
    }
    private func fetchHotelsIfNeeded() {
        guard let destination = selectedDestination, hotels.isEmpty else { return }
        getHotels()
    }
    
    func saveAvailibilyDate(startDate: Date? , endDate: Date?) {
        guard let startDate = startDate, let endDate = endDate else { return }
        self.startDate = startDate
        self.endDate = endDate
    }
    
    func saveArrivalDay(arrivalDay: Date?) {
        guard let arrivalDay = arrivalDay else { return }
        self.arrivalDay = arrivalDay
    }
        
}
