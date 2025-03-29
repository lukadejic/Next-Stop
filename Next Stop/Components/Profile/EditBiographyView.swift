import SwiftUI

struct EditBiographyView: View {
    @ObservedObject var vm: ProfileViewModel
    @Binding var text: String
    private let characterLimit = 40

    @Environment(\.dismiss) private var dismiss
    @FocusState private var showKeyboard: Bool

    private var isOverLimit: Bool {
        text.count > characterLimit
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            closeButton
            
            titleSection
            
            bioTextField
            
            saveButton
        }
        .onAppear {
            showKeyboard = true
        }
        .presentationDetents([.height(400)])
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}

#Preview {
    EditBiographyView(vm: ProfileViewModel(
        authManager: AuthenticationManager(),
        userManager: UserManager()), text: .constant(""))
}

private extension EditBiographyView {
    
    var closeButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark")
                .foregroundStyle(.black)
        }
        .padding(.bottom)
    }
    
    var titleSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("What would your biography title be?")
                .font(.title2)
                .fontWeight(.medium)

            Text("If someone wrote a book about your life, what would they call it? Example: Born to Roam or Chronicles of a Dog Mum.")
                .font(.callout)
                .foregroundStyle(.black.opacity(0.7))
        }
    }
    
    var bioTextField: some View {
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
            Text("My biography title would be:")
                .foregroundStyle(isOverLimit ? .red : .black.opacity(0.7))
                .font(.caption)
                .fontWeight(isOverLimit ? .heavy : .light)
                .padding(5)
                .padding(.horizontal)
        }
        .background(isOverLimit ? .red.opacity(0.1) : .white)
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

    var saveButton: some View {
        LogInButton(text: "Save", backgroundColor: .black, textColor: .white) {
            vm.updateUserInfo(for: .biography, newInfo: text)
            vm.updateUserBiography()
            dismiss()
        }
        .offset(x: 15)
        .padding(.top, 40)
        .disabled(isOverLimit)
        .opacity(isOverLimit ? 0.3 : 1)
    }
}
