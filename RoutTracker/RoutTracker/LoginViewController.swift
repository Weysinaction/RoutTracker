//
//  LoginViewController.swift
//  RoutTracker
//
//  Created by Владислав Лазарев on 03.10.2021.
//

import UIKit
import RxCocoa
import RxSwift

class LoginViewController: UIViewController {
    @IBOutlet var loginTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLoginBindings()
    }

    func configureLoginBindings() {
        Observable.combineLatest(loginTextField.rx.text,
                                 passwordTextField.rx.text).map {
                                    login, password in
                                    return !(login ?? "").isEmpty && !(password ?? "").isEmpty
                                 }.bind { [weak loginButton] inputFilled in
                                    loginButton?.isEnabled = inputFilled
                                 }
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        let vc = ViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
