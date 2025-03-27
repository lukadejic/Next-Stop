import SwiftUI

struct EditBiographyView: View {
    @State private var text : String = ""
    private let characterLimit = 40
    
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(alignment: .leading,spacing: 20) {
            Button{
                dismiss()
            }label: {
                Image(systemName: "xmark")
                    .foregroundStyle(.black)
            }
            .padding(.bottom)
            
            Text("What would your biography title be?")
                .font(.title2)
                .fontWeight(.medium)
            
            Text("If someone wrote a book about your life, what would they call it? Example: Born to Roam or Chronicles of a Dog Mum.")
                .font(.callout)
                .foregroundStyle(.black.opacity(0.7))
        
            VStack(alignment: .leading, spacing: 30){
                TextField("", text: $text)
                    .padding(.top, 50)
                    .padding(.horizontal)

                HStack {
                    if text.count <= characterLimit {
                        Text("\(text.count)/\(characterLimit) characters")
                            .foregroundStyle(text.count > characterLimit ? .red : .black.opacity(0.7))
                            .font(.caption)
                        
                    } else {
                        HStack(spacing: 5){
                            Image(systemName: "exclamationmark.triangle.fill")
                            
                            Text("Character limit reached")
                        }
                        .foregroundStyle(.red)
                        .font(.caption)
                        .fontWeight(.semibold)
                    }
                }
            }
            .frame(height: 50)
            .background(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 1))
            .overlay(alignment: .topLeading ){
                Text("My biography title would be:")
                    .foregroundStyle(text.count > characterLimit ? .red : .black.opacity(0.7))
                    .font(.caption)
                    .fontWeight(text.count > characterLimit ? .heavy : .light)
                    .padding(5)
                    .padding(.horizontal)
            }
            .background(text.count > characterLimit ? .red.opacity(0.1) : .white)
            
            LogInButton(text: "Save", backgroundColor: .black, textColor: .white) {
                
            }
            .offset(x: 15)
            .padding(.top, 40)
            .disabled(text.count > characterLimit)
            .opacity(text.count > characterLimit ? 0.3 : 1)
        }
        .presentationDetents([.height(400)])
        .frame(maxWidth: .infinity,alignment: .leading)
        .padding()
    }
}

#Preview {
    EditBiographyView()
}
