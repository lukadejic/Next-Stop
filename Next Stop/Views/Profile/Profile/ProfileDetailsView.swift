import SwiftUI

struct ProfileDetailsView: View {
    @ObservedObject var vm: ProfileViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        
        ScrollView {
            VStack {
                
                header
                
                userInfo
                
                Spacer()
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
    ProfileDetailsView(vm: ProfileViewModel(authManager: AuthenticationManager()))
}

private extension ProfileDetailsView {
    var header: some View {
        VStack{
            Circle()
                .frame(width: 150, height: 150)
            
            Text("Luka")
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
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
        .padding(.top,25)
        
    }
}
