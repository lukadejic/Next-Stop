import SwiftUI

struct ProfileHeaderView: View {
    var body: some View {
        VStack(spacing: 0){
            HStack(spacing: 20){
                Circle()
                    .frame(width: 60, height: 60)
                
                VStack(alignment: .leading,spacing: 8) {
                    Text("Luka")
                        .font(.headline)
                        .fontWeight(.medium)
                    
                    Text("Show profile")
                        .font(.subheadline)
                        .foregroundStyle(.black.opacity(0.6))
                }
                
                Spacer()
                
                Button{
                    
                }label: {
                    Text(">")
                        .font(.title)
                        .fontWeight(.medium)
                }
            }
            .tint(.black)
            .padding()
            
            Rectangle()
                .stroke(lineWidth: 0.27)
                .frame(height: 1)
                .padding(.horizontal)
        }

    }
}

#Preview {
    ProfileHeaderView()
}
