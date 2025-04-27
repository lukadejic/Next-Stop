import SwiftUI
import PhotosUI

enum UserInfoItem {
    case language, obsessed, biography, location, work, pets, interests, none
}

struct EditProfileView: View {
    
    @ObservedObject var vm: ProfileViewModel
    
    @State private var avatarItem: PhotosPickerItem?
    @State private var userImage: Image?
    @State private var showPicker = false
    @State private var selectedItem: UserInfoItem = .none
    @State private var showSheet = false
    
    @Binding var show: Bool
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ScrollView(showsIndicators: true) {
            VStack {
                ProfilePhotoView(userImage: $userImage,
                                 showPicker: $showPicker,
                                 photoURL: vm.user?.photoURL)
                
                UserInfoListView(vm: vm,
                                 selectedItem: $selectedItem,
                                 showSheet: $showSheet)
                
                interests
            }
        }
        .onAppear {
            vm.loadInterests()
        }
        .overlay(alignment: .bottom) {
            ButtonOverlay(text: "Done") {
                show.toggle()
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
            EditPetsView(vm: vm)
        case .interests:
            UserInterestsView(vm: vm)
        case .none:
            EmptyView()
        }
    }
    
    func loadImage() {
        Task {
            if let data = try? await avatarItem?.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                userImage = Image(uiImage: uiImage)
                vm.updateUserProfilePicture(picture: uiImage)
            } else {
                print("Failed to load image")
            }
        }
    }
    
    var interests: some View {
        VStack(alignment: .leading,spacing: 20) {
            Text("What you're into")
                .font(.title2)
                .fontWeight(.semibold)
            
            if !vm.interests.isEmpty {
                VStack(alignment: .leading) {
                    LazyVGrid(columns: columns) {
                        ForEach(vm.interests) { interest in
                            InterestItem(icon: interest.icon,
                                         name: interest.name,
                                         selectedInterests: $vm.interests)
                        }
                    }
                    .padding(.bottom,30)
                    
                    Text("Edit interests")
                        .fontWeight(.semibold)
                        .underline()
                }
                .onTapGesture {
                    selectedItem = .interests
                }
                .onChange(of: selectedItem) { _ , newValue in
                    if newValue != .none {
                        showSheet = true
                    }
                }
            }else{
                
                Text("Find common ground with other guests and hosts by adding interests to your profile.")
                    .foregroundStyle(.black.opacity(0.6))
                
                VStack (alignment: .leading,spacing: 30) {
                    HStack(spacing: 20) {
                        ForEach(0..<3){ item in
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [10]))
                                    .frame(width: 110, height: 50)
                                    .foregroundColor(.black.opacity(0.8))
                                
                                Image(systemName: "plus")
                                    .font(.system(size: 30, weight: .bold))
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    
                    Text("Add interests")
                        .fontWeight(.semibold)
                        .underline()
                }
                .onTapGesture {
                    selectedItem = .interests
                }
                .onChange(of: selectedItem) { _ , newValue in
                    if newValue != .none {
                        showSheet = true
                    }
                }
            }
        }
        .frame(maxWidth: .infinity,alignment: .leading)
        .padding()
        .padding(.bottom, 40)
    }
}
