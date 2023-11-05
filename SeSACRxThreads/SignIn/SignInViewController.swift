//
//  SignInViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SignInViewController: UIViewController {

    let emailTextField = SignTextField(placeholderText: "이메일을 입력해주세요")
    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
    let signInButton = PointButton(title: "로그인")
    let signUpButton = UIButton()
    
    let testSwitch = UISwitch()
//    let isOn = //Observable.just(false) // 전달만
////     BehaviorSubject(value: true) // 초기값
//     PublishSubject<Bool>() // 초기값 없는 버젼
    
    let viewModel = SignInViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        configure()
        
        signUpButton.addTarget(self, action: #selector(signUpButtonClicked), for: .touchUpInside)
        
        activateSwitch()
        bind()
    }
    
    func bind() {
        
        viewModel.email
            .bind(to: emailTextField.rx.text)
            .disposed(by: disposeBag)
        
        emailTextField.rx.text.orEmpty
            .subscribe(with: self) { owner, value in
                owner.viewModel.email.onNext(value)
            }
            .disposed(by: disposeBag)
        
        viewModel.password
            .bind(to: passwordTextField.rx.text)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text.orEmpty
            .subscribe(with: self) { owner, value in
                owner.viewModel.password.onNext(value)
            }
            .disposed(by: disposeBag)

        viewModel.buttonStatus
            .subscribe(with: self) { owner, value in
                owner.signInButton.backgroundColor = value ? UIColor.blue : UIColor.red
                owner.emailTextField.layer.borderColor = value ? UIColor.blue.cgColor : UIColor.red.cgColor
                owner.passwordTextField.layer.borderColor = value ? UIColor.blue.cgColor : UIColor.red.cgColor
            }
            .disposed(by: disposeBag)
        
        viewModel.buttonStatus
            .bind(to: signInButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        
        signInButton.rx.tap
            .subscribe(with: self) { owner, value in
                print("SELECT")
            }
            .disposed(by: disposeBag)
        
    }
    
    
    
    
    
    func activateSwitch() {
        
        view.addSubview(testSwitch)
        testSwitch.snp.makeConstraints { make in
            make.top.equalTo(150)
            make.leading.equalTo(100)
        }
        
        viewModel.isOn
            .observe(on: MainScheduler.instance)
            //애니메이션을 주기위해
            .subscribe(with: self) { owner, value in
                owner.testSwitch.setOn(value, animated: true)
            }
            //.bind(to: testSwitch.rx.isOn)
            .disposed(by: disposeBag)
    }

    @objc func signUpButtonClicked() {
        navigationController?.pushViewController(SignUpViewController(), animated: true)
    }
    
    
    func configure() {
        signUpButton.setTitle("회원이 아니십니까?", for: .normal)
        signUpButton.setTitleColor(Color.black, for: .normal)
    }
    
    func configureLayout() {
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signInButton)
        view.addSubview(signUpButton)
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        signInButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(signInButton.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    

}
