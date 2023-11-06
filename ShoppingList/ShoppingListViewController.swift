//
//  ShoppingListView.swift
//  SeSACRxThreadsPractice
//
//  Created by 정경우 on 11/5/23.
//


import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ShoppingListViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.register(ShoppingListViewCell.self, forCellReuseIdentifier: ShoppingListViewCell.identifier)
        view.rowHeight = 80
        view.backgroundColor = .white
        return view
    }()
    
    var textField = UITextField()
    let addButton = UIButton()
    let disposeBag = DisposeBag()
    let viewModel = ShoppingListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "쇼핑"
        configure()
        bind()
    }

    func bind() {
        
        viewModel.items
            .bind(to: tableView.rx.items(cellIdentifier: ShoppingListViewCell.identifier, cellType: ShoppingListViewCell.self)) { (row, element, cell) in
                
                cell.mainTitleLabel.text = element.textData
                let checkStatus = element.checkBool ? "checkmark.square.fill" : "checkmark.square"
                let starStatus = element.starBool ? "star.fill" : "star"
                cell.checkboxButton.setImage(UIImage(systemName: checkStatus), for: .normal)
                cell.starButton.setImage(UIImage(systemName: starStatus), for: .normal)
                
                cell.checkboxButton.rx.tap
                    .observe(on: MainScheduler.instance)
                    .subscribe(with: self) { owner, void in
                        owner.viewModel.shoppingList[row].checkBool.toggle()
                    }
                    .disposed(by: cell.disposeBag)
                
                cell.starButton.rx.tap
                    .observe(on: MainScheduler.instance)
                    .subscribe(with: self) { owner, void in
                        owner.viewModel.shoppingList[row].starBool.toggle()
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        textField.rx.text.orEmpty
            .debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(with: self) { owner, value in
                let result = value == "" ? owner.viewModel.shoppingList : owner.viewModel.shoppingList.filter{
                    $0.textData.contains(value)
                }
                owner.viewModel.items.onNext(result)
            }
            .disposed(by: disposeBag)
        
        
        addButton.rx.tap
            .withLatestFrom(textField.rx.text.orEmpty){ Void, text in
                return text
            }
            .subscribe(with: self) { owner, text in
                owner.viewModel.shoppingList.insert(ShoppingListModel(textData: text, checkBool: false, starBool: false), at: 0)
                print(owner.viewModel.shoppingList)
            }
            .disposed(by: disposeBag)
        
        
        tableView.rx.itemDeleted
            .subscribe(with: self) { owner, indexPath in
                owner.viewModel.shoppingList.remove(at: indexPath.row)
            }
            .disposed(by: disposeBag)
        
        
        
    }
    
    func configure() {
        
        [tableView, textField, addButton].forEach {
            view.addSubview($0)
        }
        
        textField.placeholder = "  무엇을 구매하실 건가요?"
        textField.backgroundColor = .lightGray
        textField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.height.equalTo(50)
            make.width.equalTo(view.bounds.width)
        }
        
        addButton.setTitle("추가", for: .normal)
        addButton.backgroundColor = .black
        addButton.snp.makeConstraints { make in
            make.centerY.equalTo(textField.snp.centerY)
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(addButton.intrinsicContentSize.width * 1.5)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(20)
            make.width.equalTo(view.bounds.width)
            make.bottom.equalTo(view.bounds.height)
        }
        
        let starButton = UIBarButtonItem(
            image: UIImage(systemName: "star"),
            style: .plain,
            target: self,
            action: #selector(starButtonClicked)
        )
        
        navigationItem.rightBarButtonItem = starButton
    }
    
  
    @objc func starButtonClicked() {
        
        let vc = StarViewController()
      
        viewModel.items
            .subscribe(with: self) { owner, data in
                data.forEach { star in
                    if star.starBool == true {
                        vc.viewModel.starList.append(star)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}


//렘 달아주고 즐겨찾기 및 체크마크
