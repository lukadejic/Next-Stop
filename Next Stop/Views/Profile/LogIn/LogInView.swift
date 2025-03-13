import SwiftUI

struct LogInView: View {
    @StateObject private var vm = LogInViewModel()
    @FocusState var isEmailFocused: Bool
    @FocusState var isPasswordFocused: Bool
    @Binding var show: Bool
    
    var body: some View {
        NavigationView{
            VStack{
                Image("NextStopLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                
                Spacer()
                
                VStack(spacing: 30) {
                    HStack{
                        Image(systemName: "person.fill")
                            .foregroundStyle(Color.logInBackground)
                            .frame(width: 30, height: 30)
                            .imageScale(.large)
                            .background(.white)
                            .clipShape(Circle())
                        
                        TextField("", text: $vm.email)
                        
                    }
                    .padding()
                    .background(Color.pink.opacity(0.7))
                    .cornerRadius(10)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 0.8)
                            .foregroundStyle(.white)
                    }
                    .overlay{
                        Text(!isEmailFocused && vm.email.isEmpty ? "Email" : "")
                            .allowsHitTesting(false)
                    }
                    .padding(.horizontal,40)
                    .foregroundStyle(.white)
                    .focused($isEmailFocused)
                    
                    HStack{
                        Image(systemName: "lock")
                            .foregroundStyle(Color.logInBackground)
                            .frame(width: 30, height: 30)
                            .imageScale(.large)
                            .background(.white)
                            .clipShape(Circle())
                        
                        SecureField("", text: $vm.password)
                    }
                    .padding()
                    .background(Color.pink.opacity(0.7))
                    .cornerRadius(10)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 0.8)
                            .foregroundStyle(.white)
                    }
                    .overlay{
                        Text(!isPasswordFocused && vm.password.isEmpty ? "Password" : "")
                            .allowsHitTesting(false)
                    }
                    .padding(.horizontal,40)
                    .foregroundStyle(.white)
                    .focused($isPasswordFocused)
                }
                
                Spacer()
                VStack(spacing: 20){
                    LogInButton(text: "Sign in",
                                backgroundColor: .white,
                                textColor: Color.logInBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(radius: 10)
                    
                    HStack{
                        Text("Don't have an account?")
                            .foregroundStyle(.white)
                        Button{
                            
                        }label: {
                            Text("Sign up")
                                .underline()
                                .fontWeight(.medium)
                                .foregroundStyle(.white)
                        }
                    }
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity,maxHeight: .infinity)
            .background(Color.logInBackground)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .topBarLeading) {
                    Button{
                        withAnimation(.snappy) {
                            show.toggle()
                        }
                    }label: {
                        BackButton()
                            .padding(.horizontal)
                    }
                }
            }
        }
    }
}

#Preview {
    LogInView(show: .constant(false))
}
