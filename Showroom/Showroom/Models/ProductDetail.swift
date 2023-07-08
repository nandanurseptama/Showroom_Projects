//
//  ProductDetail.swift
//  Showroom
//
//  Created by miracle on 06/07/23.
//

import Foundation

enum FetchProductDetailState{
    case Loading;
    case NotFound;
    case Loaded;
    case Error;
}
class ProductDetail : ObservableObject{
    private let apiEndpoint : ApiEndpoint = ApiEndpoint()
    private var productId : Int;
    
    @Published var productDetailErrorMessage : String? = nil;
    @Published var fetchProductDetailState : FetchProductDetailState = FetchProductDetailState.Loading;
    
    @Published var productDetailData : ProductDetailData? = nil
    
    init(){
        self.productId = 0;
    }
    
    func setProductId(productId : Int){
        self.productId = productId;
        return;
    }
    
    
    
    func load(){
        print("Load Product \(productId)")
        guard let url = URL(string:apiEndpoint.productDetailEndpoint(id: productId)) else{
            return;
        }
        let task = URLSession.shared.dataTask(with: url, completionHandler: {
            data, response, error in
            DispatchQueue.main.sync {
                let decoder = JSONDecoder()
                print("Response Type \(type(of:response))");
                if let data = data {
                    do{
                        let decodeTask = try decoder.decode(ProductDetailData.self, from: data)
                        self.productDetailData = decodeTask
                        self.fetchProductDetailState = FetchProductDetailState.Loaded
                        self.productDetailErrorMessage = nil;
            
                        return;
                    } catch{
                        self.fetchProductDetailState = FetchProductDetailState.Error
                        self.productDetailErrorMessage = "Internal Error";
                        return;
                    }
                } else{
                    self.productDetailData = nil
                    self.fetchProductDetailState = FetchProductDetailState.NotFound
                    self.productDetailErrorMessage = nil;
                    return;
                }
            }
            
        })
        task.resume();
        return;
    }
    
    
}
