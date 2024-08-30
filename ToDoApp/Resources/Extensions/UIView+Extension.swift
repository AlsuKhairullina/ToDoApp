//
//  UIView+Extension.swift
//  ToDoApp
//
//  Created by Алсу Хайруллина on 27.08.2024.
//

import UIKit

extension UIView {
    public func addSubviews(_ subviews: UIView...) {
        subviews.forEach(addSubview)
    }
}
