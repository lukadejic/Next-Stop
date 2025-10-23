import SwiftUI

struct PriceSectionView: View {
    let price: Double?
    let rating: Double?
    let buttonText: String
    var action : (()->())?
    
    var body: some View {
        VStack {
            Divider()
            
            HStack {
                VStack(alignment: .leading,spacing: 5) {
                    HStack {
                        Text(String(format: "$%.2f", price ?? 100.0))
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        Text("night")
                    }
                    .underline()
                    
                    HStack(spacing: 3){
                        Image(systemName: "star.fill")
                            .font(.system(size: 12))
                        
                        Text("4.49")
                            .fontWeight(.semibold)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                Button {
                    action?()
                } label: {
                    Text(buttonText)
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
    
}

#Preview {
    PriceSectionView(price: 150.0,
                     rating: 4.49,
                     buttonText: "Reserve")
}
