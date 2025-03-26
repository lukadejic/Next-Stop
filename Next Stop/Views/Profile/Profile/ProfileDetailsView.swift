import SwiftUI

struct ProfileDetailsView: View {
    @ObservedObject var vm: ProfileViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            
        }
    }
}

#Preview {
    ProfileDetailsView(vm: ProfileViewModel(authManager: AuthenticationManager()))
}
