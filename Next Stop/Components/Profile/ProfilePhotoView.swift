import SwiftUI

struct ProfilePhotoView: View {
    @Binding var userImage: Image?
    @Binding var showPicker: Bool
    var photoURL: String?

    var body: some View {
        VStack {
            if let userImage = userImage {
                userImage
                    .resizable()
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
            } else if let photoURL = photoURL {
                AsyncImageView(url: photoURL,width: 200,height: 200)
            } else {
                Image("user")
                    .resizable()
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                    .foregroundStyle(.gray)
            }
        }
        .overlay(alignment: .bottom) {
            Button {
                showPicker.toggle()
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: "camera.fill")
                    Text("Edit")
                        .font(.title3)
                }
                .fontWeight(.semibold)
                .frame(width: 100, height: 40)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(radius: 10)
                .offset(y: 10)
                .foregroundStyle(.black)
            }
        }
    }
}

#Preview {
    ProfilePhotoView(userImage: .constant(.none),
                     showPicker: .constant(false))
}
