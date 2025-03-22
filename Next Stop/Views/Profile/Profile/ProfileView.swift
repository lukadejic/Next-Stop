import SwiftUI

struct ProfileView: View {
    @ObservedObject var vm: ProfileViewModel
    @State private var showLoginView = false
    let authManager = AuthenticationManager()
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Profile")
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                    }
                    .padding(.top, 30)
                    
                    if vm.user == nil {
                        VStack(alignment: .leading) {
                            Text("Log in to start planning your next trip.")
                                .font(.title3)
                                .foregroundStyle(.black.opacity(0.5))
                                .padding(.top, 20)
                            
                            LogInButton(text: "Log in",
                                        backgroundColor: .pink,
                                        textColor: .white) {
                                withAnimation(.snappy) {
                                    showLoginView.toggle()
                                }
                            }
                        }
                    } else {
                        VStack(alignment: .leading) {
                            Text(vm.user?.email ?? "Test user")
                            
                            Button {
                                vm.signOut()
                            } label: {
                                Text("Log out")
                            }
                        }
                    }
                    Spacer()
                }
            }
            .onAppear {
                vm.getAuthenticatedUser()
            }
            .fullScreenCover(isPresented: $showLoginView) {
                LogInView(authManager: authManager, show: $showLoginView)
            }

        }
    }
}

#Preview {
    ProfileView(vm: ProfileViewModel(authManager: AuthenticationManager()))
}
