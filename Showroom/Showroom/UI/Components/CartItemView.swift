//
//  CartItem.swift
//  Showroom
//
//  Created by miracle on 07/07/23.
//

import SwiftUI

struct CartItemView: View {
    
    var item : CartItem;
    
    
    @State var operationError : String? = nil;
    
    let actionAddItem : ((_ productId : Int) throws->Void)?;
    let actionSubstractItem : ((_ productId : Int) -> Void)?;
    let actionDeleteItem : ((_ productId : Int) -> Void)?
    
    
    init(item : CartItem,  actionAddItem : ((_ productId : Int) throws->Void)? = nil, actionSubstractItem : ((_ productId : Int) ->Void)? = nil, actionDeleteItem : ((_ productId : Int) -> Void)? = nil){
        self.actionAddItem = actionAddItem;
        self.actionSubstractItem = actionSubstractItem;
        self.actionDeleteItem = actionDeleteItem;
        self.item = item;
    }
    var isAlertShown : Binding<Bool>{
        return Binding<Bool>(get: {
            self.operationError != nil
        }, set: {
            v in
            if !v{
                self.operationError = nil;
            }
        })
    }
    
    var body: some View {
        VStack(alignment : .leading){
            HStack(alignment:.top){
                RemoteImageView(
                    url : URL(string:item.product.thumbnail)!,
                    placeholder:{
                        EmptyView()
                    },
                    image: {
                        $0
                        .scaledToFit()
                        .frame(
                            maxWidth : 80,
                            maxHeight : 80
                        )
                        .aspectRatio(1, contentMode: .fit)
                    }
                )
                
                VStack(alignment:.leading){
                    Text(item.product.name)
                        .font(.system(size:18))
                        .fontWeight(.bold)
                    Text("\(item.product.priceCurrency). \(item.product.price)")
                        .foregroundColor(.gray)
                    itemAmountView(product: item.product, amountItem: item.amountItem)
                    
                }.frame(
                    maxWidth : .infinity,
                    alignment: .topLeading
                )
                Spacer()
                buttonDelete
            }.frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .leading
            )
            .alert(isPresented:isAlertShown, content:{
                Alert(
                    title: Text("Error"),
                    message: Text(self.operationError!),
                    dismissButton: .default(Text("Ok"))
                )
                
            })
            Text("Total \(item.product.priceCurrency). \(item.amountItem * item.product.price)").fontWeight(.bold)
            Divider()
        }.frame(alignment : .topLeading)
    }
    @ViewBuilder var buttonDelete : some View{
        if actionDeleteItem == nil{
            EmptyView()
        } else{
            Button(
               action:{
                   onDelete();
               },
               label: {
                   Image(systemName: "trash.fill")
                       .foregroundColor(.black)
                       .frame(maxHeight:44)
                       .frame(maxWidth: 44)
                       .background{
                           RoundedRectangle(cornerRadius: 8)
                               .stroke(.gray, lineWidth:0.9)
                               .foregroundColor(.white.opacity(0))
                       }
               }
           )
           .frame(maxWidth:44, maxHeight: 44)
           .cornerRadius(8);
        }
    }
    func itemAmountView(product : ProductDetailData, amountItem : Int) -> some View{
        return HStack(alignment : .center){
            buttonMinus
            
            Text("\(amountItem)")
                .foregroundColor(.gray)
                .frame(height:44)
                .frame(width: 44)
                .background{
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.gray, lineWidth:0.9)
                        .foregroundColor(.white.opacity(0))
            }.padding(.trailing, 8)
            
            buttonAdd
        }
        .frame(maxHeight:52)
        .frame(alignment: .trailing)
    }
    @ViewBuilder var buttonMinus : some View{
        if self.actionSubstractItem == nil{
            EmptyView()
        } else{
            Button(
                action:{
                    onSubstract();
                },
                label: {
                    Image(systemName: "minus")
                        .foregroundColor(.black)
                        .frame(height:44)
                        .frame(width: 44)
                        .background{
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.gray, lineWidth:0.9)
                                .foregroundColor(.white.opacity(0))
                        }
                }
            )
            .frame(maxWidth:44, maxHeight: 44)
            .cornerRadius(8)
            .padding(.trailing, 8)
        }
    }
    
    @ViewBuilder var buttonAdd : some View {
        if self.actionAddItem == nil{
            EmptyView()
        } else{
            Button(
                action:{
                    onAdd();
                },
                label: {
                    Image(systemName: "plus")
                        .foregroundColor(.black)
                        .frame(height:44)
                        .frame(width: 44)
                        .background{
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.gray, lineWidth:0.9)
                                .foregroundColor(.white.opacity(0))
                        }
                }
            )
            .frame(height:44)
            .frame(width: 44)
            .cornerRadius(8)
        }
    }
    
    func onSubstract(){
        guard let callSubstract = self.actionSubstractItem else{
            return;
        }
        callSubstract(self.item.product.id);
        return;
    }
    
    func onAdd(){
        do{
            guard let callAdd  = self.actionAddItem else{
                return;
            }
            try callAdd(self.item.product.id);
            
        } catch ShoppingCartError.ExceedMaximumItemInCart{
            self.operationError = "Maxim item in cart is 50"
            
        } catch ShoppingCartError.ExceedMaximumAmountPerItem{
            self.operationError = "Maximum amount per item is 5"
            
        }
        catch{
            self.operationError = "Internal Error";
        }
    }
    func onDelete(){
        guard let callDelete =  actionDeleteItem else{
            return;
        }
        callDelete(self.item.product.id);
        return;
    }
}

struct CartItem_Previews: PreviewProvider {
    static var product : ProductDetailData{
        return ProductDetailData(id: 1, name: "CBR", price: 10000000, priceString: "10,000,000", priceCurrency: "Rp", thumbnail: "https://raw.githubusercontent.com/nandanurseptama/Showroom_Projects/master/assets/images/honda_cb150r/honda_cb150r_1.png", thumbnails: [], description: "Lorem ipsum")
    }
    static var previews: some View {
        CartItemView(item: CartItem(product: product, amountItem: 10)).environmentObject(ShoppingCart())
    }
}
