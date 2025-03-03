import SwiftUI

struct DestinationSearchView: View {
    @Binding var show: Bool
    var body: some View {
        VStack{
            Button{
                show.toggle()
            }label: {
                Image(systemName: "xmark.circle")
                    .foregroundStyle(.black)
            }
            
            Text("Search")
        }
       
    }
}

#Preview {
    DestinationSearchView(show: .constant(false))
}
