import SwiftUI
import MapKit

struct ListingDetailView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView{
            
                ListingImageCarouselView()
                    .frame(height: 300)
            
                VStack(alignment: .leading){
                    
                    Text("Miami Villa")
                        .font(.title)
                        .fontWeight(.semibold)
                    
                    VStack(alignment: .leading){
                        HStack{
                            Image(systemName: "star.fill")
                            
                            Text("4.86")
                            
                            Text("28 reviews")
                                .underline()
                                .fontWeight(.semibold)
                        }
                        Text("Miami, Florida")
                    }
                    .font(.caption)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                
                Divider()
                    .padding(.horizontal)
                
                HStack{
                    VStack(alignment: .leading){
                        Text("Large villa hosted by Sean Allen")
                            .font(.headline)
                            .frame(width: 250,alignment: .leading)
                        
                        HStack(spacing: 4){
                            Text("4 guests -")
                            Text("4 bedrooms -")
                            Text("4 beds -")
                            Text("3 baths")
                        }
                        .font(.caption)
                    }
                    .frame(width: 300,alignment: .leading)
                    
                    Spacer()
                    
                    Image("person-1")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 64, height: 64)
                        .clipShape(Ellipse())
                }
                .padding(.horizontal,10)
                
                Divider()
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 10){
                    ForEach(0..<2, id:\.self) { feature in
                        
                        HStack(spacing: 12){
                            Image(systemName: "medal")
                            
                            VStack(alignment: .leading){
                                Text("Superhost")
                                    .font(.footnote)
                                    .fontWeight(.semibold)
                                
                                Text("Superhosts are expirienced, highly rated hosts who are commited for providing great stars for the guests")
                                    .font(.caption)
                                    .foregroundStyle(.black.opacity(0.7))
                            }
                            
                            Spacer()
                        }
                    }
                }
                .padding(.horizontal,10)
                
                Divider()
                    .padding(.horizontal)
                
                VStack(alignment: .leading){
                    Text("Where you`ll sleep")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20){
                            ForEach(0..<5, id: \.self) {item in
                                VStack{
                                    Image(systemName: "bed.double")
                                    
                                    Text("Bedroom")
                                }
                                .frame(width: 132, height: 100)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(lineWidth: 1)
                                        .foregroundStyle(.gray)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                Divider()
                
                VStack(alignment: .leading, spacing: 16){
                    Text("What this place offers")
                        .font(.headline)
                    
                    ForEach(0..<5,id: \.self){ feature in
                        HStack(spacing: 10){
                            Image(systemName: "wifi")
                            
                            Text("Wifi")
                            
                            Spacer()
                        }
                    }
                
                }
                .padding(.horizontal)
            
            Divider()
                .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 16){
                Text("Where you`ll be")
                    .font(.headline)
                
                Map()
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal)
        }
        .overlay(alignment: .topLeading){
            Button{
                dismiss()
            }label: {
                Image(systemName: "chevron.left")
                    .foregroundStyle(.black)
                    .background{
                        Circle()
                            .foregroundStyle(.white)
                            .frame(width: 30,height: 30)
                    }
            }
            .padding(32)
        }
        .padding(.bottom, 64)
        .ignoresSafeArea()
        .padding(.bottom, 10)
        .overlay(alignment: .bottom){
            VStack{
                Divider()
                
                HStack{
                    VStack(alignment:.leading){
                        Text("$500")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        Text("Total before taxes")
                            .font(.footnote)
                        
                        Text("Oct 15 - 20")
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .underline()
                    }
                    .padding(.horizontal)
                    Spacer()
                    
                    Button{
                        
                    }label:{
                        Text("Reserve")
                            .foregroundStyle(.white)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .frame(width: 140, height: 40)
                            .background(.pink)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .padding(.horizontal)
                }
            }
            .background(.white)
            .padding(.horizontal)
            
        }
        

    }
}

#Preview {
    ListingDetailView()
}
