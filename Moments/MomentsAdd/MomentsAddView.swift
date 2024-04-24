//
//  MomentsAddView.swift
//  Amigo Pet IOS App
//
//  Created by Jack Liu on 12/26/21.
//

import SwiftUI
import Popovers
import FirebaseStorage
import AVKit
import Popovers

extension Notification.Name {
    static let submitNewPost = Notification.Name("SubmitNewPost")
}

struct MomentsAddView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var user : UserViewModel
    @EnvironmentObject var userExploresViewModel : UserExploresViewModel
    
    @Binding var content : String
    @Binding var pickerContentList: [AnyPickerContent]
    @Binding var muted : Bool
    
    var itemsCount : Int {
        return pickerContentList.count
    }
    
    @State private var isShowPhotoLibrary = false
    @State private var pickerContent : AnyPickerContent? = nil
    @State private var isLoading = false
    
    @State private var showingOptions = false
    @State private var showAlert = false
    
    @State private var durationTooLong = false
    
    @StateObject var videoViewModel = VideoViewModel()
    @State var newDocID : String? = nil
    
    @State var uploadingStarted = false
    @State var uploadingError = false
    @State var uploadTasks : [StorageUploadTask] = []
    @State var progress : [UploadProgress] = []
    @StateObject var multiConfirm = MultiConfirm()
    @State var expanding = false;
    var thumbnail: UIImage?
    
    let imageWidth = UIScreen.main.bounds.size.width * 57 / 390
    
    var items: [GridItem] {
        Array(repeating: .init(.fixed(imageWidth)), count: 3)
    }
    
    var btnBack : some View {
        Button(action: {
            if(content == "" && pickerContentList.count == 0){
                self.mode.wrappedValue.dismiss()
            } else {
                showingOptions = true
            }
        }) {
            HStack {
                Image(systemName: "chevron.backward")
                    .foregroundColor(.black)
                Text("cancel")
                    .foregroundColor(.black)
            }
        }
    }
    
    var body: some View {
        ScrollView{
            VStack{
                TextEditor(text: $content)
                    .frame(height: 200)
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .padding()
                    .keyboardType(.default)
                
                LazyVGrid(columns: items, spacing: 10) {
                    MomentsAddAnyView(pickerContentList: $pickerContentList)
                    
                    if pickerContentList.count != 9{
                        Button(action: {
                            self.isShowPhotoLibrary = true
                            
                        }) {
                            HStack {
                                Image(systemName: "plus")
                                    .font(.system(size: 20))
                            }
                            .frame(width: imageWidth, height: imageWidth)
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(5)
                            .padding(.horizontal)
                        }
                        .disabled(pickerContentList.count == 9)
                    }
                }
                .padding(.horizontal)
                Spacer()
                
            }
        }
        .onAppear(){
            self.muted = true
        }
        .onDisappear(){
            self.muted = false
        }
        .onChange(of: pickerContent) { newPickerContent in
            if let pickerContent = pickerContent {
                if let duration = pickerContent.duration, duration > 120 {
                    self.durationTooLong = true
                    self.pickerContent = nil
                    return
                }
                self.pickerContentList.append(pickerContent)
                self.pickerContent = nil
            }
        }
        .sheet(isPresented: $isShowPhotoLibrary) {
            AnyPicker(content: $pickerContent, loading: $isLoading)
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button(action: {
                    guard (content != "" && !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) || itemsCount > 0  else {
                        self.showAlert = true
                        return
                    }
                    self.newDocID = UUID().uuidString
                    uploadingStarted = true
                    progress.removeAll()
                    multiConfirm.setTotalConfirm(totalConfirm: itemsCount)
                    for i in 0..<pickerContentList.count{
                        progress.append(UploadProgress(completed: 0, total: 0))
                        let content = pickerContentList[i]
                        if(content.isImage){
                            let task = ImageViewModel.uploadImageToStorage(path: "explores/\(newDocID!)", localImage: content.image, imageName: "\(i+1)")
                            handleUploadTask(task: task, index: i)
                        } else {
                            videoViewModel.uploadVideoToStorage(videoURL: content.URL!, path: "explores/\(newDocID!)", name: "\(i+1)") { task in
                                guard let task = task else {
                                    handleUploadError(newDocID: newDocID!, task: task)
                                    return
                                }
                                handleUploadTask(task: task, index: i)
                            }
                            
                            // upload the thumbnail, name it ./.././10 since the maximum number of post content is 9.
                            _ = ImageViewModel.uploadImageToStorage(path: "explores/\(newDocID!)", localImage: content.image, imageName: "\(10)")
                        }
                    }
                }, label: {
                    Text("Post")
                        .foregroundColor(Color.black)
                        .font(.system(size: 16, weight: .bold, design: .default))
                })
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItemGroup(placement: .automatic) {
                Spacer()
                    .foregroundColor(Color.black)
            }
        }
        .navigationBarItems(leading: btnBack)
        // Empty Content
        .popover(
            present: $showAlert,
            attributes: {
                $0.blocksBackgroundTouches = true
                $0.rubberBandingMode = .none
                $0.position = .relative(
                    popoverAnchors: [
                        .center,
                    ]
                )
                $0.presentation.animation = .easeOut(duration: 0.15)
                $0.dismissal.mode = .none
                $0.onTapOutside = {
                    withAnimation(.easeIn(duration: 0.15)) {
                        expanding = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.easeOut(duration: 0.4)) {
                            expanding = false
                        }
                    }
                }
            }
        ) {
            AlertPopupView(present: $showAlert, expanding: $expanding, text: "Content or image cannot be empty!")
        } background: {
            Color.black.opacity(0.1)
        }
        // PickerLoading
        .popover(present: $isLoading, attributes: {
            $0.dismissal.animation = .none
            $0.position = .relative(popoverAnchors: [.center])
            $0.dismissal.mode = .none
            $0.rubberBandingMode = .none
            $0.blocksBackgroundTouches = true
        }){
            VStack{
                Spacer()
                HStack{
                    ProgressView()
                }
                Spacer()
            }
        } background: {
            Color.gray.opacity(0.5)
        }
        // Duration too long
        .popover(
            present: $durationTooLong,
            attributes: {
                $0.blocksBackgroundTouches = true
                $0.rubberBandingMode = .none
                $0.position = .relative(
                    popoverAnchors: [
                        .center,
                    ]
                )
                $0.presentation.animation = .easeOut(duration: 0.15)
                $0.dismissal.mode = .none
                $0.onTapOutside = {
                    withAnimation(.easeIn(duration: 0.15)) {
                        expanding = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.easeOut(duration: 0.4)) {
                            expanding = false
                        }
                    }
                }
            }
        ) {
            AlertPopupView(present: $durationTooLong, expanding: $expanding, text: "During of video has to be less than two minutes long")
        } background: {
            Color.black.opacity(0.1)
        }
        // Exiting
        .popover(
            present: $showingOptions,
            attributes: {
                $0.blocksBackgroundTouches = true
                $0.rubberBandingMode = .none
                $0.position = .relative(
                    popoverAnchors: [
                        .center,
                    ]
                )
                $0.presentation.animation = .easeOut(duration: 0.15)
                $0.dismissal.mode = .none
            }
        ) {
            VStack(spacing: 0) {
                VStack(spacing: 6) {
                    Text("Do you want to save your edit?")
                        .multilineTextAlignment(.center)
                }
                .padding()

                Divider()
                
                Button("Yes") {
                    self.mode.wrappedValue.dismiss()
                    showingOptions = false
                }
                .buttonStyle(Templates.AlertButtonStyle())
                
                Divider()

                Button {
                    content = ""
                    pickerContentList = []
                    self.mode.wrappedValue.dismiss()
                    showingOptions = false
                } label: {
                    Text("No")
                }
                .buttonStyle(Templates.AlertButtonStyle())
            }
            .background(Color.white)
            .cornerRadius(16)
            .popoverShadow(shadow: .system)
            .frame(width: 260)
        } background: {
            Color.black.opacity(0.1)
        }
        
        // Error
        .popover(
            present: $uploadingError,
            attributes: {
                $0.blocksBackgroundTouches = true
                $0.rubberBandingMode = .none
                $0.position = .relative(
                    popoverAnchors: [
                        .center,
                    ]
                )
                $0.presentation.animation = .easeOut(duration: 0.15)
                $0.dismissal.mode = .none
            }
        ) {
            VStack(spacing: 0) {
                VStack(spacing: 6) {
                    Text("Error when Uploading. Please try again later")
                        .multilineTextAlignment(.center)
                }
                .padding()

                Divider()

                Button {
                    uploadingStarted = false
                    uploadingError = false
                    removeAllObservers()
                    self.mode.wrappedValue.dismiss()
                } label: {
                    Text("Ok")
                }
                .buttonStyle(Templates.AlertButtonStyle())
            }
            .background(Color.white)
            .cornerRadius(16)
            .popoverShadow(shadow: .system)
            .frame(width: 260)
        } background: {
            Color.black.opacity(0.1)
        }
        
        // Uploading
        .popover(present: .constant(!uploadingError && uploadingStarted && !multiConfirm.confirmed), attributes: {
            $0.dismissal.animation = .none
            $0.position = .relative(popoverAnchors: [.center])
            $0.dismissal.mode = .none
            $0.rubberBandingMode = .none
            $0.blocksBackgroundTouches = true
        }){
            VStack{
                Spacer()
                Text("Uploading...")
                HStack{
                    ProgressView()
                    ProgressPercent(progress: $progress)
                }
                Spacer()
            }
            .frame(width: 200, height: 80)
            .background(Color.white)
            .cornerRadius(20)
        } background: {
            Color.gray.opacity(0.5)
        }
        .onChange(of: multiConfirm.confirmed, perform: { newValue in
            if newValue, let newDocID = self.newDocID {
                let imageType : [Bool] = pickerContentList.map { $0.isImage }
                MomentPostViewModel.addPost(postID: newDocID, user: user.user.id, content: content, imageCount: itemsCount, imageType: imageType)
                userExploresViewModel.addExplores(exploreID: newDocID)
                print("uploading completed")
                NotificationCenter.default.post(name: Notification.Name.submitNewPost, object: nil)
            }
        })
        .popover(present: $multiConfirm.confirmed, attributes: { // Upload Finished
            $0.dismissal.animation = .none
            $0.position = .relative(popoverAnchors: [.center])
            $0.dismissal.mode = .none
            $0.rubberBandingMode = .none
            $0.blocksBackgroundTouches = true
        }){
            VStack{
                Spacer()
                Text("Done!")
                    .foregroundColor(Color.blue)
                Spacer()
            }
            .frame(width: 200, height: 80)
            .background(Color.white)
            .cornerRadius(20)
            .onTapGesture {
                content = ""
                pickerContentList = []
                uploadingStarted = false
                multiConfirm.reset()
                removeAllObservers()
                self.mode.wrappedValue.dismiss()
            }
        } background: {
            Color.gray.opacity(0.5)
        }
    }
    
    func handleUploadError(newDocID: String, task: StorageUploadTask?){
        if let task = task {
            task.removeAllObservers()
            task.cancel()
        }
//        userExploresViewModel.removeExplores(exploreID: newDocID)
        self.uploadingError = true
    }
    
    func handleUploadTask(task: StorageUploadTask, index: Int) {
        task.observe(.progress) { snapshot in
            progress[index].total = Double(snapshot.progress!.totalUnitCount)
            progress[index].completed = Double(snapshot.progress!.completedUnitCount)
        }
        task.observe(.success) { snapshot in
            multiConfirm.addConfirm()
        }
        task.observe(.failure) { snapshot in
            handleUploadError(newDocID: newDocID!, task: task)
        }
        self.uploadTasks.append(task)
    }
    
    func removeAllObservers(){
        for task in self.uploadTasks {
            task.removeAllObservers()
        }
    }
}

struct ProgressPercent: View {
    @Binding var progress : [UploadProgress]
    var display : Double {
        let completed = progress.map({$0.completed}).reduce(0, +)
        let total = progress.map({$0.total}).reduce(0, +)
        if(total == 0) {
            return 0.0
        }
        return 100 * completed / total
    }
    var body: some View {
        Text("   \(display, specifier: "%.2f")%")
    }
}
