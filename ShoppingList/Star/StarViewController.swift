//
//  starViewController.swift
//  SeSACRxThreadsPractice
//
//  Created by 정경우 on 11/5/23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class StarViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.register(StarListViewCell.self, forCellReuseIdentifier: StarListViewCell.identifier)
        view.rowHeight = 80
        view.backgroundColor = .white
        return view
    }()
    
    let disposeBag = DisposeBag()
    let viewModel = StarViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configure()
        bind()
        
    }

    func bind() {
        
        viewModel.starItems
            .bind(to: tableView.rx.items(cellIdentifier: StarListViewCell.identifier, cellType: StarListViewCell.self)) { (row, element, cell) in
                
                cell.mainTitleLabel.text = element.textData
                let checkStatus = element.checkBool ? "checkmark.square.fill" : "checkmark.square"
                let starStatus = element.starBool ? "star.fill" : "star"
                cell.checkboxButton.setImage(UIImage(systemName: checkStatus), for: .normal)
                cell.starButton.setImage(UIImage(systemName: starStatus), for: .normal)
                
                cell.checkboxButton.rx.tap
                    .observe(on: MainScheduler.instance)
                    .subscribe(with: self) { owner, void in
                        owner.viewModel.starList[row].checkBool.toggle()
                    }
                    .disposed(by: cell.disposeBag)
                
                cell.starButton.rx.tap
                    .observe(on: MainScheduler.instance)
                    .subscribe(with: self) { owner, void in
                        owner.viewModel.starList[row].starBool.toggle()
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemDeleted
            .subscribe(with: self) { owner, indexPath in
                owner.viewModel.starList.remove(at: indexPath.row)
            }
            .disposed(by: disposeBag)
        
    }
    
    func configure() {
        
        [tableView].forEach {
            view.addSubview($0)
        }
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    
    
    
}

