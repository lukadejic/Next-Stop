import SwiftUI
import MapKit

struct ListingDetailView: View {
    
    let hotel: Hotel
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var vm : HomeViewModel
    @State private var showFullDescription : Bool = false
    @State private var isFullMapScreen : Bool = false
    @State private var isFullCancellationPolicy: Bool = false
    @State private var showCalendarView: Bool = false
    
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
            
            Divider()
                .padding(.horizontal)
            
            availability
            
            Divider()
                .padding(.horizontal)
            
            cancelationPolicy
        }
        .onAppear{
            //vm.getHotelDescription(hotelId: hotel.hotelID ?? 1)
        }
        .toolbar(.hidden, for: .tabBar)
        .toolbar(.hidden, for: .navigationBar)
        .overlay(alignment: .topLeading){
            Button{
                dismiss()
            }label: {
                BackButton()
                    .padding(32)
                    .padding(.top, 20)
            }
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
            VStack{
                MapView(latitude: vm.hotelDetail?.latitude ?? 37.347730, longitude: vm.hotelDetail?.longitude ?? -122.018715, annotationName: vm.hotelDetail?.hotel_name ?? "Panama Park")
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(alignment: .topTrailing, content: {
                        Image(systemName: "square.dashed")
                            .frame(width: 30, height: 30)
                            .background(in: Circle())
                            .shadow(radius: 7)
                            .padding(10)
                    })
                    .onTapGesture {
                        isFullMapScreen = true
                    }
            }
            .fullScreenCover(isPresented: $isFullMapScreen) {
                FullMapView(latitude: vm.hotelDetail?.latitude ?? 37.347730, longitude: vm.hotelDetail?.longitude ?? -122.018715, annotationName: vm.hotelDetail?.hotel_name ?? "Panama Park")
            }
        }
        .padding(.horizontal)
    }
    
    var cancelationPolicy : some View {
        VStack(alignment: .leading){
                Text("Cancellation policy")
                    .font(.headline)
            HStack{
                VStack(alignment: .leading) {
                    let arrival = arrivalDayFormater(date: vm.arrivalDay)
                    
                    Text("Free cancellation for 24 hours.Cancel before \(arrival) for partial refound")
                    
                    Text("Review this hotels full policy for details.")
                }
                .font(.callout)
                .foregroundStyle(.gray)
                
                Spacer()
                
                Text(">")
                    .fontWeight(.semibold)
            }
        }
        .onAppear{
            loadArrivalDay()
        }
        .onTapGesture {
            isFullCancellationPolicy = true
        }
        .fullScreenCover(isPresented: $isFullCancellationPolicy) {
            let arrival = String(arrivalDayConverter(arrivalDate: hotel.property?.checkinDate ?? "10 Mar") + "\n\(hotel.property?.checkin?.fromTime ?? "14:00")")
            
            CancellationPolicyView(arrival: arrival)
        }
        .frame(maxWidth: .infinity,alignment: .leading)
        .padding(.horizontal)
    }
    
    func loadArrivalDay() {
        if let arrivalDay = hotel.property?.checkinDate {
            vm.arrivalDay = CalendarHelpers.convertStringToDate(date: arrivalDay)
        }
    }
    
    var availability : some View {
        VStack(alignment: .leading,spacing: 10){
            Text("Availability")
                .font(.headline)
            HStack{
                Text(CalendarHelpers.formattedRangeDate(
                    startDate: vm.startDate,
                    endDate: vm.endDate))
                Spacer()
                
                Text(">")
            }
        }
        .onAppear{
            loadDates()
        }
        .onTapGesture {
            showCalendarView = true
        }
        .fullScreenCover(isPresented: $showCalendarView) {
            CalendarView(hotel: hotel)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
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
                        .background(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding(.horizontal)
            }
        }
        .background(.white)
        .padding(.horizontal)
    }
    
    func loadDates() {
        if let arrival = hotel.property?.checkinDate {
            vm.startDate = CalendarHelpers.convertStringToDate(date: arrival)
        }
        
        if let departure = hotel.property?.checkoutDate {
            vm.endDate = CalendarHelpers.convertStringToDate(date: departure)
        }
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
