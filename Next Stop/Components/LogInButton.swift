import SwiftUI

struct LogInButton: View {
    @State var text: String
    @State var backgroundColor: Color
    @State var textColor: Color
    
    var action : (() -> ())?
    var body: some View {
        Button{
            action?()
        }label: {
            Text(text)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(textColor)
                .frame(width: 340, height: 60)
                .background(backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

#Preview {
    LogInButton(text: "Log in",
                backgroundColor: Color.pink,
                textColor: .white)
}
