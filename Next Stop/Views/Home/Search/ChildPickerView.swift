import SwiftUI

struct ChildPickerView: View {
    let child: Int
    @Binding var showPicker: Bool
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Child \(child + 1)")
            
            HStack{
                Text("8 years old")
                    .font(.footnote)
                    .foregroundStyle(.black.opacity(0.8))
                    .padding(10)
                Spacer()
                
                Button{
                    withAnimation(.snappy) {
                        showPicker.toggle()
                    }
                }label: {
                    Image("arrow.down")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .padding(.horizontal,7)
                }
                
            }
            .background(RoundedRectangle(cornerRadius: 3)
                .stroke(lineWidth: 0.5))
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    ChildPickerView(child: 1, showPicker: .constant(false))
}
