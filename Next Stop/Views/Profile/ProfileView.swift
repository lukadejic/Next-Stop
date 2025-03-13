import SwiftUI

struct ProfileView: View {
    @State private var showLoginView = false
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading){
                VStack(alignment: .leading,spacing: 10) {
                    Text("Profile")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                    Text("Log in to start planning your next trip.")
                        .font(.title3)
                        .foregroundStyle(.black.opacity(0.5))
                }
                .padding(.top,30)
                
                LogInButton(text: "Log in",
                            backgroundColor: .pink,
                            textColor: .white){
                    withAnimation(.snappy) {
                        showLoginView.toggle()
                    }
                }
                .padding(.top, 50)
                
                HStack{
                    Text("Don't have an account?")
                        .foregroundStyle(.black.opacity(0.5))
                    Button{
                        
                    }label: {
                        Text("Sign up")
                            .underline()
                            .fontWeight(.medium)
                    }
                    .tint(.black)
                }
                .padding(.top, 20)
                
                
                Spacer()
            }
        }
        .fullScreenCover(isPresented: $showLoginView) {
            LogInView()
        }
    }
}

#Preview {
    ProfileView()
}
