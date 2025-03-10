import SwiftUI

struct WishlistView: View {
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationView {
            VStack{
                ScrollView{
                    LazyVGrid(columns: columns,spacing: 32) {
                        ForEach(0..<4, id: \.self) {item in
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: 170, height: 170)
                        }
                    }
                    Spacer()
                }
            }
            .navigationTitle("Wishlists")
            .toolbar{
                ToolbarItem(placement: .topBarTrailing) {
                    Button{
                        
                    }label: {
                        Text("Edit")
                            .font(.title3)
                            .fontWeight(.medium)
                            .underline()
                    }
                }
            }
        }
        .tint(.black)
    }
}

#Preview {
    WishlistView()
}
