//
//  PhoneViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//
 
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PhoneViewController: UIViewController {
   
    let phoneTextField = SignTextField(placeholderText: "연락처를 입력해주세요")
    let nextButton = PointButton(title: "다음")
    
    let phone = BehaviorSubject(value: "010-1111-1234")
    let buttonColor = BehaviorSubject(value: UIColor.red)
    let buttonEnabled = BehaviorSubject(value: false)
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        
        bind()
    }
    
    func bind() {
        
        buttonEnabled
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        buttonColor
            .map { $0.cgColor }
            .bind(to: phoneTextField.layer.rx.borderColor)
            .disposed(by: disposeBag)
        
        buttonColor
            .bind(to: nextButton.rx.backgroundColor, phoneTextField.rx.tintColor)
            .disposed(by: disposeBag)
        
        phone
            .bind(to: phoneTextField.rx.text)
            .disposed(by: disposeBag)
        
//        phone
//            .map{ $0.count > 10 }
//            .subscribe { value in
//                let color = value ? UIColor.blue : UIColor.red
//                self.buttonColor.onNext(color)
//                self.buttonEnabled.onNext(value)
//            }
 //           .disposed(by: disposeBag)

        
//        phone
//            .map{$0.count > 10}
//            .withUnretained(self)
//            .subscribe { object, bool in
//                let color = bool ? UIColor.blue : UIColor.red
//                object.buttonColor.onNext(color)
//                object.buttonEnabled.onNext(bool)
//            }
//            .disposed(by: disposeBag)
        
        
        phone
            .map{$0.count > 10}
            .subscribe(with: self, onNext: { object, bool in
                let color = bool ? UIColor.blue : UIColor.red
                    object.buttonColor.onNext(color)
                    object.buttonEnabled.onNext(bool)
            })
            .disposed(by: disposeBag)
        
        phoneTextField.rx.text.orEmpty
            .subscribe { value in
                let result = value.formated(by: "###-####-####")
                self.phone.onNext(result)
            }
            .disposed(by: disposeBag)
    }
    
    
    
    
    @objc func nextButtonClicked() {
        navigationController?.pushViewController(NicknameViewController(), animated: true)
    }

    
    func configureLayout() {
        view.addSubview(phoneTextField)
        view.addSubview(nextButton)
         
        phoneTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(phoneTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}

extension String {
    var decimalFilteredString: String {
        return String(unicodeScalars.filter(CharacterSet.decimalDigits.contains))
    }
    
    func formated(by patternString: String) -> String {
        let digit: Character = "#"
 
        let pattern: [Character] = Array(patternString)
        let input: [Character] = Array(self.decimalFilteredString)
        var formatted: [Character] = []
 
        var patternIndex = 0
        var inputIndex = 0
 
        // 2
        while inputIndex < input.count {
            let inputCharacter = input[inputIndex]
 
            // 2-1
            guard patternIndex < pattern.count else { break }
 
            switch pattern[patternIndex] == digit {
            case true:
                // 2-2
                formatted.append(inputCharacter)
                inputIndex += 1
            case false:
                // 2-3
                formatted.append(pattern[patternIndex])
            }
 
            patternIndex += 1
        }
 
        // 3
        return String(formatted)
    }
}
