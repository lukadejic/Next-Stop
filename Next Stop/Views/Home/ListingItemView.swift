import SwiftUI

struct ListingItemView: View {

    var body: some View {
        VStack(alignment: .leading){
            
            ListingImageCarouselView()
            .frame(height: 350)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .tabViewStyle(.page)
            
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 5){
                    Text("London, United Kingdom")
                        .font(.footnote)
                        .fontWeight(.semibold)
                    
                    Text("Stay with Lena - Hosting for 8 years")
                        .font(.caption)
                        .foregroundStyle(.black.opacity(0.7))
                    
                    Text("May 8 - 13")
                        .font(.caption)
                        .foregroundStyle(.black.opacity(0.7))
                    
                    HStack(spacing: 4){
                        Text("$135")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Text("night")
                    }
                }
                
                Spacer()
                
                HStack(spacing: 4){
                    Image(systemName: "star.fill")
                    
                    Text("4.68")
                }
            }
        }
        .padding()
    }
}

#Preview {
    ListingItemView()
}

