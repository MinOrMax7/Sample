//
//  SubscriptionViewModel.swift
//  Amig Pet IOS App
//
//  Created by Jack Liu on 5/8/22.
//
import StoreKit
import Foundation
import SwiftyStoreKit

class SubscriptionViewModel: ObservableObject {
    let productsIDs = ["com.temporary.id", "com.temporary.id2"]
    @Published var level = 0 // 0 - nothing purchased; 1 - purchased basic subscription; 2 (to be implemented) - purchased advanced subscription
    @Published var products = [String: SKProduct]()
    
    init(){
        SwiftyStoreKit.retrieveProductsInfo(Set(productsIDs)) { result in
            for product in result.retrievedProducts {
                DispatchQueue.main.async {
                    self.products[product.productIdentifier] = product
                }
//                print("Product: \(product.localizedDescription), price: \(product.localizedPrice!)")
                
            }
            for invalidProductID in result.invalidProductIDs {
//                print("Invalid product identifier: \(invalidProductID)")
            }
        }
        
        self.updatePurchased()
    }
    
    func purchaseSubscription(id: String){
        SwiftyStoreKit.purchaseProduct(id, quantity: 1, atomically: true) { result in
            switch result {
            case .success(let purchase):
                self.updatePurchased()
                print("Purchase Success: \(purchase.productId)")
            case .error(let error):
                switch error.code {
                case .unknown: print("Unknown error. Please contact support")
                case .clientInvalid: print("Not allowed to make the payment")
                case .paymentCancelled: break
                case .paymentInvalid: print("The purchase identifier was invalid")
                case .paymentNotAllowed: print("The device is not allowed to make the payment")
                case .storeProductNotAvailable: print("The product is not available in the current storefront")
                case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                default: print((error as NSError).localizedDescription)
                }
            case .deferred(purchase: _):
                return
            }
        }
    }
    
    func updatePurchased(){
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: "05a719fbf5b447b2aa9f13480e3127be")
        SwiftyStoreKit.verifyReceipt(using: appleValidator, forceRefresh: false) { result in
            switch result {
            case .success(let receipt):
//                print(receipt)
                for i in 0..<self.productsIDs.count {
                    let id = self.productsIDs[i]
                    // Verify the purchase of a Subscription
                    let purchaseResult = SwiftyStoreKit.verifySubscription(
                        ofType: .autoRenewable, // or .nonRenewing (see below)
                        productId: id,
                        inReceipt: receipt)
                        
                    switch purchaseResult {
                    case .purchased(let expiryDate, let items):
                        DispatchQueue.main.async {
                            self.level = max(self.level, i+1)
                        }
                        print("\(id) is valid until \(expiryDate)\n\(items)\n")
                    case .expired(let expiryDate, let items):
                        print("\(id) is expired since \(expiryDate)\n\(items)\n")
                    case .notPurchased:
                        print("The user has never purchased \(id)")
                    }
                }
            case .error(let error):
                print("Receipt verification failed: \(error)")
            }
        }
    }
}


//class SubscriptionViewModel: ObservableObject {
//    let productsIDs = ["com.temporary.id", "com.temporary.id2"]
//    @Published var subscriptions : [Product] = []
//    @Published var purchasedIds: [String] = []
//
//    func fetchProducts() {
//        DispatchQueue.main.async{
//            Task{
//                do {
//                    self.subscriptions = try await Product.products(for: self.productsIDs)
//                    await self.isPurchased()
//                } catch {
//                    print(error)
//                }
//            }
//        }
//    }
//
//    func isPurchased() async {
//        for index in 0...subscriptions.count-1{
//            guard let state = await self.subscriptions[index].currentEntitlement else { return }
//            switch state{
//            case .unverified(_, _):
//                break
//            case .verified(let transaction):
//                DispatchQueue.main.async {
//                    self.purchasedIds.append(transaction.productID)
//                }
//            }
//        }
//    }
//
//    func purchase(product: Product) {
//        Task{
//            do {
//                let result = try await product.purchase()
//                switch result{
//                case .success(let verification):
//                    switch verification{
//                    case .unverified(_, _):
//                        break
//                    case .verified(let transaction): //add
//                        await self.isPurchased()
//                        print(transaction.productID)
//                    }
//
//                case .userCancelled:
//                    break
//                case .pending:
//                    break
//                @unknown default:
//                    break
//                }
//            } catch {
//                print(error)
//            }
//        }
//    }
//}
