//
//  ChartOrder.swift
//  Showroom
//
//  Created by miracle on 08/07/23.
//

import SwiftUI
import Charts
struct ChartOrderView: View {
    @EnvironmentObject var checkout : Checkout;
    var body: some View {
        builder
    }
    @ViewBuilder var builder : some View{
        if checkout.getChartData().isEmpty{
            EmptyView()
        } else{
            chartBuilder
        }
    }
    var chartDatas : [String : Int] {
        checkout.getChartData();
    }
    
    @ViewBuilder var chartBuilder : some View{
        Chart{
            ForEach(Array(chartDatas.keys), id: \.self){
                key in
                BarMark(x: .value("Day", key), y : .value(
                    "Total Item",
                    chartDatas[key] ?? 0
                ))
            }
        }
    }
}

struct ChartOrder_Previews: PreviewProvider {
    static var previews: some View {
        ChartOrderView().environmentObject(Checkout())
    }
}
