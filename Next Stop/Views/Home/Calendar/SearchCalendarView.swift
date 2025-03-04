import SwiftUI

struct SearchCalendarView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var manager = CalendarManager (
        calendar: Calendar.current,
        minimumDate: Date(),
        maximumDate: Date().addingTimeInterval(60*60*24*365)
    )
    
    var body: some View {
        NavigationView {
            VStack(alignment:.leading){
                VStack(alignment: .leading,spacing: 10) {
                    Text("When's your trip?")
                        .font(.title)
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity, maxHeight: 80,alignment: .leading)
                .padding(.leading)
                
                Divider()
                    .padding(.horizontal)
                
                RangeCalendarView(manager: manager)
            }
            .overlay(alignment: .bottomTrailing){
                Button {
                    print("Tapped")
                } label: {
                    Text("Save")
                        .foregroundStyle(.white)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .frame(width: 140, height: 40)
                        .background(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            .padding(.trailing)
        }
    }
}


#Preview {
    SearchCalendarView()
}

private extension SearchCalendarView {
}
