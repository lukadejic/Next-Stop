import SwiftUI
import PhotosUI

enum UserInfoItem {
    case language
    case obsessed
    case biography
    case location
    case work
    case pets
    case none
}

struct EditProfileView: View {
    
    @ObservedObject var vm: ProfileViewModel
    
    @State private var avatarItem: PhotosPickerItem?
    @State private var userImage: Image?
    @State private var showPicker = false
    @State private var selectedItem: UserInfoItem = .none
    @State private var showSheet = false
    
    @Binding var show: Bool

    var body: some View {
        ScrollView(showsIndicators: true) {
            VStack {
                photo
                
                information
            }
        }
        .sheet(isPresented: $showSheet) {
            switch selectedItem {
            case .language:
                Text("Language")
            case .obsessed:
                Text("Obsessed")
            case .biography:
                EditBiographyView()
            case .location:
                Text("Location")
            case .work:
                Text("Work")
            case .pets:
                Text("Pets")
            case .none:
                EmptyView()
            }
        }
        .photosPicker(isPresented: $showPicker, selection: $avatarItem, matching: .images)
        .onChange(of: avatarItem) {
            Task {
                if let image = try? await avatarItem?.loadTransferable(type: Image.self) {
                    userImage = image
                } else {
                    print("Failed to load image")
                }
            }
        }
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            ToolbarItem(placement: .topBarLeading) {
                Button{
                    show.toggle()
                }label: {
                    Image(systemName: "xmark")
                        .imageScale(.medium)
                }
                .foregroundStyle(.black)
            }
        }
    }
}

#Preview {
    EditProfileView(vm: ProfileViewModel(authManager: AuthenticationManager()),
                    show: .constant(false))
}

private extension EditProfileView {
    var photo: some View {
        VStack{
            if let userImage = userImage {
                userImage
                    .resizable()
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
            } else if let photoURL = vm.user?.photoURL {
                AsyncImageView(url: photoURL)
            }else{
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                    .foregroundStyle(.gray)
            }
        }
        .overlay(alignment: .bottom) {
            Button{
                showPicker.toggle()
            }label: {
                VStack{
                    HStack(spacing: 10) {
                        Image(systemName: "camera.fill")
                            
                        Text("Edit")
                            .font(.title3)
                    }
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
    
    var information: some View {
        VStack(alignment: .leading,spacing: 30) {
            ForEach(vm.userEditProfileList) { item in
                VStack(alignment: .leading,spacing: 30) {
                    HStack {
                        UserInformationField(icon: item.icon,
                                             text: item.text,
                                             info: item.info)
                        
                        Spacer()
                        
                        if !item.info.isEmpty {
                            Image("next")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15, height: 15)
                        }
                    }
                    .onTapGesture {
                        selectedItem = item.itemType
                    }
                    .onChange(of: selectedItem) {oldValue, newValue in
                        if newValue != .none {
                            showSheet = true
                        }
                    }
                    
                    Divider()
                }
            }
        }
        .padding()
        .padding(.top)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
