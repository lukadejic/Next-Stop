import SwiftUI

struct RemoveButtonView: View {
    var action : (() -> ())?
    
    var body: some View {
        Button{
            action?()
        }label: {
            Image(systemName: "xmark")
                .frame(width: 25, height: 25)
                .background(.white)
                .imageScale(.medium)
                .clipShape(Circle())
                .shadow(radius: 8)
                .foregroundStyle(.black)
        }

    }
}

#Preview {
    RemoveButtonView()
}
