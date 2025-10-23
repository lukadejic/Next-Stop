import SwiftUI

struct CancellationPolicyView: View {
    @Environment(\.dismiss) var dismiss
    let arrival: String
    
    var body: some View {
        NavigationView {
            ScrollView{
                VStack(alignment: .leading){
                    
                    Text("Make sure you're comfortable with this Host's policy.In rare cases, you may be eligible for a refund outside of this policy under NextStop's policy")
                        .font(.subheadline)
                        .padding(.bottom, 50)
                        .padding(.top,20)
                    
                    VStack(spacing: 30) {
                        
                        CancellationPolicySection(time: "Within",
                                                  date: "24 hours\nof booking",
                                                  refund: "Full refund",
                                                  refundDescription: "Get back 100% of what you paid")
                        
                        CancellationPolicySection(time: "Before",
                                                  date: arrival,
                                                  refund: "Partial refund",
                                                  refundDescription: "Get back 50% of what you paid")
                        
                        CancellationPolicySection(time: "After",
                                                  date: arrival,
                                                  refund: "No refund",
                                                  refundDescription: "This reservation is non-refundable")
                        
                        Text("Cleaning fees are refunded if you cancel before check-in.")
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity,alignment: .leading)
                .padding(.horizontal)
            }
            .navigationTitle("Cacellation policy")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .topBarLeading) {
                    Button{
                        dismiss()
                    }label: {
                        BackButton()
                    }
                }
            }
        }
    }
}
#Preview {
    CancellationPolicyView(arrival: "7 Mar\n16:00")
}

struct CancellationPolicySection : View {
    let time: String
    let date: String
    let refund: String
    let refundDescription: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(time)
                        .fontWeight(.semibold)
                    Text(date)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(alignment: .leading) {
                    Text(refund)
                        .fontWeight(.semibold)
                    Text(refundDescription)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Divider()
        }
        .padding(.trailing,20)
    }
}
