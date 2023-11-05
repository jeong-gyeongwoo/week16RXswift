//
//  BirthdayViewModel.swift
//  SeSACRxThreadsPractice
//
//  Created by 정경우 on 11/2/23.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa


class BirthdayViewModel {
    
    let birthday = BehaviorSubject(value: Date.now)
    let year = BehaviorSubject(value: 0)
    let month = BehaviorSubject(value: 0)
    let day = BehaviorSubject(value: 0)
  
    var ageEnabled = BehaviorSubject(value: false)

    var yearText = BehaviorSubject(value: "")
    
    let disposeBag = DisposeBag()
    
    
    init() {
        
        birthday
            .subscribe(with: self) { owner, date in
                let component = Calendar.current.dateComponents([.year,.month,.day], from: date)
                let today = Calendar.current.dateComponents([.year,.month,.day], from: Date.now)
        
                owner.year.onNext(component.year!)
                owner.month.onNext(component.month!)
                owner.day.onNext(component.day!)
        
                if today.year! - component.year! == 17, today.month! == component.month!, today.day! >= component.day! {
                    owner.ageEnabled.onNext(true)
                }  else if today.year! - component.year! == 17, today.month! > component.month! {
                    owner.ageEnabled.onNext(true)
                } else if today.year! - component.year! > 17 {
                    owner.ageEnabled.onNext(true)
                }  else {
                    owner.ageEnabled.onNext(false)
                }
                
            } onDisposed: { Object in
                print("birthday dispose")
            }
            .disposed(by: disposeBag)
        
        ageEnabled
            .subscribe {
                if $0 == true{
                    self.yearText.onNext("만 17세 이상입니다")
                } else {
                    self.yearText.onNext("만 17세 미만입니다")
                }
            }
            .disposed(by: disposeBag)
    }
    
    
}
