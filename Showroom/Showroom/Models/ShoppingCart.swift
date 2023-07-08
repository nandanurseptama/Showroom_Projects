//
//  ShoppingCart.swift
//  Showroom
//
//  Created by miracle on 07/07/23.
//

import Foundation
struct CartItem : Codable{
    var product : ProductDetailData;
    var amountItem : Int;
}
enum ShoppingCartError : Error{
    case ExceedMaximumAmountPerItem;
    case ExceedMaximumItemInCart;
    case ItemFoundInCart;
}
class ShoppingCart : ObservableObject{
    
    @Published var items : [CartItem] = [];
    
    private var maxItem = 50;
    
    
    let localStorage : UserDefaults = UserDefaults.standard;
    
    func load(){
        do{
            let jsonDecoder = JSONDecoder()
            let localItem = localStorage.data(forKey: getCartDatabaseIndex())
            if localItem == nil{
                return;
            }
            let decodeResult = try jsonDecoder.decode([CartItem].self, from: localItem!);
            DispatchQueue.main.async {
                self.items = decodeResult;
            }
            print("load cart end");
            return;
        }catch{
            print("failed to store cart \(error)")
            return;
        }
    }
    func addToCart(product : ProductDetailData, amount : Int = 1)throws -> Void{
        if let _ = self.items.firstIndex(where: {
            $0.product.id == product.id
        }){
            throw ShoppingCartError.ItemFoundInCart;
        } else{
            self.items.append(CartItem(product : product, amountItem : amount));
            storeToLocal();
            return;
        }
    }
    
    func storeToLocal(){
        do{
            let jsonEncoder = JSONEncoder()
            print("item to store \(String(describing: self.items))")
            let encodeResult = try jsonEncoder.encode(self.items)
            print("encode card items to store \(String(describing: encodeResult))")
            
            localStorage.set(encodeResult, forKey: getCartDatabaseIndex());
            print("store end");
            return;
        }catch{
            print("failed to store cart \(error)")
            return;
        }
    }
    
    func addAmountToItem(productId : Int) throws->Void{
        if let index = self.items.firstIndex(where:{
            $0.product.id == productId
        }){
            let amountItem = self.items[index].amountItem;
            
            if amountItem + 1 > 5 {
                throw ShoppingCartError.ExceedMaximumAmountPerItem;
            }
            
            self.items[index].amountItem = amountItem + 1;
            storeToLocal();
            
            return;
        }
        return;
    }
    
    func substractAmountToItem(productId : Int){
        if let index = self.items.firstIndex(where:{
            $0.product.id == productId
        }){
            let amountItem = self.items[index].amountItem;
            
            if amountItem - 1 <= 0 {
                self.items.remove(at: index);
                storeToLocal();
                return;
            }
            
            self.items[index].amountItem = amountItem - 1;
            storeToLocal();
            defer{
                print("substractAmountToItem stopped")
            }
            return;
        }
        return;
    }
    func deleteItem(productId : Int){
        if let index = self.items.firstIndex(where:{
            $0.product.id == productId
        }){
            self.items.remove(at: index);
            self.storeToLocal();
            return;
        }
        return;
    }
    func clearCart(){
        self.items  = [];
        self.localStorage.set(nil, forKey: getCartDatabaseIndex());
        return;
    }
    
    func getCartDatabaseIndex()->String{
        let cred = getCurrentUser();
        guard let cred = cred else{
            return "cart";
        }
        return "\(cred.email)#cart";
    }
    
    func getCurrentUser()->Credentials?{
        let local = self.localStorage.data(forKey: "authedUser");
        guard let lc = local else{
            return nil;
        }
        let jsonDecoder = JSONDecoder();
        do{
            let result = try jsonDecoder.decode(Credentials.self, from: lc);
            return result;
        }catch{
            return nil;
        }
        
    }
    
    
    static var example : CartItem{
        let productDetail = ProductDetailData(id: 1, name: "CBR", price: 10000000, priceString: "10,000,000", priceCurrency: "Rp", thumbnail: "https://raw.githubusercontent.com/nandanurseptama/Showroom_Projects/master/assets/images/honda_cb150r/honda_cb150r_1.png", thumbnails: [], description: "Lorem ipsum")
        let amountItem = 1;
        return CartItem(product: productDetail, amountItem: amountItem);
    }
}
