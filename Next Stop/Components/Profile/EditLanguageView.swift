import SwiftUI

struct EditLanguageView: View {
    @ObservedObject var vm: ProfileViewModel
    
    let languages: [String] = ["English", "Spanish", "Serbian"]
    
    private func languageIsSelected(language: String) -> Bool {
        vm.user?.languages?.contains(language) == true
    }
    
    var body: some View {
        List{
            ForEach(languages, id: \.self) { language in
                HStack{
                    Text(language)
                    
                    Spacer()
                    
                    Button{
                        if languageIsSelected(language: language ){
                            vm.removeUserLanguage(language: language)
                        }else {
                            vm.addUserLanguage(language: language)
                        }
                    }label: {
                        Image(systemName: "heart")
                            .tint(languageIsSelected(language: language) ? .green : .red)
                    }
                }
            }
        }
    }
}

#Preview {
    EditLanguageView(vm: ProfileViewModel(
        authManager: AuthenticationManager(),
        userManager: UserManager()))
}
