import SwiftUI

struct UserInfoListView: View {
    @ObservedObject var vm: ProfileViewModel
    @Binding var selectedItem: UserInfoItem
    @Binding var showSheet: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            ForEach(vm.userEditProfileList) { item in
                VStack(alignment: .leading, spacing: 30) {
                    HStack {
                        UserInformationField(icon: item.icon,
                                             text: item.text,
                                             info: item.info)
                        
                        Spacer()
                        
                        if !item.info.isEmpty {
                            Image("next")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15, height: 15)
                        }
                    }
                    .onTapGesture {
                        selectedItem = item.itemType
                    }
                    .onChange(of: selectedItem) { _ , newValue in
                        if newValue != .none {
                            showSheet = true
                        }
                    }
                    
                    Divider()
                }
            }
        }
        .padding()
        .padding(.top)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}


#Preview {
    UserInfoListView(
        vm: ProfileViewModel(
            authManager: AuthenticationManager(),
            userManager: UserManager()),
        selectedItem: .constant(.none),
        showSheet: .constant(false))
}
