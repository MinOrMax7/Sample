//
//  FollowButton.swift
//  Amigo
//
//  Created by 林之音 on 8/7/22.
//

import SwiftUI

struct followButton: View {
    @Binding var text : String
    @Binding var fColor: Color
    @Binding var rColor: Color
    
    var body: some View {
        VStack(alignment: .center, spacing:0){
            Text(text)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(fColor)
                .background(Color.white)
                .frame(height: UIScreen.main.bounds.size.width * 23 / 390, alignment: .center)
            
            Rectangle() // Filler Rectangle
                .fill(rColor)
                .frame(width: UIScreen.main.bounds.size.width * 80 / 390, height: UIScreen.main.bounds.size.width * 4 / 390)
        }
        .padding()
        
    }
}
