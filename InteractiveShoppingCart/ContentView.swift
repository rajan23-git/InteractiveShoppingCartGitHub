//
//  ContentView.swift
//  InteractiveShoppingCart
//
//  Created by Pranav Rajan on 4/3/22.
//

import SwiftUI

struct Item:Identifiable{
    var id = UUID()
    var itemName:String
    var itemPrice:String
    var ItemImagePath:String
    
}
typealias quantityAndPrice = (foodQuantity: Int, foodPrice: Double)






struct ContentView: View {
    @State var orderHashMap:[String:quantityAndPrice] = [:]
    @State var itemNotInCart:Bool = false
    @State var combinedCartPrice:Double = 0
    @State var maxItemsDeletable = 0
    @State var notEnoughToDelete:Bool = false
    @State var alertBoolean:Bool = false;
    @State var isSelected:Bool=false;
    @State  var i :Int = 1
    @State  var selectedFood:String=""
    @State  var selectedQuantity:Int=0
    @State var itemPriceHashMap:[String:Double]=["Apple":2.99,"Banana Bread":5.99,"Cookies":4.45,"Lemonade":8.35,"Pumpkin Pie":3.99,"Steak":6.99,"Strawberry Jam":0.99]
    @State  var itemData:[Item]=[Item(itemName: "Apple", itemPrice: "2.99",ItemImagePath: "apple"),
                                 Item(itemName: "Banana Bread", itemPrice: "5.99",ItemImagePath: "bananaBread"),
                                 Item(itemName: "Cookies", itemPrice: "4.45",ItemImagePath: "cookies"),
                                 Item(itemName: "Lemonade", itemPrice: "8.35",ItemImagePath: "lemonade"),
                                 Item(itemName: "Pumpkin Pie", itemPrice: "3.99",ItemImagePath: "pumpkinPie"),
                                 Item(itemName: "Steak", itemPrice: "6.99",ItemImagePath: "steak"),
                                 Item(itemName: "Strawberry Jam", itemPrice: "0.99",ItemImagePath: "strawberryJam")
    ]
    
