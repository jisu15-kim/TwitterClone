//
//  ProfileFilterCell.swift
//  TwitterTutorial
//
//  Created by 김지수 on 2023/02/26.
//

import UIKit

class ProfileFilterCell: UICollectionViewCell {
    //MARK: - Properties
    var option: ProfileFilterOptions! {
        didSet {
            titleLabel.text = option.description
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 16)
        label.text = "Test filter"
        return label
    }()
    
    // 현재 선택에 따라 글자 크기 / 색상 변경
    // isSelected - 이미 정의되어 있음
    override var isSelected: Bool {
        didSet {
            if isSelected == true {
                titleLabel.font = .boldSystemFont(ofSize: 16)
                titleLabel.textColor = .twitterBlue
            } else {
                titleLabel.font = .systemFont(ofSize: 14)
                titleLabel.textColor = .lightGray
            }
        }
    }
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super .init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helper
    private func configureUI() {
        backgroundColor = .white
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
