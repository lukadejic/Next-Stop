import SwiftUI

struct EditObsessedView: View {
    
    @ObservedObject var vm: ProfileViewModel
    @State private var text: String = ""
    private let characterLimit = 40

    @Environment(\.dismiss) private var dismiss
    @FocusState private var showKeyboard: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            closeButton
            
            titleSection
            
            bioTextField
            
            saveButton
        }
        .onAppear {
            showKeyboard = true
            text = vm.user?.obsessed ?? ""
        }
        .presentationDetents([.height(400)])
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}

#Preview {
    EditObsessedView(vm: ProfileViewModel(
        authManager: AuthenticationManager(),
        userManager: UserManager()))
}

private extension EditObsessedView {
    
    var isOverLimit: Bool {
        text.count > characterLimit
    }
    
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
            Text("What are you obsessed with?")
                .font(.title2)
                .fontWeight(.medium)

            Text("Share whatever you can't get enough of - in a good way.Example: Baking resemary focaccia.")
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
            Text("I'm obsessed with:")
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
            vm.updateObsessedUserText(text: text)
            dismiss()
        }
        .offset(x: 15)
        .padding(.top, 40)
        .disabled(isOverLimit)
        .opacity(isOverLimit ? 0.3 : 1)
    }
}
