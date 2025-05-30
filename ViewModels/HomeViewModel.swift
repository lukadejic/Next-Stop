import Foundation
import SwiftUI

@MainActor
class HomeViewModel : ObservableObject {
    @AppStorage("wishlist") private var wishlistData: Data?
    
    @Published var destinations : [Destination] = []
    @Published var hotels : [Hotel] = []
    @Published var selectedDestination: Destination? = nil
    @Published var hotelImages : [Int : [ImageModel]] = [:]
    @Published var hotelDetail : HotelDetailData? = nil
    @Published var hotelDescription: [HotelDescriptionData] = []
    @Published var startDate: Date? = nil
    @Published var endDate: Date? = nil
    @Published var arrivalDay: Date? = nil
    @Published var isLoading : Bool = false
    
    @Published var wishlist: [Hotel] = [] {
        didSet {
            saveWishlist()
        }
    }
    
    @Published var showLikeNotification = false
    @Published var showUnlikeNotification = false
    @Published var wishlistChangedHotel: Hotel?
    
    private let hotelsService : HotelsServiceProtocol
    
    init (hotelsService: HotelsServiceProtocol) {
        self.hotelsService = hotelsService
        loadWishlist()
    }

    private func didSelectDestination(_ destination: Destination) {
        if selectedDestination?.id != destination.id {
            selectedDestination = destination
            fetchHotelsIfNeeded()
        }
    }
    
    func getDestinations(query: String) {
        
        Task {
            do {
                let fetchedDestinations = try await hotelsService.fetchDestinations(query: query)
                
                let destinationsWithAddedQuery = fetchedDestinations.map { destination in
                    var destinationWithQuery = destination
                    destinationWithQuery.query = query
                    return destinationWithQuery
                }
                
                self.destinations = destinationsWithAddedQuery
            } catch {
                throw NetworkErrors.cantGetDestinations
            }
        }
    }

    private func fetchHotelsIfNeeded() {
        getHotels()
    }
    
    func getHotels() {
        
        guard let destination = selectedDestination else {
            print("No selected destination, cannot fetch hotels")
            return
        }
        
        Task {
            do {
                let hotels = try await hotelsService.fetchHotels(for: destination)
                
                self.hotels = hotels
            } catch {
                throw NetworkErrors.cantGetHotels
            }
        }
    }
    
    func searchHotels(location: String,
                      arrivalDate: Date?,
                      departureDate: Date?,
                      adults: Int? ,
                      childredAge: [Int]?,
                      roomQty: Int?) {
        Task {
            do {
                isLoading = true
                guard let destination = try await hotelsService.fetchDestinations(query: location).first else {
                    throw NetworkErrors.cantGetDestinations
                }
            
                let arrivalDateToUse = arrivalDate ?? Date()
                let departureDateToUse = departureDate ?? Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()
                
                let arrivalDate = CalendarHelpers.convertDateToString(date: arrivalDateToUse)
                let departureDate = CalendarHelpers.convertDateToString(date: departureDateToUse)
                            
                let hotels = try await hotelsService.fetchHotelsWithFilters (
                    destination: destination,
                    location: location,
                    arrivalDate: arrivalDate,
                    departureDate: departureDate,
                    adults: adults,
                    childrenAge: childredAge,
                    roomQty: roomQty)
                
                    self.hotels = hotels
                    self.isLoading = false
                
            } catch {
                isLoading = false
                throw NetworkErrors.cantSearchHotels
            }
        }
       
    }
    
    func selectDestination(for query: String) {
        if let selectedDest = destinations.first(where: { $0.query?.lowercased() == query.lowercased() }) {
            didSelectDestination(selectedDest)
        } else {
            print("Destination not found for query: \(query)")
        }
    }
    
    func getHotelImages(hotelID: Int) {
        if hotelImages[hotelID] != nil { return }
        
        Task {
            do {
                let images = try await hotelsService.fetchHotelImages(hotelID: hotelID)
                self.hotelImages[hotelID] = images
            } catch {
                throw NetworkErrors.cantGetImage
            }
        }
    }
    
    func getHotelDetails(hotelId : Int) {
        Task {
            do {
                let hotelDetails = try await hotelsService.fetchHotelDetails(hotelId: hotelId)
                self.hotelDetail = hotelDetails
            } catch {
                print("error while fetching hotel details : \(error.localizedDescription)")
            }
        }
    }
    
    func getHotelDescription(hotelId: Int) {
        Task {
            do {
                guard let hotelDescriptions = try await hotelsService.fetchHotelDescription(hotelId: hotelId) else { return }
                
                self.hotelDescription = hotelDescriptions
                
            } catch {
                print("Failed to fetch hotel description data: \(error.localizedDescription)")
            }
        }
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

    func isHotelLiked(_ hotel: Hotel) -> Bool {
        wishlist.contains { $0.hotelID == hotel.hotelID }
    }
    
    func addToWishlist(_ hotel: Hotel) {
        if !isHotelLiked(hotel) {
            wishlist.append(hotel)
        }
    }
    
    func removeFromWishlist(_ hotel: Hotel) {
        wishlist.removeAll { $0.hotelID == hotel.hotelID }
    }
    
    private func saveWishlist() {
        do {
            let data = try JSONEncoder().encode(wishlist)
            wishlistData = data
        } catch {
            print("Error while saving data to wishlist: \(error.localizedDescription)")
        }
    }

    private func loadWishlist() {
        guard let data = wishlistData else { return }
        do {
            wishlist = try JSONDecoder().decode([Hotel].self, from: data)
        } catch {
            print("Error while loading data from wishlist: \(error.localizedDescription)")
        }
    }

    func showNotification(_ oldValue: [Hotel], _ newValue: [Hotel]) {
         let newlyLiked = newValue.filter { !oldValue.contains($0) }
         let newlyUnliked = oldValue.filter { !newValue.contains($0) }
         
         if let likedHotel = newlyLiked.last {
             self.wishlistChangedHotel = likedHotel
             withAnimation{
                 self.showLikeNotification = true
             }
             DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                 withAnimation {
                     self.showLikeNotification = false
                 }
             }
         }
         
         if let unlikedHotel = newlyUnliked.last {
             self.wishlistChangedHotel = unlikedHotel
             withAnimation {
                 self.showUnlikeNotification = true
             }
             DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                 withAnimation {
                     self.showUnlikeNotification = false
                 }
             }
         }
     }
}
