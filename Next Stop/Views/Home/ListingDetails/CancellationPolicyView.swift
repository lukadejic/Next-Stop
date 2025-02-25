import SwiftUI

struct CancellationPolicyView: View {
    var body: some View {
        ScrollView{
            VStack(alignment: .leading){
                Text("Cancellation policy")
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding(.bottom, 10)
                    .padding(.top,50)
                Text("Make sure you're comfortable with this Host's policy.In rare cases, you may be eligible for a refund outside of this policy under NextStop's policy")
                    .font(.subheadline)
                    .padding(.bottom, 50)
                
                VStack(spacing: 30) {
                    VStack(alignment: .leading) {
                        HStack(alignment: .top) {
                            VStack(alignment: .leading) {
                                Text("Within")
                                    .fontWeight(.semibold)
                                Text("24 hours \nof booking")
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            VStack(alignment: .leading) {
                                Text("Full refund")
                                    .fontWeight(.semibold)
                                Text("Get back 100% of what you paid.")
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        Divider()
                    }
                    .padding(.trailing,20)
                    
                    VStack(alignment: .leading) {
                        HStack(alignment: .top) {
                            VStack(alignment: .leading) {
                                Text("Before")
                                    .fontWeight(.semibold)
                                Text("7 Mar \n16:00")
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            VStack(alignment: .leading) {
                                Text("Partial refund")
                                    .fontWeight(.semibold)
                                
                                Text("Get back 50% of every night.")
                        
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        Divider()
                    }
                    .padding(.trailing,20)
                    
                    VStack(alignment: .leading) {
                        HStack(alignment: .top) {
                            VStack(alignment: .leading) {
                                Text("After")
                                    .fontWeight(.semibold)
                                Text("7 Mar \n16:00")
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            VStack(alignment: .leading) {
                                Text("No refund")
                                    .fontWeight(.semibold)
                                Text("This reservation is non-refundable")
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        Divider()
                    }
                    .padding(.trailing,20)
                    
                    Text("Cleaning fees are refunded if you cancel before check-in.")
                }

                
                
                Spacer()
            }
            .frame(maxWidth: .infinity,alignment: .leading)
            .padding(.horizontal)
        }
    }
}
#Preview {
    CancellationPolicyView()
}
