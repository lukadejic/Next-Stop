import SwiftUI

@MainActor
class WishlistManager: ObservableObject {
    @AppStorage("wishlist") private var wishlistData: Data?

    @Published var wishlist: [Hotel] = [] {
        didSet{
            saveWishlist()
        }
    }
    
    @Published var wishlistChangedHotel: Hotel?
    @Published var showLikeNotification: Bool = false
    @Published var showUnlikeNotification: Bool = false

    init() {
        loadWishlist()
    }

    func isHotelLiked(_ hotel: Hotel) -> Bool {
        wishlist.contains { $0.hotelID == hotel.hotelID }
    }

    func addToWishlist(_ hotel: Hotel) {
        if !isHotelLiked(hotel) {
            wishlist.append(hotel)
            saveWishlist()
        }
    }

    func removeFromWishlist(_ hotel: Hotel) {
        wishlist.removeAll { $0.hotelID == hotel.hotelID }
        saveWishlist()
    }

    private func saveWishlist() {
        do {
            let data = try JSONEncoder().encode(wishlist)
            wishlistData = data
        } catch {
            print("Greška pri čuvanju wishlist-a: \(error.localizedDescription)")
        }
    }

    private func loadWishlist() {
        guard let data = wishlistData else { return }
        do {
            wishlist = try JSONDecoder().decode([Hotel].self, from: data)
        } catch {
            print("Greška pri učitavanju wishlist-a: \(error.localizedDescription)")
        }
    }

    private func showNotification(_ oldValue: [Hotel], _ newValue: [Hotel]) {
        let newlyLiked = newValue.filter { !oldValue.contains($0) }
        let newlyUnliked = oldValue.filter { !newValue.contains($0) }

        if let likedHotel = newlyLiked.last {
            wishlistChangedHotel = likedHotel
            withAnimation {
                showLikeNotification = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    self.showLikeNotification = false
                }
            }
        }

        if let unlikedHotel = newlyUnliked.last {
            wishlistChangedHotel = unlikedHotel
            withAnimation {
                showUnlikeNotification = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    self.showUnlikeNotification = false
                }
            }
        }
    }
}

