import SwiftUI

struct ProfileHeaderView: View {
    @ObservedObject var vm: ProfileViewModel
    
    var body: some View {
        VStack(spacing: 0){
            HStack(spacing: 20){
                AsyncImage(url: URL(string:vm.user?.photoURL ?? ""))
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())

                VStack(alignment: .leading,spacing: 5) {
                    Text(vm.user?.email ?? "test@gmail.com")
                        .font(.headline)
                        .fontWeight(.medium)
                    
                    Text("Show profile")
                        .font(.subheadline)
                        .foregroundStyle(.black.opacity(0.6))
                }
                
                Spacer()
                
                Text(">")
                    .font(.title)
                    .fontWeight(.medium)
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
    ProfileHeaderView(vm: ProfileViewModel(authManager: AuthenticationManager()))
}
