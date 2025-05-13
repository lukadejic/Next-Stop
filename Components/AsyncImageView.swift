import SwiftUI

struct AsyncImageView: View {
    let url: String?
    
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        AsyncImage(url: URL(string: url ?? "")) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: width, height: height)
                    .clipShape(Circle())
            case .failure(_):
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                    .foregroundStyle(.gray)
            default:
                ProgressView()
            }
        }
    }
}

#Preview {
    AsyncImageView(url: "",width: 200, height: 200)
}
