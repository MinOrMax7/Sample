//
//  ContentSharing.swift
//  Amig Pet IOS App
//
//  Created by Xiaoxue Wan on 5/21/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HomeShareView()
    }
}

struct HomeShareView: View{
    
    @State var items: [Any] = []
    @State var sheet = false
    @State var pic = ""
    
    var body: some View {
        let shareImage = Image(systemName: "heart.fill")
        VStack{
            Button(action: {
                //adding items to be shared
                
                items.removeAll()
                items.append(Text(pic))
                
                sheet.toggle()
                
            }, label: {
                shareImage.foregroundColor(.red)})
        }
        .sheet(isPresented: $sheet, content: {
            
            ShareSheet(items: items)
        })
    }
}

//share sheet

struct ShareSheet: UIViewControllerRepresentable{
    //the date you need to share
    var items : [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
    }
}
