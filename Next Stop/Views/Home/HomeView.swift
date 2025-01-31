
import SwiftUI

struct HomeView: View {
    
    @State private var selectedStayOption: StayOptionType = .rooms
    
    var body: some View {
        ZStack {
            VStack {
                SearchBarView()

                stayOptionsHeader
                
                listingList
                
            }
        }
    }

}

private extension HomeView {
    var stayOptionsHeader: some View {
        ScrollView(.horizontal){
            HStack {
                ForEach(StayOptionType.allCases, id: \.self) { option in
                    stayOptionView(for: option)
                }
            }
        }
    }
    
    func stayOptionView(for option: StayOptionType) -> some View {
        VStack {
            Image(systemName: option.imageName)
                .fontWeight(.light)
                .foregroundStyle(.black.opacity(0.8))
                .frame(width: 30, height: 40)
                .font(.title)
                .padding(.bottom, 5)
                .padding(.horizontal, 20)
            
            Text(option.rawValue)
                .font(.subheadline)
                .fontWeight(.medium)
            
            Rectangle()
                .fill(Color.black)
                .frame(width: 50, height: 3)
                .padding(.top, 5)
                .opacity(selectedStayOption == option ? 1 : 0)
        }
        .frame(height: 102)
        .scaleEffect(
            withAnimation(.easeOut, {
                selectedStayOption == option ? 1.2 : 1
            })
            
        )
        .opacity(selectedStayOption == option ? 1 : 0.5)
        .onTapGesture {
            withAnimation {
                selectedStayOption = option
            }
        }
    }
    
    var listingList : some View {
        ScrollView{
            LazyVStack(spacing: 30){
                ForEach(0..<5, id: \.self) { listing in
                    ListingItemView()
                        .frame(height: 400)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            .padding(.horizontal,10)
        }
    }
}

#Preview {
    HomeView()
}
