//
//  RegistrationController.swift
//  TwitterTutorial
//
//  Created by 김지수 on 2023/02/24.
//

import UIKit
import Firebase

class RegistrationController: UIViewController {
    
    //MARK: - Properties
    private let imagePicker = UIImagePickerController()
    private var profileImage: UIImage?
    
    private let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo"), for: .normal)
        button.tintColor = .white
        button.addTarget(nil, action: #selector(handleAddProfilePhoto), for: .touchUpInside)
        return button
    }()
    
    private lazy var emailContainerView: UIView = {
        let image = #imageLiteral(resourceName: "ic_mail_outline_white_2x-1")
        let view = Utilities().inputContainerView(withImage: image, textField: emailTextField)
        return view
    }()
    
    private lazy var passwordContainerView: UIView = {
        let image = #imageLiteral(resourceName: "ic_lock_outline_white_2x")
        let view = Utilities().inputContainerView(withImage: image, textField: passwordTextField)
        return view
    }()
    
    private lazy var fullNameContainerView: UIView = {
        let image = #imageLiteral(resourceName: "ic_menu_white_3x")
        let view = Utilities().inputContainerView(withImage: image, textField: fullNameTextField)
        return view
    }()
    
    private lazy var userNameContainerView: UIView = {
        let image = #imageLiteral(resourceName: "ic_lock_outline_white_2x")
        let view = Utilities().inputContainerView(withImage: image, textField: userNameTextField)
        return view
    }()
    
    private let emailTextField: UITextField = {
        let tf = Utilities().textFields(withPlaceholder: "Email")
        return tf
    }()
    
    private let passwordTextField: UITextField = {
        let tf = Utilities().textFields(withPlaceholder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let fullNameTextField: UITextField = {
        let tf = Utilities().textFields(withPlaceholder: "Full Name")
        return tf
    }()
    
    private let userNameTextField: UITextField = {
        let tf = Utilities().textFields(withPlaceholder: "User Name")
        return tf
    }()
    
    private let registrationButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 5
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.addTarget(nil, action: #selector(handleRegistration), for: .touchUpInside)
        return button
    }()
    
    private let alreadyHaveAccountButton: UIButton = {
        let button = Utilities().attributedButton("Already have an account? ", "Sign In")
        button.addTarget(nil, action: #selector(handleShowSignIn), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    //MARK: - Selectores
    @objc func handleShowSignIn() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleAddProfilePhoto() {
        present(imagePicker, animated: true)
    }
    
    // 회원가입 버튼
    @objc func handleRegistration() {
        guard let profileImage = profileImage else {
            print("DEBUG: 프로필 이미지를 선택해주세요")
            return
        }
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let fullname = fullNameTextField.text else { return }
        guard let username = userNameTextField.text else { return }
        
        guard let imageData = profileImage.jpegData(compressionQuality: 0.3) else {
            print("DEBUG: JPEG 변환 실패")
            return
        }
        let filename = NSUUID().uuidString
        let storageRef = STORAGE_PROFILE_IMAGES.child(filename)
        
        
        // 이미지 업로드
        storageRef.putData(imageData, metadata: nil) {(meta, error) in
            
            // 이미지 다운로드
            storageRef.downloadURL { (url, error) in
                // URL 가져오기
                guard let profileImageUrl = url?.absoluteString else { return }
                print("PROFILE URL : \(profileImageUrl)")
                // Firebase 로그인 Auth
                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    if let error = error {
                        print("DEBUG: Error is \(error.localizedDescription)")
                        return // 에러가 있으면 함수 종료
                    }
                    
                    guard let uid = result?.user.uid else { return }
                    
                    let values = ["email" : email,
                                  "username" : username,
                                  "fullname" : fullname,
                                  "profileImageUrl" : profileImageUrl]
                    
                    REF_USERS.child(uid).updateChildValues(values) { (error, ref) in
                        print("작동해")
                    }
                }
            }
        }
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .twitterBlue
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        view.addSubview(plusPhotoButton)
        plusPhotoButton.snp.makeConstraints {
            $0.centerX.top.equalTo(view.safeAreaLayoutGuide)
            $0.width.height.equalTo(128)
        }
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView,
                                                   passwordContainerView,
                                                   fullNameContainerView,
                                                   userNameContainerView,
                                                   registrationButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually
        
        view.addSubview(stack)
        stack.snp.makeConstraints {
            $0.top.equalTo(plusPhotoButton.snp.bottom).inset(-32)
            $0.leading.trailing.equalToSuperview().inset(28)
        }
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(40)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

//MARK: - UIImagePickerControllerDelegate
extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let profileImage = info[.editedImage] as? UIImage else { return }
        self.profileImage = profileImage
        plusPhotoButton.layer.cornerRadius = 128 / 2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.imageView?.contentMode = .scaleAspectFill
        plusPhotoButton.imageView?.clipsToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.white.cgColor
        plusPhotoButton.layer.borderWidth = 3
        
        self.plusPhotoButton.setImage(profileImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        dismiss(animated: true)
    }
}
