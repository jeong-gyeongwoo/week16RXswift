//
//  ShoppingListViewCell.swift
//  SeSACRxThreadsPractice
//
//  Created by 정경우 on 11/5/23.
//

import UIKit
import SnapKit
import RxSwift

class ShoppingListViewCell: UITableViewCell {
    
    static let identifier = "ShoppingListViewCell"

    var checkboxButton = UIButton()
    var mainTitleLabel = UILabel()
    var starButton = UIButton()
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainTitleLabel.font = .boldSystemFont(ofSize: 17)
        mainTitleLabel.textColor = .black
        
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .lightGray
        configure()
        setConstraints()
        
    }

    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func configure() {
        [checkboxButton, mainTitleLabel, starButton].forEach {
            contentView.addSubview($0)
        }
    }
    

    func setConstraints() {
        
        checkboxButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        
        mainTitleLabel.text = "텍스트"
        mainTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(checkboxButton.snp.trailing).offset(30)
            make.centerY.equalToSuperview()
        }
        
        starButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        
        
    }
    
    
    
    
}
