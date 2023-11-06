//
//  StarViewModel.swift
//  SeSACRxThreadsPractice
//
//  Created by 정경우 on 11/6/23.
//

import Foundation
import RxSwift
import RxCocoa

class StarViewModel {
    
    var starList: [ShoppingListModel] =
        []{
            didSet {
            starItems.onNext(starList)
            }
        }
    
    lazy var starItems = BehaviorSubject(value: starList)
    
    
    
    
}
