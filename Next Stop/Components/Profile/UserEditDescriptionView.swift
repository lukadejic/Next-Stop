
import SwiftUI

struct UserEditDescriptionView: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var text: String
    
    let title: String
    let description: String
    let buttonText: String
    
    var action: (() -> ())?
    
    private let characterLimit = 40
    
    @FocusState private var showKeyboard: Bool
    
    var isOverLimit: Bool {
        text.count > characterLimit
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            dismissButton
            
            descriptionSection
            
            textField
            
            saveButton
        }
        .padding()
    }
}

#Preview {
    UserEditDescriptionView(text: .constant(""),
                            title: "What do you do or work?",
                            description: "Tell us what your proffesion is.If you don't have a traditional job, tell us your life's calling.",
                            buttonText: "My work:")
}

private extension UserEditDescriptionView {
    var saveButton: some View {
        LogInButton(text: "Save", backgroundColor: .black, textColor: .white) {
            action?()
            dismiss()
        }
        .offset(x: 15)
        .padding(.top, 40)
        .disabled(isOverLimit)
        .opacity(isOverLimit ? 0.3 : 1)
    }
    
    var textField: some View {
        VStack(alignment: .leading, spacing: 10) {
            TextField("", text: $text)
                .padding(.top, 50)
                .padding(.horizontal)
                .focused($showKeyboard)

            characterCounter
        }
        .frame(height: 50)
        .background(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 1))
        .overlay(alignment: .topLeading) {
            Text(buttonText)
                .foregroundStyle(isOverLimit ? .red : .black.opacity(0.7))
                .font(.caption)
                .fontWeight(isOverLimit ? .heavy : .light)
                .padding(5)
                .padding(.horizontal)
        }
        .background(isOverLimit ? .red.opacity(0.1) : .white)
    }
    
    var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.title2)
                .fontWeight(.medium)

            Text(description)
                .font(.callout)
                .foregroundStyle(.black.opacity(0.7))
        }
    }
    
    var dismissButton : some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark")
                .foregroundStyle(.black)
        }
        .padding(.bottom)
        
    }
    
    var characterCounter: some View {
        HStack {
            if isOverLimit {
                HStack(spacing: 5) {
                    Image(systemName: "exclamationmark.triangle.fill")
                    Text("Character limit reached")
                }
                .foregroundStyle(.red)
                .font(.caption)
                .fontWeight(.semibold)
            } else {
                Text("\(text.count)/\(characterLimit) characters")
                    .foregroundStyle(.black.opacity(0.7))
                    .font(.caption)
            }
        }
    }
}
