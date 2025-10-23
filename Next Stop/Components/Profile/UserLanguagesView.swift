import SwiftUI

struct UserLanguagesView: View {
    @ObservedObject var vm: ProfileViewModel
    
    @State private var search = ""
    
    var body: some View {
        ScrollView{
            VStack(spacing: 20) {
                ForEach(filteredLanguages, id: \.self) { language in
                    HStack {
                        Text(language)
                            .font(.title3)
                            .fontWeight(.medium)
                        
                        Spacer()
                        
                        Button {
                            if languageIsSelected(language: language) {
                                vm.userLanguages.removeAll { $0 == language }
                            }else {
                                vm.userLanguages.append(language)
                            }
                        }label: {
                            if languageIsSelected(language: language) {
                                Image(systemName: "checkmark.rectangle.fill")
                                    .imageScale(.large)
                                    .foregroundStyle(.black)
                            }else{
                                Image(systemName: "rectangle")
                                    .imageScale(.large)
                                    .foregroundStyle(.black)
                                
                            }
                        }
                    }
                    
                    Rectangle()
                        .stroke(lineWidth: 0.3)
                        .frame(height: 1)
                }
            }
            .searchable(text: $search, prompt: "Search Languages")
            .padding()
            .onAppear {
                vm.userLanguages = vm.user?.languages ?? []
            }
        }
    }
}

#Preview {
    UserLanguagesView(vm: ProfileViewModel(
        authManager: AuthenticationManager(),
        userManager: UserManager()))
}

private extension UserLanguagesView {
    
    var languages: [String] {
        NSLocale.isoLanguageCodes.compactMap { Locale.current.localizedString(forLanguageCode: $0) }
    }
    
    var filteredLanguages : [String] {
        return search.isEmpty ? languages : languages.filter{$0.localizedCaseInsensitiveContains(search)}
    }
    
    func languageIsSelected(language: String) -> Bool {
        vm.userLanguages.contains(language) == true
    }
}
