import SwiftUI

struct ProfileDetailsView: View {
    @ObservedObject var vm: ProfileViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var showEditView = false
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        
        ScrollView {
            
            VStack {
                
                header
                
                userInfo
                
                Spacer()
            }
            .onAppear {
                vm.interests = vm.user?.interests ?? []
            }
            .sheet(isPresented: $showEditView) {
                NavigationView {
                    EditProfileView(vm: vm, show: $showEditView)
                }
            }
            .frame(maxWidth: .infinity)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button{
                        dismiss()
                    }label: {
                        Image("back")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15, height: 15)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button{
                        showEditView.toggle()
                    }label: {
                        Text("Edit")
                            .fontWeight(.semibold)
                            .underline()
                            .padding()
                    }
                    .foregroundStyle(.black)
                }
            }
        }
    }
}

#Preview {
    ProfileDetailsView(vm: ProfileViewModel(
        authManager: AuthenticationManager(),
        userManager: UserManager()))
}

private extension ProfileDetailsView {
    var header: some View {
        VStack{
            if let photoURL = vm.user?.photoURL {
                AsyncImageView(url: photoURL,
                               width: 130, height: 130)
            }else{
                Image("user")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 130, height: 130)
                    .clipShape(Circle())
            }
            
            Text(vm.user?.displayName ?? "Unknown")
                .font(.title)
                .fontWeight(.semibold)
            
            Text("Guest")
        }
        .frame(width: 370, height: 300)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(radius: 10)
        .padding(.top)
    }
    
    var userInfo: some View {
        VStack(alignment: .leading){
            VStack(alignment: .leading, spacing: 25) {
                ForEach(vm.userInfoList) { info in
                    UserInformationField(icon: info.icon,
                                         text: info.text,
                                         info: info.info)
                }
            }
            
            Rectangle()
                .stroke(lineWidth: 0.27)
                .frame(height: 1)
            
            VStack(alignment: .leading) {
                if let interests = vm.user?.interests {
                    Text("Ask \(vm.user?.displayName ?? "Luka") about")
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    LazyVGrid(columns: columns) {
                        ForEach(interests) { interest in
                            InterestItem(icon: interest.icon,
                                         name: interest.name,
                                         selectedInterests: $vm.interests)
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
        .padding(.top,25)
        
    }
}
