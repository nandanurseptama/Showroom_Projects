//
//  ProfileScreen.swift
//  Showroom
//
//  Created by miracle on 08/07/23.
//

import SwiftUI

struct ProfileScreen: View {
    @EnvironmentObject private var currentAccount : CurrentAccount;
    @EnvironmentObject private var profile : Profile;
    @State private var isLogoutAlertShown : Bool = false;
    @State private var isFileImporterShown : Bool = false;
    
    @State private var firstNameFieldController : String = ""
    @State private var lastNameFieldController : String = ""
    @State private var profilePicturePathController : Data? = nil;
    
    @State private var alertUpdateProfileMessage : String? = nil;
    
    
    var body: some View {
        VStack(alignment:.leading){
            ScrollView{
                VStack(alignment:.leading){
                    profilePictureView
                    profileFormView.padding(.top, 16)
                }
            }
            Spacer()
            saveProfileButton
            logoutButton
        }
        .padding(.all, 16)
        .confirmationDialog("Logout Confirmation", isPresented: $isLogoutAlertShown){
            Button(
                role : .destructive,
                action: {
                    print("Logout")
                },
                label: {
                    Text("Logout")
                        .foregroundColor(.red)
                }
            )
        } message: {
            Text("Are you sure want to logout")
                .foregroundColor(.gray)
        }
        .frame(alignment: .topLeading)
        .alert(
            isPresented: Binding<Bool>(
                get:{
                    self.alertUpdateProfileMessage != nil
                },
                set:{
                    val in
                    if !val{
                        self.alertUpdateProfileMessage = nil;
                    }
                }
            )
        ){
            Alert(
                title: Text("Update profile"),
                message: Text("\(self.alertUpdateProfileMessage ?? "")"),
                dismissButton: .default(Text("OK"))
            )
        }
        .task{
            loadProfile();
        }
        .onChange(of: self.profilePicturePathController, perform: {
            val in
            guard let val = val else{
                return;
            }
            onChangeProfilePictureListener(profilePictureData: val);
            return;
        })
    }
    var saveProfileButton : some View{
        Button{
            self.onSaveProfile();
        }label: {
            Text("Update profile")
                .frame(maxWidth: .infinity, maxHeight: 44)
                .foregroundColor(.white)
                .fontWeight(.bold)
        }.frame(maxWidth: .infinity, maxHeight: 44)
        .background{
            Color(.systemBlue)
        }
        .cornerRadius(8)
    }
    var logoutButton : some View{
        Button{
            self.isLogoutAlertShown = true;
        }label: {
            Text("Logout")
                .frame(maxWidth: .infinity, maxHeight: 44)
                .foregroundColor(.white)
                .fontWeight(.bold)
        }.frame(maxWidth: .infinity, maxHeight: 44)
        .background{
            Color(.systemRed)
        }
        .cornerRadius(8)
    }
    var profileFormView : some View{
        ProfileFormview(
            firstNameFieldController: $firstNameFieldController,
            lastNameFieldController: $lastNameFieldController
        )
    }
    var profilePictureView : some View{
        ProfilePictureView(
            profilePictureData: $profilePicturePathController
        );
    }
    func onChangeProfile(profileData : ProfileData?){
        guard let profileData = profileData else{
            return;
        }
        self.profilePicturePathController = profileData.profilePictureData;
        self.firstNameFieldController = profileData.firstName;
        self.lastNameFieldController = profileData.lastName;
        
    }
    func onChangeProfilePictureListener(profilePictureData : Data){
        do{
            try self.profile.updateProfilePicture(profilePictureData: profilePictureData);
        }catch{
            return;
        }
    }
    func loadProfile(){
        do{
            try profile.load();
            onChangeProfile(profileData: profile.current);
        } catch{
            return;
        }
    }
    func onSaveProfile(){
        do{
            try self.profile.updateProfile(
                firstName: firstNameFieldController,
                lastName: lastNameFieldController
            );
            self.alertUpdateProfileMessage = "Update profile success"
        }catch{
            self.alertUpdateProfileMessage = "Internal Error";
        }
    }
}

struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScreen()
    }
}
