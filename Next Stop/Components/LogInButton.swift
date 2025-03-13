import SwiftUI

struct LogInButton: View {
    @State var text: String
    var action : (() -> ())?
    
    var body: some View {
        Button{
            action?()
        }label: {
            Text(text)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .frame(width: 340, height: 60)
                .background(Color.pink)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

#Preview {
    LogInButton(text: "Log in")
}
