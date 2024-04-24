//
//  SwiftUIView.swift
//  Amigo
//
//  Created by Mingxin Xie on 9/21/22.
//

import SwiftUI

struct SwiftUIView: View {
    var body: some View {
        VStack (spacing: 10) {
            Text("Discover")
                .font(.system(size: 18))
                .foregroundColor(Color.black)
            
            Text("Your discover will appear here")
                .font(.system(size: 14))
                .foregroundColor(Color("colors/999999"))
        }
        .frame(height: UIScreen.main.bounds.size.height * 0.35)
        
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
