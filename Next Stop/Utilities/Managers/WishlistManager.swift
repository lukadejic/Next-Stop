import SwiftUI

class WishlistManager : ObservableObject {
    @AppStorage("wishlist") var wishlistData: Data?
    
    @Published private(set) var wishlist: [Hotel] = []
    
    @Published var wishlistChangedHotel: Hotel?
    @Published var showLikeNotification = false
    @Published var showUnlikeNotification = false

    init() {
        loadWishlist()
    }
    
    func isHotelLiked(_ hotel: Hotel) -> Bool {
        wishlist.contains { $0.hotelID == hotel.hotelID }
    }
    
    func addToWishlist(_ hotel: Hotel) {
        if !isHotelLiked(hotel) {
            let oldValue = wishlist
            wishlist.append(hotel)
            saveWishlist()
            showNotification(oldValue, wishlist)
        }
    }
    
    func removeFromWishlist(_ hotel: Hotel) {
        let oldValue = wishlist
        wishlist.removeAll { $0.hotelID == hotel.hotelID }
        saveWishlist()
        showNotification(oldValue, wishlist)
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
    
    private func saveWishlist() {
        do {
            let data = try JSONEncoder().encode(wishlist)
            wishlistData = data
        } catch {
            print("Error while saving data: \(error.localizedDescription)")
        }
    }
    
    private func loadWishlist() {
        guard let data = wishlistData else { return }
        
        do{
            wishlist = try JSONDecoder().decode([Hotel].self, from: data)
        }catch{
            print("Error while loading data: \(error.localizedDescription)")
        }
    }
}
