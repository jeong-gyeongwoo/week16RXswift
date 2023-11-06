//
//  ShoppingListViewModel.swift
//  SeSACRxThreadsPractice
//
//  Created by 정경우 on 11/5/23.
//

import Foundation
import RxSwift


class ShoppingListViewModel {
    
    var shoppingList: [ShoppingListModel] =
    [ShoppingListModel(textData: "살거 1번", checkBool: false, starBool: false),
     ShoppingListModel(textData: "살거 2번", checkBool: false, starBool: false),
     ShoppingListModel(textData: "살거 3번", checkBool: false, starBool: false),
     ShoppingListModel(textData: "살거 4번", checkBool: false, starBool: false),
     ShoppingListModel(textData: "살거 5번", checkBool: false, starBool: false)
    ] {
        didSet {
            items.onNext(shoppingList)
        }
    }
    
    lazy var items = BehaviorSubject(value: shoppingList)
  
    
}
