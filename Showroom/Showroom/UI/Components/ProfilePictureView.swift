//
//  ProfilePictureView.swift
//  Showroom
//
//  Created by miracle on 08/07/23.
//

import SwiftUI
import Photos

struct ProfilePictureView: View {
    var size : Int = 120;
    
    @State var isFileImporterShown : Bool = false;
    
    @Binding var profilePictureData : Data?;
    

    var body: some View {
        ZStack(alignment : .topTrailing){
            builder
            editButton
        }.frame(
            width: CGFloat(size),
            height: CGFloat(size)
        ).sheet(isPresented : self.$isFileImporterShown){
            ImagePicker(imageData: $profilePictureData )
        }
    }
    var editButton : some View{
        VStack(alignment : .center){
            Image(systemName: "pencil").foregroundColor(.blue)
        }.frame(
            width : 44,
            height : 44,
            alignment: .center
        ).background{
            Color(.white)
        }.cornerRadius(22)
            .shadow( color: .gray, radius: 1, x: 0, y: 0)
            .onTapGesture {
               // self.isFileImporterShown = true;
                requestPersmission()
            }
        
    }
    
    @ViewBuilder var builder : some View{
        if self.profilePictureData == nil {
            emptyProfilePicture
        } else{
            profilePicture()
        }
    }
    
    func profilePicture() -> some View{
        guard let data = self.profilePictureData else{
            return AnyView(emptyProfilePicture)
        }
        guard let uiImage = UIImage(data: data) else{
            print("profilePicture() UiImage nil");
            return AnyView(emptyProfilePicture)
        }
        print("loaded")
        return AnyView(
            Image(uiImage: uiImage)
                .resizable()
                .frame(width: CGFloat(size), height: CGFloat(size))
                .clipShape(Circle())
        );
       
    }
    var emptyProfilePicture : some View{
        Image(systemName: "person.fill")
            .resizable()
            .foregroundColor(.blue)
            .frame(
                width:CGFloat(size),
                height:CGFloat(size)
            )
    }
    
    
    func requestPersmission(){
        self.isFileImporterShown = true;
        return;
    }
}

//struct ProfilePictureView_Previews: PreviewProvider {
//    static var profilePicturePath : Binding<Data?> =  Binding<Data?>(
//        get:{
//            nil
//        },
//        set:{
//            $0
//        }
//    );
//    static var previews: some View {
//        ProfilePictureView()
//    }
//}
