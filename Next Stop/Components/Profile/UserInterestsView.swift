import SwiftUI

struct UserInterestsView: View {
    @ObservedObject var vm: ProfileViewModel
    
    @Environment(\.dismiss) var dismiss
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    
    var body: some View {
        VStack(alignment: .leading) {
            dismissButton
            
            header
            
            interestItems
            
            Spacer()
            
            Text("\(vm.interests.count)/15 selected")
                .font(.title3)
                .fontWeight(.semibold)
                .padding(.bottom,60)
        
        }
        .overlay(alignment:.bottom) {
            ButtonOverlay(text: "save"){
                vm.updateUserInterests()
                dismiss()
            }
        }
        .frame(maxWidth: .infinity,alignment: .leading)
        .padding()
    }
}

#Preview {
    UserInterestsView(vm: ProfileViewModel(
        authManager: AuthenticationManager(),
        userManager: UserManager()))
}

struct InterestItem: View {
    let icon: String
    let name: String
    
    @Binding var selectedInterests: [Interest]

    var isSelected: Bool {
        selectedInterests.contains { $0.name == name }
    }
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(.black.opacity(0.7))
            
            Text(name)
                .layoutPriority(1)
                .fixedSize(horizontal: true, vertical: false)
        }
        .padding(.horizontal, 10)
        .frame(height: 30)
        .background(RoundedRectangle(cornerRadius: 15)
            .stroke(lineWidth: isSelected ? 2 : 0.5))
    }
}

private extension UserInterestsView {
    func selectInterest(interest: Interest) {
        if let index = vm.interests.firstIndex(where: { $0.name == interest.name }) {
            vm.interests.remove(at: index)
        } else {
            vm.interests.append(interest)
        }
    }
    
    var allInterests: [Interest] {
        return [
            Interest(icon: "frying.pan", name: "Cooking"),
            Interest(icon: "mountain.2", name: "Hiking"),
            Interest(icon: "gamecontroller", name: "Gaming"),
            Interest(icon: "cup.and.saucer", name: "Coffee"),
            Interest(icon: "pawprint", name: "Animals"),
            Interest(icon: "fork.knife", name: "Food"),
            Interest(icon: "figure.walk", name: "Walking"),
            Interest(icon: "paintpalette", name: "Art"),
            Interest(icon: "leaf", name: "Plants"),
            Interest(icon: "book", name: "Reading"),
            Interest(icon: "pencil.and.ruler", name: "Design"),
            Interest(icon: "cart", name: "Shopping"),
            Interest(icon: "tshirt", name: "Self-care"),
            Interest(icon: "movieclapper", name: "Films"),
            Interest(icon: "camera", name: "Photo")
        ]
    }
    
    var dismissButton: some View {
        Button {
            
        } label: {
            Image(systemName: "xmark")
                .foregroundStyle(.black)
        }
        .padding(.bottom)
        .padding(.bottom)
    }
    
    var header: some View {
        VStack(alignment: .leading,spacing: 20){
            Text("What are you into?")
                .font(.title)
                .fontWeight(.semibold)
            
            Text("Pick some interests that you enjoy and that you want to show on your profile.")
        }
    }
    
    var interestItems: some View {
        VStack(alignment: .leading){
            Text("Interests")
                .font(.title3)
                .fontWeight(.semibold)
  
            LazyVGrid(columns: columns,spacing: 20) {
                ForEach(allInterests) { interest in
                    InterestItem(icon: interest.icon,
                                 name: interest.name,
                                 selectedInterests: $vm.interests)
                    .onTapGesture {
                        selectInterest(interest: interest)
                    }
                }
            }
        }
        .padding(.top, 40)
    }
}
