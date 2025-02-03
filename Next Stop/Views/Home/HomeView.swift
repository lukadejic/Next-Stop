
import SwiftUI

struct HomeView: View {
    
    @State private var selectedStayOption: StayOptionType = .lakeFront

    
    var body: some View {
        NavigationStack{
            ZStack {
                VStack {
                    SearchBarView()
                    
                    stayOptionsHeader
                    
                    listingList
                }
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
        HStack(spacing: 32) {
            VStack {
                Image(systemName: option.imageName)
                    .fontWeight(.light)
                    .foregroundStyle(.black.opacity(0.8))
                    .frame(width: 30, height: 40)
                    .font(.title)
                
                Text(option.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
                
                
                Rectangle()
                    .fill(Color.black)
                    .frame(width: 50, height: 2)
                    .padding(.top, 5)
                    .opacity(selectedStayOption == option ? 1 : 0)
            }
            .padding(.horizontal,10)
            .frame(height: 102)
            .scaleEffect(
                withAnimation(.easeOut, {
                    selectedStayOption == option ? 1.2 : 1
                })
                
            )
            .onAppear{
                let queryKeyword = option.querryKeywords
                print(queryKeyword)
            }
            .opacity(selectedStayOption == option ? 1 : 0.5)
            .onTapGesture {
                let queryKeyword = option.querryKeywords
                print(queryKeyword)
                withAnimation {
                    selectedStayOption = option
                }
            }
        }
    }
    
    var listingList : some View {
        ScrollView{
            LazyVStack(spacing: 30){
                ForEach(0..<5, id: \.self) { listing in
                    NavigationLink {
                        ListingDetailView()
                    } label: {
                        ListingItemView()
                    }

                }
            }
            .padding(.horizontal,10)
        }
    }
}

#Preview {
    HomeView()
}
