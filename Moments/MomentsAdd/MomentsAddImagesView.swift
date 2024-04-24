//
//  MomentsAddImagesView.swift
//  Amigo Pet IOS App
//
//  Created by Jack Liu on 12/26/21.
//

import SwiftUI
import AVKit
import CoreMedia
import AVFoundation

struct MomentsAddAnyView: View {
    @Binding var pickerContentList: [AnyPickerContent]
    let imageWidth = UIScreen.main.bounds.size.width * 57 / 390
    
    var formatter : DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }

    
    var body: some View {
        ReorderableForEach(items: pickerContentList) { pickerContent in
            ZStack(alignment: .topTrailing){
                Group{
                    if(pickerContent.isImage){
                        Image(uiImage: pickerContent.image)
                            .resizable()
                            .frame(width: imageWidth, height: imageWidth)
                            .scaledToFit()
                            .clipped()
                    } else {
                        if pickerContent.URL != nil {                            
                            ZStack(alignment: .bottomTrailing){
                                Image(uiImage: pickerContent.image)
                                    .resizable()
                                    .frame(width: imageWidth, height: imageWidth)
                                    .scaledToFit()
                                    .clipped()
                                                        
                                Text(formatter.string(from: TimeInterval(pickerContent.duration ?? 0))!)
                                    .padding(.trailing, 3)
                                    .foregroundColor(.white)
                                    .font(.system(size: 12, weight: .semibold, design: .default))
                            }
                        }
                    }
                }
                
                Button {
                    pickerContentList.remove(at: pickerContentList.firstIndex(of: pickerContent)!)
                } label: {
                    Image(systemName: "xmark.app.fill")
                        .foregroundColor(Color(.white))
                }
            }

        } moveAction: { from, to in
            pickerContentList.move(fromOffsets: from, toOffset: to)
        }
    }
}

struct MomentsAddImagesView: View {
    @Binding var localImages : [UIImage]
    let imageWidth = UIScreen.main.bounds.size.width * 57 / 390
    
    var body: some View {
        ReorderableForEach(items: localImages) { image in
            Image(uiImage: image)
                .resizable()
                .frame(width: imageWidth, height: imageWidth)
                .scaledToFit()
                .clipped()
                .cornerRadius(5)
        } moveAction: { from, to in
            localImages.move(fromOffsets: from, toOffset: to)
        }
    }
}
