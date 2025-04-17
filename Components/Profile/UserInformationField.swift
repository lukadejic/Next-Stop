import SwiftUI

struct UserInformationField: View {
    let icon: String
    let text: String
    var info: String
    
    var body: some View {
        HStack(spacing: 10){
            Image(icon)
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
            
            Text(info.isEmpty ? text : "\(text): \(info)")
                .font(.title3)
                .foregroundStyle(info.isEmpty ? .gray : .black)
        }
    }
}

#Preview {
    UserInformationField(icon: "speak", text: "Speaks", info: "English and Spanish")
}
