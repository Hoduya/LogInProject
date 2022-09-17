//
//  ViewController.swift
//  LogInProject
//
//  Created by HoJun on 2022/09/17.
//

import UIKit

// Direct dispatch를 위한 final 키워드
final class ViewController: UIViewController {
    
    // 뷰의 직접적인 속성에 관한 것은 클로저 형태로 묶어 놓으면 구분이 명확하고, 코드가 간결해짐
    private lazy var emailTextFieldView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.darkGray
        view.layer.cornerRadius = 5 // 테두리 둥글게
        view.layer.masksToBounds = true
        
        // 하위 뷰 지정 - 하위 뷰가 생성된 후에 지정 가능하기 때문에 lazy var로 선언해줘야 함
        view.addSubview(emailTextField)
        view.addSubview(emailInfoLabel)
        
        return view
    }()
    
    private var emailInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일 주소 또는 전화번호"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor.white
        return label
    }()
    
    private lazy var emailTextField: UITextField = {
        var tf = UITextField()
        tf.frame.size.height = 48
        tf.backgroundColor = .clear
        tf.textColor = .white
        tf.tintColor = .white
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.keyboardType = .emailAddress
        tf.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        
        return tf
    }()
    
    private lazy var passWordTextFieldView: UIView = {
        let view = UIView()
        view.frame.size.height = 48
        view.backgroundColor = UIColor.darkGray
        view.layer.cornerRadius = 5 // 테두리 둥글게
        view.layer.masksToBounds = true
        
        view.addSubview(passWordTextField)
        view.addSubview(passWordInfoLabel)
        view.addSubview(passWordSecureButton)
        
        return view
    }()
    
    private var passWordInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor.white
        return label
    }()
    
    private lazy var passWordTextField: UITextField = {
        var tf = UITextField()
        tf.frame.size.height = 48
        tf.backgroundColor = .clear
        tf.textColor = .white
        tf.tintColor = .white
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.isSecureTextEntry = true
        tf.clearsOnBeginEditing = false
        tf.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        
        return tf
    }()
    
    private let passWordSecureButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("표시", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .light)
        button.addTarget(self, action: #selector(passWordSecureModeSetting), for: .touchUpInside)
        
        return button
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        button.setTitle("로그인", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.isEnabled = false
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        return button
    }()
        
    lazy var stackView: UIStackView = {
        let st = UIStackView(arrangedSubviews: [emailTextFieldView, passWordTextFieldView, loginButton])
        st.spacing = 18
        st.axis = .vertical
        st.distribution = .fillEqually
        st.alignment = .fill
        
        return st
    }()
    
    private let passWordResetButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear
        button.setTitle("비밀번호 재설정", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    // 텍스트필드, 버튼 높이 설정
    private let textViewHeight: CGFloat = 48
    
    // 오토레이아웃 향후 변경을 위한 변수
    lazy var emailInfoLabelCenterYConstraint = emailInfoLabel.centerYAnchor.constraint(equalTo: emailTextFieldView.centerYAnchor)
    lazy var passWordInfoLabelCenterYConstraint = passWordInfoLabel.centerYAnchor.constraint(equalTo: passWordTextFieldView.centerYAnchor)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passWordTextField.delegate = self
        
        setUpUI()
    }
    
    func setUpUI() {
        view.backgroundColor = UIColor.black
        
        // 최상단 뷰의 하위 뷰 지정.
        view.addSubview(stackView)
        view.addSubview(passWordResetButton)
        
        // 자동 오토레이아웃 설정 해제. 내가 정의하기 위해
        emailInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        passWordInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        passWordTextField.translatesAutoresizingMaskIntoConstraints = false
        passWordSecureButton.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        passWordResetButton.translatesAutoresizingMaskIntoConstraints = false

        
        // 일일이 .isActive = true 쓸 필요 없이 한번에 처리할 수 있다.
        NSLayoutConstraint.activate([
            // equalTo: 어디를 기준으로 떨어질지, constant: 얼마나 떨어질건지
            emailInfoLabel.leadingAnchor.constraint(equalTo: emailTextFieldView.leadingAnchor, constant: 8),
            emailInfoLabel.trailingAnchor.constraint(equalTo: emailTextFieldView.trailingAnchor, constant: 8),
            //emailInfoLabel.centerYAnchor.constraint(equalTo: emailTextFieldView.centerYAnchor),
            emailInfoLabelCenterYConstraint, // 향후 레이아웃 조정을 위해 변수를 넣음
            
            emailTextField.leadingAnchor.constraint(equalTo: emailTextFieldView.leadingAnchor, constant: 8),
            emailTextField.trailingAnchor.constraint(equalTo: emailTextFieldView.trailingAnchor, constant: 8),
            emailTextField.topAnchor.constraint(equalTo: emailTextFieldView.topAnchor, constant: 15),
            emailTextField.bottomAnchor.constraint(equalTo: emailTextFieldView.bottomAnchor, constant: 2),

            passWordInfoLabel.leadingAnchor.constraint(equalTo: passWordTextFieldView.leadingAnchor, constant: 8),
            passWordInfoLabel.trailingAnchor.constraint(equalTo: passWordTextFieldView.trailingAnchor, constant: 8),
            //passWordInfoLabel.centerYAnchor.constraint(equalTo: passWordTextFieldView.centerYAnchor),
            passWordInfoLabelCenterYConstraint,

            passWordTextField.topAnchor.constraint(equalTo: passWordTextFieldView.topAnchor, constant: 15),
            passWordTextField.bottomAnchor.constraint(equalTo: passWordTextFieldView.bottomAnchor, constant: 2),
            passWordTextField.leadingAnchor.constraint(equalTo: passWordTextFieldView.leadingAnchor, constant: 8),
            passWordTextField.trailingAnchor.constraint(equalTo: passWordTextFieldView.trailingAnchor, constant: 8),

            passWordSecureButton.topAnchor.constraint(equalTo: passWordTextFieldView.topAnchor, constant: 15),
            passWordSecureButton.bottomAnchor.constraint(equalTo: passWordTextFieldView.bottomAnchor, constant: -15),
            passWordSecureButton.trailingAnchor.constraint(equalTo: passWordTextFieldView.trailingAnchor, constant: -8),

            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            stackView.heightAnchor.constraint(equalToConstant: textViewHeight * 3 + 36),
            
            passWordResetButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10),
            passWordResetButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            passWordResetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            passWordResetButton.heightAnchor.constraint(equalToConstant: textViewHeight)
        ])
    }
    
    @objc func resetButtonTapped() {
        let alert = UIAlertController(title: "비밀번호 변경", message: "비밀번호를 변경하시겠습니까?", preferredStyle: .alert)
        
        let success = UIAlertAction(title: "확인", style: .default) { action in
            print("확인버튼 눌림")
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel) { cancel in
            print("취소버튼 눌림")
        }
        
        alert.addAction(success)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
    
    @objc func passWordSecureModeSetting() {
        passWordTextField.isSecureTextEntry.toggle()
    }
    
    @objc func loginButtonTapped() {
        print("로그인 버튼 눌림")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// 보통 델리게이트 설정은 확장을 통해 구현
// 구분이 명확하고 코드가 간결해짐
extension ViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailTextField {
            emailTextFieldView.backgroundColor = #colorLiteral(red: 0.2972877622, green: 0.2973434925, blue: 0.297280401, alpha: 1)
            emailInfoLabel.font = UIFont.systemFont(ofSize: 11)
            // 오토레이아웃 업데이트
            emailInfoLabelCenterYConstraint.constant = -13
        }
        
        if textField == passWordTextField {
            passWordTextFieldView.backgroundColor = #colorLiteral(red: 0.2972877622, green: 0.2973434925, blue: 0.297280401, alpha: 1)
            passWordInfoLabel.font = UIFont.systemFont(ofSize: 11)
            // 오토레이아웃 업데이트
            passWordInfoLabelCenterYConstraint.constant = -13
        }
        
        // 애니메이션 추가
        UIView.animate(withDuration: 0.3) {
            // 스택뷰 하위 뷰들의 레이아웃 변경 시 애니메이션
            self.stackView.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTextField {
            emailTextFieldView.backgroundColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
            // 빈칸이면 원래로 되돌리기
            if emailTextField.text == "" {
                emailInfoLabel.font = UIFont.systemFont(ofSize: 18)
                emailInfoLabelCenterYConstraint.constant = 0
            }
        }
        if textField == passWordTextField {
            passWordTextFieldView.backgroundColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
            // 빈칸이면 원래로 되돌리기
            if passWordTextField.text == "" {
                passWordInfoLabel.font = UIFont.systemFont(ofSize: 18)
                passWordInfoLabelCenterYConstraint.constant = 0
            }
        }
        
        // 애니메이션 추가
        UIView.animate(withDuration: 0.3) {
            self.stackView.layoutIfNeeded()
        }
    }
    
    @objc func textFieldEditingChanged(_ textField: UITextField) {
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                return
            }
        }
        
        guard
            let email = emailTextField.text, !email.isEmpty,
            let password = passWordTextField.text, !password.isEmpty else {
            loginButton.backgroundColor = .clear
            loginButton.isEnabled = false
            return
        }
        loginButton.backgroundColor = .red
        loginButton.isEnabled = true
    }
}

