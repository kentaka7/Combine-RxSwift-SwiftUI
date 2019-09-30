//
//  LoginViewModel.swift
//  LoginCombineMVVM
//
//  Created by Atif on 29/09/2019.
//  Copyright © 2019 Atif. All rights reserved.
//

import Foundation
import UIKit
import Combine

class LoginViewModel: ObservableObject, Identifiable {
    private var disposables = Set<AnyCancellable>()
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isValid: Bool = false
    @Published var btnColor: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    private var isValidEmail: Bool = false
    private var isValidPassword: Bool = false


    init(scheduler: DispatchQueue = DispatchQueue(label: "LoginViewModel")) {
        _ = $email
        .dropFirst(1)
        .debounce(for: .seconds(0.1), scheduler: scheduler)
        .sink(receiveValue: validateEmail(forEmail:))
        .store(in: &disposables)

        _ = $password
        .dropFirst(1)
        .debounce(for: .seconds(0.1), scheduler: scheduler)
        .sink(receiveValue: validatePasssword(forPassword:))
        .store(in: &disposables)

    }
    
    func validateEmail(forEmail email: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0) { [weak self] in
            self?.isValidEmail = email.isValidEmail()
            self?.validate()
        }
    }
    
    func validatePasssword(forPassword password: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0) { [weak self] in
            self?.isValidPassword = password.isValidPassword()
            self?.validate()
        }
    }

    func validate() {
        isValid = (isValidEmail && isValidPassword) ? true : false
        btnColor = isValid ? UIColor.green : UIColor.white
    }

}