    var body: some View{
        
        NavigationView{
            
        ZStack{
            LinearGradient(
                gradient: Gradient(colors:   [.blue,.red]),
                startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
           
                
            VStack{
                    NavigationLink(destination: cartScreen()) {
                                   cartLink()
                    }
                    
                    HStack(spacing:10){
                        Text("Item Name").font(.system(size: 25, weight: .medium, design:.default))
                            .foregroundColor(.white)
                        Text("Item Price").font(.system(size: 25, weight: .medium, design:.default))
                            .foregroundColor(.white)
                        Text("Item Image").font(.system(size: 25, weight: .medium, design:.default))
                            .foregroundColor(.white)
                        
                        
                    }.padding(.bottom,10)
                    ScrollView{
                        ForEach(itemData, id: \.id) { food in
                            
                            listEntry(name:food.itemName, price:food.itemPrice, image:food.ItemImagePath)
                        }
                    }.frame(height:300)
                    
                    HStack(spacing:20){
                        Button{
                            //print(selectedFood)
                            selectedQuantity = selectedQuantity+1
                            //print(selectedQuantity)
                            
                        }label:{
                            Image(systemName
                                  : "plus.square.fill")
                                .renderingMode(.original)
                                .resizable()
                                .aspectRatio(contentMode
                                             :.fit)
                                .frame(width : 80, height : 80)
                                .foregroundColor(.green)
                        }
                        selectFoodDropdown(isSelected:$isSelected,selectedFood: $selectedFood, selectedQuantity: $selectedQuantity,itemData: $itemData)
                        
                        
                        
                        Button{
                            if(!(selectedQuantity==0)){
                                selectedQuantity = selectedQuantity-1
                            }
                            //print(selectedFood)
                            //print(selectedQuantity)
                            
                        }label:{
                            Image(systemName
                                  : "minus.square.fill")
                                .renderingMode(.original)
                                .resizable()
                                .aspectRatio(contentMode
                                             :.fit)
                                .frame(width : 80, height : 80)
                            
                        }
                    }
                    
                    HStack(spacing:50){
                        Text("Selected Item").font(.system(size: 25, weight: .medium, design:.default))
                            .foregroundColor(.black)
                        Text("Quantity").font(.system(size: 25, weight: .medium, design:.default))
                            .foregroundColor(.black)
                        
                    }
                    
                    
                    HStack(){
                        Text(selectedFood).font(.system(size: 25, weight: .medium, design:.default))
                            .foregroundColor(.white).padding()
                        
                        Text(isSelected ? "\(selectedQuantity)" : "").font(.system(size: 25, weight: .medium, design:.default))
                            .foregroundColor(.white).padding()
                        
                    }
                    HStack(){
                        addItemButton(selectedFood: $selectedFood, orderHashMap: $orderHashMap, selectedQuantity: $selectedQuantity, itemPriceHashMap: $itemPriceHashMap,combinedCartPrice: $combinedCartPrice)
                        
                        deleteItemButton(alertBoolean: $alertBoolean, selectedFood: $selectedFood, orderHashMap: $orderHashMap, selectedQuantity: $selectedQuantity, maxItemsDeletable: $maxItemsDeletable, notEnoughToDelete: $notEnoughToDelete, itemNotInCart: $itemNotInCart, itemPriceHashMap: $itemPriceHashMap,combinedCartPrice: $combinedCartPrice)
                    }
                   
                    Spacer()
                 
                }
            
        }
    }
        
        
        
        
    }
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct listEntry: View {
    var name:String
    var price:String
    var image:String
    var body: some View {
        HStack(spacing:40){
            Text(name).font(.system(size: 20, weight: .medium, design:.default))
                .foregroundColor(.white)
            
            Text((price)).font(.system(size: 20, weight: .medium, design:.default))
                .foregroundColor(.white)
            Image(image).resizable().scaledToFit().frame(width:60,height:60)
            
            
            
            
        }.frame(width: 400, height: 60).background(Color.red).padding(5)
    }
}

struct selectFoodDropdown: View {
    @Binding var isSelected:Bool
    @State var dropdowntoggle=false
    @Binding var selectedFood:String
    @Binding var selectedQuantity:Int
    @Binding var itemData:[Item]
    var body: some View {
        
        DisclosureGroup(isSelected ? selectedFood :"Select Food ", isExpanded: $dropdowntoggle){
            ScrollView{
                VStack{
                    ForEach(itemData, id: \.id) { food in
                        Text((food.itemName)).font(.system(size: 20, weight: .medium, design:.default))
                            .foregroundColor(.white).frame(width: 200, height:50).background(.green).padding(.bottom,5)
                            .onTapGesture {
                                isSelected = true
                                selectedFood = food.itemName
                                withAnimation{
                                    self.dropdowntoggle.toggle();
                                }
                            }
                        
                    }
                    
                    
                    
                }.background(.orange)
                
            }.frame( height:200 )
            
        }.padding(.all).foregroundColor(.white).background(.orange)
        
        
        
        
        
        
    }
    
    
    
}

struct addItemButton: View {
    @Binding var selectedFood:String
    @Binding var orderHashMap:[String:quantityAndPrice]
    @Binding var selectedQuantity:Int
    @Binding var itemPriceHashMap:[String:Double]
    @Binding var combinedCartPrice:Double
    
    var body: some View {
        Button{
            var keyExists = orderHashMap[selectedFood] != nil
            if(keyExists==false){
                let calculatedPrice : Double = (Double(selectedQuantity) * (itemPriceHashMap[selectedFood] ?? 0.00 ))
                let roundedPrice = ((calculatedPrice * 100).rounded())/100
                let addedEntry = quantityAndPrice(foodQuantity:selectedQuantity,foodPrice:roundedPrice)
                if(selectedQuantity > 0){
                    orderHashMap[selectedFood] = addedEntry
                }
                combinedCartPrice = combinedCartPrice+roundedPrice
            }
            else if(keyExists==true){
                let incrementedPrice : Double = (Double(selectedQuantity) * (itemPriceHashMap[selectedFood] ?? 0.00 )) + ((orderHashMap[selectedFood]?.foodPrice) ?? 0)
                
                let roundedIncrementPrice = ((incrementedPrice * 100).rounded())/100
                let incrementedQuantity = selectedQuantity + ((orderHashMap[selectedFood]?.foodQuantity) ?? 0)
                
                let incrementedEntry = quantityAndPrice(foodQuantity:(incrementedQuantity),foodPrice:roundedIncrementPrice)
                
                orderHashMap[selectedFood] = incrementedEntry
                combinedCartPrice = combinedCartPrice + (Double(selectedQuantity) * (itemPriceHashMap[selectedFood] ?? 0.00 ))
                
            }
            print(orderHashMap)
            print(combinedCartPrice)
            
        }label:{
            Text("Add To Cart").font(.system(size: 25, weight: .medium, design:.default)).frame(width: 120, height:80 )
                .foregroundColor(.black).background(.red).padding()
            
        }
    }
}

struct deleteItemButton: View {
    @Binding var alertBoolean:Bool
    @Binding var selectedFood:String
    @Binding var orderHashMap:[String:quantityAndPrice]
    @Binding var selectedQuantity:Int
    @Binding var maxItemsDeletable:Int
    @Binding var notEnoughToDelete:Bool
    @Binding var itemNotInCart:Bool
    @Binding var itemPriceHashMap:[String:Double]
    @Binding var combinedCartPrice:Double
    var body: some View {
        Button{
            let itemExists = orderHashMap[selectedFood] != nil
            if(itemExists==true){
                let deletedQuantity = (orderHashMap[selectedFood]?.foodQuantity ?? 0)-selectedQuantity
                maxItemsDeletable=(orderHashMap[selectedFood]?.foodQuantity ?? 0)
                if(deletedQuantity<0){
                    notEnoughToDelete = true
                    itemNotInCart = false
                    alertBoolean = notEnoughToDelete || itemNotInCart
                    
                }
                else{
                    if(deletedQuantity==0){
                        orderHashMap[selectedFood] = nil
                    }
                    else{
                        let deletedPrice:Double = Double(deletedQuantity) * (itemPriceHashMap[selectedFood] ?? 0)
                        let roundedDeletedPrice:Double = ((deletedPrice*100).rounded())/100
                        orderHashMap[selectedFood] =
                        quantityAndPrice(foodQuantity:deletedQuantity,foodPrice: roundedDeletedPrice)
                    }
                    combinedCartPrice = combinedCartPrice - (Double(selectedQuantity) * (itemPriceHashMap[selectedFood] ?? 0))
                    
                    
                }
                
                
            }
            
            else {
                
                itemNotInCart = true
                notEnoughToDelete = false
                alertBoolean = notEnoughToDelete || itemNotInCart
            }
            
            print(orderHashMap)
            print(combinedCartPrice)
            
        }
    label:{
        Text("Delete From Cart").font(.system(size: 25, weight: .medium, design:.default)).frame(width: 120, height:80 )
            .foregroundColor(.black).background(.red).padding()
        
    }.alert(isPresented: $alertBoolean){
        var alertMessage = Alert(title: Text("Default"), message: Text("Default"), dismissButton: .default(Text("Dismiss")))
        if(itemNotInCart == true){
            alertMessage = Alert(title: Text("Don't Have Item"), message: Text("You don't have any \(selectedFood) in your cart yet."), dismissButton: .default(Text("Dismiss")))
        }
        else if(notEnoughToDelete==true){
            alertMessage =  Alert(title: Text("Can't delete this many."), message: Text("You can only delete a maximum of \(maxItemsDeletable) \(selectedFood)"), dismissButton: .default(Text("Dismiss")))
            
        }
        return alertMessage
        
    }
    }
}

struct cartLink: View{
    var body: some View{
        HStack(spacing:20){
            Text("Go To Cart").font(.system(size: 30, weight: .bold, design:.default))
                .foregroundColor(.black)
            Image(systemName
                  : "cart.circle.fill")
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode
                             :.fit)
                .frame(width : 50, height : 50)
                .foregroundColor(.green)
            
            
            
        }.padding().border(Color.orange,width:10)
        
        
        
    }
    
    
    
    
}

struct cartScreen: View {
    
    var body: some View {
        
        NavigationView{
            
            ZStack{
                LinearGradient(
                    gradient: Gradient(colors:   [.red,.blue]),
                    startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                
                
               
                
                
                
        }
    }
    
    
    }
}



struct menuLink: View {
    var body: some View {
        HStack{
            Text("Go To Menu").font(.system(size: 30, weight: .bold, design:.default))
                .foregroundColor(.black)
            Image(systemName
                  : "menucard.fill")
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode
                             :.fit)
                .frame(width : 50, height : 50)
                .foregroundColor(.green)
            
            
        }.border(Color.green,width:10)
    }
}
