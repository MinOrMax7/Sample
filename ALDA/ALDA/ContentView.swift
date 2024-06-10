//
//  ContentView.swift
//  ALDA
//
//  Created by Mingxin Xie on 5/25/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State var tabSelection: Tabs = .tab1
    @State private var name = "John Doe"
        
    var body: some View {
        VStack {
            Text("Hello, \(name)!")
            ChildView(name: $name)
        }
    }

//        NavigationView {
//            TabView(selection: $tabSelection){
//                homeView()
//                    .tabItem {
//                        if(self.tabSelection == .tab1) {
//                            Image(.homeS)
//                        } else {
//                            Image(.home)
//                        }
//                        Text("Home")
//                    }
//                    .tag(Tabs.tab1)
//                
//                discoverView()
//                    .tabItem {
//                        if(self.tabSelection == .tab2) {
//                            Image(.discoverS)
//                        } else {
//                            Image(.discover)
//                        }
//                        Text("discover")
//                    }
//                    .tag(Tabs.tab2)
//            }
//        }
}

struct ChildView: View {
    @Binding var name: String

    var body: some View {
        TextField("Enter your name", text: $name)
    }
}
enum Tabs{
    case tab1, tab2, tab3
}
enum selection: String {
    case home = "home"
    case discover = "discover"
    case profile = "profile"
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
