import SwiftUI

struct ProfileHeaderView: View {
    @ObservedObject var vm: ProfileViewModel
    
    var body: some View {
        VStack(spacing: 0){
            HStack(spacing: 20){
                if let photoURL = vm.user?.photoURL {
                    AsyncImageView(url: photoURL,
                                   width: 60, height: 60)
                }else{
                    Image("user")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                }

                VStack(alignment: .leading,spacing: 5) {
                    Text(vm.user?.displayName ?? "Test")
                        .font(.headline)
                        .fontWeight(.medium)
                    
                    Text("Show profile")
                        .font(.subheadline)
                        .foregroundStyle(.black.opacity(0.6))
                }
                
                Spacer()
                
                Image("next")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 15, height: 15)
            }
            .tint(.black)
            .padding()
            
            Rectangle()
                .stroke(lineWidth: 0.27)
                .frame(height: 1)
                .padding(.horizontal)
        }
    }
}

#Preview {
    ProfileHeaderView(vm: ProfileViewModel(
        authManager: AuthenticationManager(),
        userManager: UserManager()))
}
