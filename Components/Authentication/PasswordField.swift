import SwiftUI

struct PasswordField: View {
    @Binding var password: String
    
    var body: some View {
        HStack{
            Image(systemName: "lock")
                .foregroundStyle(Color.logInBackground)
                .frame(width: 30, height: 30)
                .imageScale(.large)
                .background(.white)
                .clipShape(Circle())
            
            SecureField("", text: $password)
        }
        .padding()
        .background(Color.pink.opacity(0.7))
        .cornerRadius(10)
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(lineWidth: 0.8)
                .foregroundStyle(.white)
        }
        .padding(.horizontal,20)
    }
}

#Preview {
    PasswordField(password: .constant(""))
}
