import SwiftUI

struct LikeNotificationView: View {
    @Binding var showNotification: Bool
    var body: some View {
        
        VStack {
            HStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 55, height: 55)
                
                Spacer()
                
                HStack(alignment: .center) {
                    Text("Saved")
                        .layoutPriority(1)
                    
                    Text("Hotel name testda d adada dada")
                        .fontWeight(.semibold)
                        .truncationMode(.tail)
                        .lineLimit(1)
                        .multilineTextAlignment(.leading)
                    
                    Text("to the wishlist.")
                        .layoutPriority(1)
                        .truncationMode(.tail)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
            }
            .padding(10)
        }
        .frame(maxWidth: .infinity)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(radius: 10)
        .padding()
        .offset(y: showNotification ? 0 : 300)
        .transition(.move(edge: .bottom).combined(with: .opacity))
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: showNotification)
    }
}

#Preview {
    LikeNotificationView(showNotification: .constant(false))
}
