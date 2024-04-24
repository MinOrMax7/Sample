//
//  PFPChangeView.swift
//  Amigo Pet IOS App
//
//  Created by Jack Liu on 1/2/22.
//

import SwiftUI

struct PFPChangeView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var user : UserViewModel
    
    let pfpWidth = UIScreen.main.bounds.size.width / 3 * 2

    @StateObject private var imageViewModel = ImageViewModel()
    
    @State private var isShowPhotoLibrary = false
    @State private var image = UIImage()
    
    var body: some View {
        VStack{
            Image(uiImage: imageViewModel.image)
                .resizable()
                .scaledToFill()
                .frame(width: pfpWidth, height: pfpWidth)
                .cornerRadius(5)
                .clipped()
                .padding(.trailing)
            
            Spacer()
            
            VStack{
                Button(action: {
                    self.isShowPhotoLibrary = true
                }, label: {
                    Text("Choose Photo")
                        .foregroundColor(Color.white)
                        .frame(width: 200, height: 50)
                        .background(Color("themePink"))
                        .cornerRadius(8)
                    
                })
                Button(action: {
                    ImageViewModel.uploadImageToStorage(path: "users/\(user.user.id)", localImage: imageViewModel.image, imageName: "pfp")
                    self.mode.wrappedValue.dismiss()
                }, label: {
                    Text("Confirm")
                        .foregroundColor(Color.white)
                        .frame(width: 200, height: 50)
                        .background(Color("themePink"))
                        .cornerRadius(8)
                    
                })
            }
            
            Spacer()
        }
        .onAppear{
            imageViewModel.downloadImageFromStorage(imagePullURL: "users/\(user.user.id)/pfp.jpeg")
        }
        .onChange(of: image) { newImage in
            if(newImage.size.width != 0){
                imageViewModel.image = image
                image = UIImage()
            }
        }
        .sheet(isPresented: $isShowPhotoLibrary) {
            ImagePicker(selectedImage: self.$image, sourceType: .photoLibrary)
        }
    }
}

struct PFPChangeView_Previews: PreviewProvider {
    static var previews: some View {
        PFPChangeView()
    }
}
