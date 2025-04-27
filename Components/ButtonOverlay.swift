import SwiftUI

struct ButtonOverlay: View {
    let text: String
    var action : (() -> ())?
    
    var body: some View {
        VStack {
            Divider()

            Button{
                action?()
            }label:{
                Text(text)
                    .foregroundStyle(.white)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .frame(width: 300, height: 40)
                    .background(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding(.horizontal)
            
        }
        .background(.white)
        .padding(.horizontal)
    }
}

#Preview {
    ButtonOverlay(text: "Save")
}
