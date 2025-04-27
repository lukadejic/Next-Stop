import SwiftUI

struct LogedInProfileView: View {
    @ObservedObject var vm: ProfileViewModel
    
    var body: some View {
        NavigationView{
            VStack(alignment:.leading) {
                
                profileHeader
                
                settings
                
                Spacer()
                
                logout
            }
        }
    }
}

#Preview {
    LogedInProfileView(vm: ProfileViewModel(
        authManager: AuthenticationManager(),
        userManager: UserManager()))
}

private extension LogedInProfileView {
    var settings: some View {
        VStack(alignment: .leading,spacing: 10) {
            Text("Settings")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.bottom)
            
            NavigationLink {
                PersonalInformationView()
            } label: {
                VStack{
                    SettingsOptionView(image: "person.fill",
                                       text: "Personal information")
                }
            }
            .foregroundStyle(.black)

            NavigationLink {
                Login_SecurityView()
            } label: {
                VStack{
                    SettingsOptionView(image: "shield",
                                       text: "Login & security")
                }
            }
            .foregroundStyle(.black)

        }
        .padding()
    }
    
    var logout: some View {
        Button {
            try? vm.signOut()
        }label: {
            Text("Log out")
                .fontWeight(.semibold)
                .underline()
                .padding()
                .foregroundStyle(.black)
        }
    }
    
    var profileHeader: some View {
        NavigationLink {
            ProfileDetailsView(vm: vm)
        } label: {
            ProfileHeaderView(vm: vm)
        }
    }
}
