import SwiftUI
import MapKit

struct ListingDetailView: View {
    
    let hotel: Hotel
    @EnvironmentObject private var vm :HomeViewModel
    
    var body: some View {
        ScrollView {
            
            if let images = vm.hotelImages[hotel.hotelID ?? 0], !images.isEmpty {
                ListingImageCarouselView(images: images)
                    .frame(height: 350)
            } else {
                ProgressView()
                    .frame(height: 350)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            accomodationHeader
            
            Divider()
                .padding(.horizontal)
            
            hostHeader
            
            Divider()
                .padding(.horizontal)
            
            hostBadges
            
            Divider()
                .padding(.horizontal)
            
            sleepOptions
            
            Divider()
            
            amenities
            
            Divider()
                .padding(.horizontal)
            
            map
        }
        .toolbar(.hidden, for: .tabBar)
        .toolbar(.hidden, for: .navigationBar)
        .overlay(alignment: .topLeading){
            BackButton()
        }
        .padding(.bottom, 64)
        .ignoresSafeArea()
        .padding(.bottom, 10)
        .overlay(alignment: .bottom){
            reserveSection
        }
        
    }
}

#Preview {
    ListingDetailView(hotel: MockData.mockHotel)
        .environmentObject(HomeViewModel(hotelsService: HotelsService()))
}

private extension ListingDetailView {
    var accomodationHeader : some View {
        VStack(alignment: .leading){
            
            Text(vm.hotelDetail?.hotel_name ?? "Mock Hotel")
                .font(.title)
                .fontWeight(.semibold)
            
            VStack(alignment: .leading){
                HStack{
                    Image(systemName: "star.fill")
                    
                    Text(String(format: "$%.2f", vm.hotelDetail?.product_price_breakdown?.charges_details?.amount?.value ?? 0.0))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    Text(String("\(vm.hotelDetail?.review_nr ?? 1) reviews"))
                        .underline()
                        .fontWeight(.semibold)
                }
                Text(String("\(vm.hotelDetail?.city ?? "Miami"), \(vm.hotelDetail?.country_trans ?? "Florida")"))
            }
            .font(.caption)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }
    
    var hostHeader : some View {
        HStack{
            VStack(alignment: .leading){
                Text("Large villa hosted by Sean Allen")
                    .font(.headline)
                    .frame(width: 250,alignment: .leading)
                
                Text(extractRoomInfo())
                   .font(.caption)
            }
            .frame(width: 300,alignment: .leading)
            
            Spacer()
            
            Image("person-1")
                .resizable()
                .scaledToFill()
                .frame(width: 64, height: 64)
                .clipShape(Ellipse())
        }
        .padding(.horizontal,10)
    }
    
    var hostBadges : some View {
        VStack(alignment: .leading, spacing: 10){
            ForEach(0..<2, id:\.self) { feature in
                
                HStack(spacing: 12){
                    Image(systemName: "medal")
                    
                    VStack(alignment: .leading){
                        Text("Superhost")
                            .font(.footnote)
                            .fontWeight(.semibold)
                        
                        Text("Superhosts are expirienced, highly rated hosts who are commited for providing great stars for the guests")
                            .font(.caption)
                            .foregroundStyle(.black.opacity(0.7))
                    }
                    
                    Spacer()
                }
            }
        }
        .padding(.horizontal,10)
    }
    
    var sleepOptions : some View {
        VStack(alignment: .leading){
            Text("Where you`ll sleep")
                .font(.headline)
                .fontWeight(.semibold)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20){
                    ForEach(0..<2, id: \.self) { image in
                        
                    }
                }
            }
        }
        .padding(.horizontal)
    }
    
    var amenities : some View {
        VStack(alignment: .leading, spacing: 16){
            Text("What this place offers")
                .font(.headline)
            
            if let benefits = vm.hotelDetail?.top_ufi_benefits {
                ForEach(benefits, id: \.icon) { benefit in
                    HStack(spacing: 10) {
                        
                        Text(benefit.translated_name ?? "")
                        
                        Spacer()
                    }
                }
            }
        
        }
        .padding(.horizontal)
    }
    
    var map : some View {
        VStack(alignment: .leading, spacing: 16){
            Text("Where you`ll be")
                .font(.headline)
            
            Map()
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(.horizontal)
    }
    
    var reserveSection : some View {
        VStack{
            Divider()
            
            HStack{
                VStack(alignment:.leading){
                    Text("$500")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    Text("Total before taxes")
                        .font(.footnote)
                    
                    Text("Oct 15 - 20")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .underline()
                }
                .padding(.horizontal)
                Spacer()
                
                Button{
                    
                }label:{
                    Text("Reserve")
                        .foregroundStyle(.white)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .frame(width: 140, height: 40)
                        .background(.pink)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding(.horizontal)
            }
        }
        .background(.white)
        .padding(.horizontal)
        

    }
    
    func extractRoomInfo() -> String {
        guard let text = hotel.accessibilityLabel else { return "No data" }
        
        let regexPattern = #"(\d+)\s*beds?(?:\s*•\s*(\d+)\s*bedrooms?)?(?:\s*•\s*(\d+)\s*living rooms?)?(?:\s*•\s*(\d+)\s*bathrooms?)?|Hotel\s*room\s*:\s*(\d+)\s*bed"#

        if let regex = try? NSRegularExpression(pattern: regexPattern, options: []) {
            let range = NSRange(text.startIndex..<text.endIndex, in: text)
            
            if let match = regex.firstMatch(in: text, options: [], range: range) {
                let nsText = text as NSString
                
                // Ako pronađe format "X beds • Y bedrooms • Z living rooms • W bathrooms"
                if match.range(at: 1).location != NSNotFound {
                    let beds = nsText.substring(with: match.range(at: 1))
                    let bedrooms = match.range(at: 2).location != NSNotFound ? nsText.substring(with: match.range(at: 2)) : "0"
                    let livingRooms = match.range(at: 3).location != NSNotFound ? nsText.substring(with: match.range(at: 3)) : "0"
                    let bathrooms = match.range(at: 4).location != NSNotFound ? nsText.substring(with: match.range(at: 4)) : "0"
                    
                    return "\(beds) beds • \(bedrooms) bedrooms • \(livingRooms) living rooms • \(bathrooms) bathrooms"
                }

                // Ako pronađe format "Hotel room: X bed"
                if match.range(at: 5).location != NSNotFound {
                    let singleBed = nsText.substring(with: match.range(at: 5))
                    return "Hotel room: \(singleBed) bed"
                }
            }
        }
        
        return "Room info not found"
    }
    
}
