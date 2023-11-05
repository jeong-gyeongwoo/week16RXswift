//
//  SignInViewModel.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import Foundation
import RxSwift
import RxCocoa

class SignInViewModel {
    
    let isOn = BehaviorSubject(value: true)
    
    let email = BehaviorSubject(value: "")
    let password = BehaviorSubject(value: "")
    
    let buttonStatus = BehaviorSubject(value: false)
    
    let disposeBag = DisposeBag()
    
    init() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isOn.onNext(false)
        }
        
     let  validation = Observable.combineLatest(email, password) { emailResult, passwordResult in
            return emailResult.count > 2 && passwordResult.count >= 6
        }
        
        validation
            .bind(to: buttonStatus)
            .disposed(by: disposeBag)
        
            
        
            
            
        
        
        
    }
        

}
