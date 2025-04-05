import SwiftUI

struct SettingsOptionView: View {
    let image: String
    let text: String
    
    var body: some View {
        HStack {
            Image(systemName: image)
                .imageScale(.large)
                .padding(.trailing)
            
            Text(text)
                .font(.title3)
            
            Spacer()
            
            VStack{
                Image("next")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 15, height: 15)
            }
            .frame(width: 30, height: 30)
        }
        
        Rectangle()
            .stroke(lineWidth: 0.27)
            .frame(height: 1)
    }
}

#Preview {
    SettingsOptionView(image: "person.circle", text: "Personal information")
}
