//
//  Checkout.swift
//  Showroom
//
//  Created by miracle on 07/07/23.
//

import Foundation

struct OrderItem : Identifiable, Codable{
    var id : Int;
    
    var items : [CartItem];
    
    var address : String;
    
    var orderTime : Int64;
}

enum CheckoutError:Error{
    case CannotCancelOrder;
    case OrderNotFound;
}
class Checkout : ObservableObject{
    // Declaration
    @Published var items : [OrderItem] = [];
    
    let localStorage = UserDefaults.standard;
    
    static var orderItemExample : OrderItem{
        OrderItem(id: 1, items: [ShoppingCart.example], address: "Japan", orderTime: Date.now.millisecondsSince1970)
    }
    
    // time limit to cancel order after checkout
    //
    // after 5 minutes order cannot be canceled
    var cancelOrderLimitInMilliseconds : Int64 {
        300000; // equal to 5 minutes
    }
    // Tasks
    func createOrder(cartItems : [CartItem], address : String)->Void{
        
        let orderHistoriesLength = items.count;
        
        let id = orderHistoriesLength + 1;
        
        let orderTime = Date.now.millisecondsSince1970;
        
        let newOrder = OrderItem(
            id : id,
            items: cartItems,
            address: address,
            orderTime: orderTime
        )
        
        self.items.append(newOrder);
        
        // update local storage
        updateLocalStorage();
        
        return;
    }
    
    func canCancel(orderTime : Int64)->Bool{
        let currentTime = Date.now.millisecondsSince1970;
        
        let difference = currentTime - orderTime;
        
        return difference < cancelOrderLimitInMilliseconds;
    }
    
    
    func cancelOrder(orderId : Int)throws->Void{
        let selectedOrder = findOrder(orderId: orderId);
        
        guard let selectedOrder = selectedOrder else{
            throw CheckoutError.OrderNotFound;
        }
        
        let cancelable = self.canCancel(orderTime: selectedOrder.orderTime)
        
        if !cancelable{
            throw CheckoutError.CannotCancelOrder;
        }
        
        self.items.removeAll(where: {
            $0.id == orderId
        })
        return;
    }
    
    func findOrder(orderId : Int) -> OrderItem?{
        let indexWhere = self.items.firstIndex(where: {
            $0.id == orderId;
        })
        guard let indexWhere = indexWhere else{
            return nil;
        }
        return self.items[indexWhere];
    }
    
    func updateLocalStorage(){
        do{
            let jsonEncoder = JSONEncoder()
            let encodeResult = try jsonEncoder.encode(self.items)
            localStorage.set(encodeResult, forKey: getOrdersDatabaseIndex());
            return;
        }catch{
            print("failed to store order \(error)")
            return;
        }
    }
    
    func load(){
        do{
            let jsonDecoder = JSONDecoder()
            let localItem = localStorage.data(forKey: getOrdersDatabaseIndex())
            if localItem == nil{
                return;
            }
            let decodeResult = try jsonDecoder.decode([OrderItem].self, from: localItem!);
            DispatchQueue.main.async {
                self.items = decodeResult;
            }
            print("load orders end");
            return;
        }catch{
            print("failed to load orders \(error)")
            return;
        }
    }
    func getOrdersDatabaseIndex()->String{
        let cred = getCurrentUser();
        guard let cred = cred else{
            return "orders";
        }
        return "\(cred.email)#orders";
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
    func getCancelDateString(orderTime :Int64)->String{
        let time = orderTime + cancelOrderLimitInMilliseconds;
        
        return Date.init(fromMillisecondsSince1970: time).formatToString();
    }
    func getChartData() -> [String : Int]{
        var datas : [String : Int ] = [:];
        
        self.items.forEach({
            item in
            let dateString = Date.init(fromMillisecondsSince1970: item.orderTime).formatToString(withFormat: "yyyy-MM-dd")
            guard let datasOnDay = datas[dateString] else {
                let totals = item.items.reduce(0, {
                    $0 + $1.amountItem
                })
                datas[dateString] = totals;
                return;
            }
            let totals = item.items.reduce(0, {
                $0 + $1.amountItem
            })
            datas[dateString] = datasOnDay + totals;
            return;
        })
        return datas
    }
}
