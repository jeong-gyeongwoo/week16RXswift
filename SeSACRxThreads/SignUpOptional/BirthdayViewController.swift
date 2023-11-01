//
//  BirthdayViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BirthdayViewController: UIViewController {
    
    let birthDayPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko-KR")
        picker.maximumDate = Date()
        return picker
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.black
        label.text = "만 17세 이상만 가입 가능합니다."
        return label
    }()
    
    let containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 10
        return stack
    }()
    
    let yearLabel: UILabel = {
        let label = UILabel()
        label.text = "2023년"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let monthLabel: UILabel = {
        let label = UILabel()
        label.text = "33월"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let dayLabel: UILabel = {
        let label = UILabel()
        label.text = "99일"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let nextButton = PointButton(title: "가입하기")
    
    let disposeBag = DisposeBag()
    let birthday = BehaviorSubject(value: Date.now)
    let year = BehaviorSubject(value: 0)
    let month = BehaviorSubject(value: 0)
    let day = BehaviorSubject(value: 0)
    
    let ageLabel = UILabel()
    var ageEnabled = BehaviorSubject(value: false)
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.white
        configureLayout()
        
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        
        bind()
        
    }
    
    func bind() {
        
        birthDayPicker.rx.date
            .bind(to: birthday)
            .disposed(by: disposeBag)
        
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
        
        year
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, value in
                owner.yearLabel.text = "\(value)년"
            } onDisposed: { Object in
                print("year dispose")
            }
            .disposed(by: disposeBag)
        
        month
            .map{"\($0)월"}
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, value in
                owner.monthLabel.text = value
            } onDisposed: { Object in
                print("month dispose")
            }
            .disposed(by: disposeBag)
        
        day
            .map{"\($0)일"}
            .bind(to: dayLabel.rx.text)
            .disposed(by: disposeBag)
        
        
        ageEnabled
            .subscribe(with: self, onNext: { object, bool in
                let text = bool ? "만 17세 이상입니다" : "만 17세 미만입니다"
                let color = bool ? UIColor.black : UIColor.red
                object.ageLabel.text = text
                object.nextButton.isEnabled = bool
                object.nextButton.backgroundColor = color
            })
            .disposed(by: disposeBag)
        
    }
    
    
    @objc func nextButtonClicked() {
        print("가입완료")
    }
    
    
    func configureLayout() {
        view.addSubview(infoLabel)
        view.addSubview(containerStackView)
        view.addSubview(birthDayPicker)
        view.addSubview(nextButton)
        view.addSubview(ageLabel)
        
        
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(150)
            $0.centerX.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        [yearLabel, monthLabel, dayLabel].forEach {
            containerStackView.addArrangedSubview($0)
        }
        
        birthDayPicker.snp.makeConstraints {
            $0.top.equalTo(containerStackView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(birthDayPicker.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        ageLabel.text = "나이 계산이 보여질 자리"
        ageLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(85)
            make.centerX.equalToSuperview()
        }
        
        
    }
    
}
