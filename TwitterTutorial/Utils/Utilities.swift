//
//  Utilities.swift
//  TwitterTutorial
//
//  Created by 김지수 on 2023/02/24.
//

import UIKit
import SnapKit

class Utilities {
    
    func inputContainerView(withImage image: UIImage, textField: UITextField) -> UIView {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let iv = UIImageView()
        iv.image = image
        
        view.addSubview(iv)
        iv.snp.makeConstraints {
            $0.leading.bottom.equalToSuperview().inset(8)
            $0.width.height.equalTo(22)
        }
        
        view.addSubview(textField)
        textField.snp.makeConstraints {
            $0.leading.equalTo(iv.snp.trailing).inset(-8)
            $0.bottom.trailing.equalToSuperview().inset(8)
        }
        
        let dividerView = UIView()
        dividerView.backgroundColor = .white
        view.addSubview(dividerView)
        dividerView.snp.makeConstraints {
            $0.leading.equalTo(iv.snp.leading)
            $0.trailing.equalTo(textField.snp.trailing)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(0.75)
        }
        
        return view
    }
    
    func textFields(withPlaceholder placeholder: String) -> UITextField {
        let tf = UITextField()
        tf.textColor = .white
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        return tf
    }
}
