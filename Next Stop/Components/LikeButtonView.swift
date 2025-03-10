import SwiftUI

struct LikeButtonView: View {
    @Binding var isLiked: Bool
    
    var body: some View {
        Button{
            withAnimation(.snappy){
                isLiked.toggle()
            }
        }label: {
            Image(isLiked ? "heartLike" : "heartUnlike")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .padding()
                .foregroundStyle(.black.opacity(0.8))
        }
    }
}

#Preview {
    LikeButtonView(isLiked: .constant(false))
}
