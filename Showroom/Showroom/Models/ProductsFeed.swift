//
//  Products.swift
//  Showroom
//
//  Created by miracle on 06/07/23.
//

import Foundation

enum FetchProductsState{
    case Loading
    case Error
    case Empty
    case Loaded
}
class ProductsFeed : ObservableObject{
    private var apiEndpoint : ApiEndpoint  = ApiEndpoint.shared;
    
    @Published var fetchProductsState : FetchProductsState = FetchProductsState.Loading;
    @Published var fetchProductsErrorMessage : String? = nil;
    @Published var products : [ProductData] = [];
    
    // Tasks
    func load(){
        self.fetchProductsState = FetchProductsState.Loading;
        self.fetchProductsErrorMessage = nil;
        
        guard let url =  URL(string:apiEndpoint.getAllProductsEndpoint) else{
            return
        }
        
        let task = URLSession.shared.dataTask(with: url){
            data, response, error in
            
            let decoder = JSONDecoder()
            
            if let data = data{
                do{
                    let decodeTasks = try decoder.decode([ProductData].self, from: data)
                    if decodeTasks.isEmpty{
                        DispatchQueue.main.async {
                            self.fetchProductsState = FetchProductsState.Empty;
                            self.fetchProductsErrorMessage = nil
                        }
                        return;
                    } else{
                        DispatchQueue.main.async {
                            self.fetchProductsState = FetchProductsState.Loaded;
                            self.fetchProductsErrorMessage = nil;
                            self.products = decodeTasks;
                        }
                        return;
                    }
                } catch{
                    DispatchQueue.main.async {
                        self.fetchProductsState = FetchProductsState.Error
                        self.fetchProductsErrorMessage = "Internal Error";
                    }
                    return;
                }
            } else{
                DispatchQueue.main.async {
                    self.fetchProductsState = FetchProductsState.Error;
                    self.fetchProductsErrorMessage = "Internal error"
                }
                return;
            }
        }
        task.resume()
        return;
    }
}
