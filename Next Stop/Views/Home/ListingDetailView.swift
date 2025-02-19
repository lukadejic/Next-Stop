import SwiftUI
import MapKit

struct ListingDetailView: View {
    
    let hotel: Hotel
    @EnvironmentObject private var vm :HomeViewModel
    @State private var showFullDescription : Bool = false
    
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
            
            hotelName
            
            Divider()
                .padding(.horizontal)
            
            accomodationInfo
            
            reviews
            
            description
            
            Divider()
            
            amenities
            
            Divider()
                .padding(.horizontal)
            
            map
        }
        .onAppear{
            vm.getHotelDescription(hotelId: hotel.hotelID ?? 1)
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
    
    var hotelName : some View {
        VStack(alignment: .leading){
            
            Text(vm.hotelDetail?.hotel_name ?? "Mock Hotel")
                .font(.title)
                .fontWeight(.semibold)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }
    
    var accomodationInfo : some View {
        
        VStack(alignment: .leading ,spacing: 10) {
            Text(String("\(vm.hotelDetail?.city ?? "Miami"), \(vm.hotelDetail?.country_trans ?? "Florida")"))
            
            Text(extractRoomInfo())
                .fontWeight(.regular)
                .font(.caption)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }
    
    var reviews: some View {
        HStack(spacing: 10) {
            Spacer()
            
            VStack {
                Text(String(format: "%.2f", hotel.property?.reviewScore ?? 4.99))
                
                let score = Int(hotel.property?.reviewScore ?? 4)
                
                HStack(spacing: 1) {
                    ForEach(0..<score, id: \.self) { _ in
                        Image(systemName: "star.fill")
                            .font(.system(size: 6))
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            
            Divider()
                .frame(height: 30)

            VStack {
                HStack {
                    Image(systemName: "sparkles")
                        .foregroundStyle(.yellow)
                    
                    Text("\(hotel.property?.reviewScoreWord ?? "Guest favourite")")
                        .font(.system(size: 10))
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 70)
                        .lineLimit(2)
                        .underline()
                    
                    Image(systemName: "sparkles")
                        .foregroundStyle(.yellow)
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            
            Divider()
                .frame(height: 30)

            VStack(spacing:1) {
                Text(String(format: "%.f", hotel.property?.reviewScore ?? 10))
                    .font(.footnote)
                    .fontWeight(.semibold)
                
                Text("Reviews")
                    .underline()
                    .font(.caption)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding()
            Spacer()
        }
        .overlay {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(lineWidth: 0.2)
        }
        .padding(.horizontal,10)
    }
    
    var amenities : some View {
        VStack(alignment: .leading, spacing: 16){
            Text("What this place offers")
                .font(.headline)
            
            if let benefits = vm.hotelDetail?.top_ufi_benefits {
                let uniqueBenefits = Array(Set(benefits.map{$0.translated_name}))
                
                ForEach(uniqueBenefits, id: \.self) { benefit in
                    HStack(spacing: 10) {
                        
                        Image(benefit ?? "")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                        
                        Text(benefit ?? "")
                        
                        Spacer()
                    }
                }
            }
        
        }
        .frame(maxWidth: .infinity,alignment: .leading)
        .padding(.horizontal)
    }
    
    var description : some View {
        VStack(alignment: .leading){
            Text("About this place")
                .font(.headline)
                .padding(.bottom, 10)
            
            VStack(alignment:.leading,spacing: 10) {
                ForEach(vm.hotelDescription, id: \.self) {description in
                    Text(description.description ?? "unknown description")
                        .lineLimit(5)
                }
                
                Button{
                    showFullDescription.toggle()
                }label: {
                    HStack{
                        Text("Show more")
                            .underline()
                            .fontWeight(.semibold)
                        Text(">")
                            .fontWeight(.semibold)
                    }
                }
                .foregroundStyle(.black)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .sheet(isPresented: $showFullDescription) {
            descriptionView
        }
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
                    HStack{
                        Text(String(format: "$%.2f", vm.hotelDetail?.product_price_breakdown?.charges_details?.amount?.value ?? 100.0))
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        Text("night")
                    }
                    .underline()
                    
                    Text(stayDate(arrivalDate: vm.hotelDetail?.arrival_date, departureDate: vm.hotelDetail?.departure_date))
                        .font(.caption)
                        .foregroundStyle(.black.opacity(0.7))
                    
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

                if match.range(at: 1).location != NSNotFound {
                    let beds = nsText.substring(with: match.range(at: 1))
                    let bedrooms = match.range(at: 2).location != NSNotFound ? nsText.substring(with: match.range(at: 2)) : "0"
                    let livingRooms = match.range(at: 3).location != NSNotFound ? nsText.substring(with: match.range(at: 3)) : "0"
                    let bathrooms = match.range(at: 4).location != NSNotFound ? nsText.substring(with: match.range(at: 4)) : "0"
                    
                    return "\(beds) beds • \(bedrooms) bedrooms • \(livingRooms) living rooms • \(bathrooms) bathrooms"
                }
                
                if match.range(at: 5).location != NSNotFound {
                    let singleBed = nsText.substring(with: match.range(at: 5))
                    return "Hotel room: \(singleBed) bed"
                }
            }
        }
        
        return "Room info not found"
    }
    
    var descriptionView : some View {
        ScrollView{
            VStack(alignment: .leading,spacing: 10){
                Text("About this place")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom, 10)
                
                ForEach(vm.hotelDescription, id: \.self) {description in
                    Text(description.description ?? "unknown description")
                        .multilineTextAlignment(.leading)
                        .font(.title3)
                    
                    Divider()
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .padding()
        }
    }
}
