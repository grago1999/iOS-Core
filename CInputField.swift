//
//  CInputView.swift
//  Qume
//
//  Created by Gianluca Rago on 11/19/17.
//  Copyright © 2017 Ragoware. All rights reserved.
//

import UIKit

class CInputField: UITextField, UITextFieldDelegate {
    
    private var id:String
    
    init(frame:CGRect, id:String) {
        self.id = id
        super.init(frame:frame)
        self.placeholder = LocaleMessages.get(id:id)
        self.delegate = self
    }
    
    func secure() {
        self.isSecureTextEntry = true
        self.autocapitalizationType = .none
        self.autocorrectionType = .no
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    init() {
        self.id = ""
        super.init(frame:.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.id = ""
        super.init(coder:aDecoder)
    }
    
}
