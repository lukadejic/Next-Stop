import SwiftUI

struct AuthenticationField: View {
    @Binding var text: String
    let image: String
    
    var body: some View {
        HStack{
            Image(systemName: image)
                .foregroundStyle(Color.logInBackground)
                .frame(width: 30, height: 30)
                .imageScale(.large)
                .background(.white)
                .clipShape(Circle())
            
            TextField("", text: $text)
            
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
    AuthenticationField(text: .constant(""), image: "person.fill")
}
