//
//  Extensions.swift
//  profiles
//
//  Created by Joshua Gilstrap on 7/13/18.
//  Copyright © 2018 Joshua Gilstrap. All rights reserved.
//

import UIKit

extension UIColor {
    static var babyBlue: UIColor = UIColor(red: 137/255, green: 207/255, blue: 240/255, alpha: 1)
    static var babyPink: UIColor = UIColor(red: 244/255, green: 194/255, blue: 194/255, alpha: 1)
}

extension UIViewController {
    func showSimpleAlert(title: String, message: String, button: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        present(alertController, animated: true)
    }
}
