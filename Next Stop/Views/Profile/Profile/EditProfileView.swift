import SwiftUI
import PhotosUI

enum UserInfoItem {
    case language, obsessed, biography, location, work, pets, none
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
                ProfilePhotoView(userImage: $userImage,
                                 showPicker: $showPicker,
                                 photoURL: vm.user?.photoURL)
                
                UserInfoListView(vm: vm,
                                 selectedItem: $selectedItem,
                                 showSheet: $showSheet)
            }
        }
        .sheet(isPresented: $showSheet) {
            sheetContent(for: selectedItem)
        }
        .photosPicker(isPresented: $showPicker,
                      selection: $avatarItem, matching: .images)
        .onChange(of: avatarItem) {
            loadImage()
        }
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    show.toggle()
                } label: {
                    Image(systemName: "xmark")
                        .imageScale(.medium)
                }
                .foregroundStyle(.black)
            }
        }
    }
}

#Preview {
    EditProfileView(vm: ProfileViewModel(
        authManager: AuthenticationManager(),
        userManager: UserManager()),
        show: .constant(false))
}

private extension EditProfileView {
    @ViewBuilder
    func sheetContent(for item: UserInfoItem) -> some View {
        switch item {
        case .language:
            EditLanguageView(vm: vm)
        case .obsessed:
            EditObsessedView(vm: vm)
        case .biography:
            EditBiographyView(vm: vm)
        case .location:
            EditLocationView(vm: vm)
        case .work:
            EditUserWorkView(vm: vm)
        case .pets:
            Text("Pets")
        case .none:
            EmptyView()
        }
    }
    
    func loadImage() {
        Task {
            if let image = try? await avatarItem?.loadTransferable(type: Image.self) {
                userImage = image
            } else {
                print("Failed to load image")
            }
        }
    }
}
