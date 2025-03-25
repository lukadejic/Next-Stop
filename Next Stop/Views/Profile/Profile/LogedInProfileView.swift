import SwiftUI

struct LogedInProfileView: View {
    var body: some View {
        NavigationStack{
            VStack(alignment:.leading) {
                ProfileHeaderView()
                
                
            }
            .navigationTitle("Profile")
        }
    }
}

#Preview {
    LogedInProfileView()
}
