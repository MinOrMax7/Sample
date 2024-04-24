//
//  SubscriptionView.swift
//  Amig Pet IOS App
//
//  Created by Jack Liu on 5/8/22.
//

import StoreKit
import SwiftUI

struct SubscriptionView: View {
    @EnvironmentObject var subscriptionViewModel : SubscriptionViewModel
    
    var body: some View {
        VStack{
            VStack(alignment: .leading, spacing: 30){
                Text("Unlock over 100 tricks and courses designed by experts\n\n\nReceive personalized feedback from professinal dog trainers in less than 24h\n\n\nAccess unlimited daily training and strive for success at your own pace\n\n\nInvite family members so you can train your pets together")
                    .font(.system(size: 14, weight: .semibold, design: .default))
                    .multilineTextAlignment(.leading)
                    .frame(width: UIScreen.main.bounds.size.width*240/390)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(width: UIScreen.main.bounds.size.width*240/390)
            .padding(.bottom, 20)
            
            ForEach(0..<subscriptionViewModel.productsIDs.count, id: \.self) { index in
                let id = subscriptionViewModel.productsIDs[index]
                let product = subscriptionViewModel.products[id]
                if let product = product {
                    if(subscriptionViewModel.level < index+1){
                        VStack{
                            //                    Text(product.displayName)
                            //                    Text(product.description)
                            Button {
                                subscriptionViewModel.purchaseSubscription(id: id)
                            } label: {
                                VStack{
                                    Text("1 Month       \(product.localizedPrice!)")
                                    Text("First Month For Free!")
                                }
                                .foregroundColor(Color.black)
                                .frame(width: UIScreen.main.bounds.size.width*240/390)
                                .frame(height: 90)
                                .background(Color("colors/FEA3AC"))
                                .cornerRadius(8)
                            }
                        }
                    } else {
                        VStack{
                            Text("Already Purchased")
                        }
                        .foregroundColor(Color.black)
                        .frame(width: UIScreen.main.bounds.size.width*240/390)
                        .frame(height: 90)
                        .background(Color("colors/FEA3AC"))
                        .cornerRadius(8)
                    }
                }
            }
            HStack(spacing: 20){
                Link("Terms and Conditions", destination: URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!)
                    .font(.system(size: 10, weight: .light, design: .default))
                    .foregroundColor(Color("colors/666666"))
                Link("Privacy Policy", destination: URL(string: "https://docs.google.com/document/d/e/2PACX-1vS9Sl0Xf6kdAiBJBpS16Q15zZK0wIn9cjrH2b27U-J5wudYKSjOJFZmNz43R6V0zbMmObceg68Lx24T/pub")!)
                    .font(.system(size: 10, weight: .light, design: .default))
                    .foregroundColor(Color("colors/666666"))
            }

        }
        .padding(.horizontal)
    }
}
