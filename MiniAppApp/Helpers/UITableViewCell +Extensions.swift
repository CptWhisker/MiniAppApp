//
//  UITableViewCell +Extensions.swift
//  MiniAppApp
//
//  Created by user on 08.09.2024.
//

import UIKit

extension UITableViewCell {
    func setLeftAndRightSeparatorInsets(to value: CGFloat) {
        separatorInset = UIEdgeInsets(top: 0, left: value, bottom: 0, right: value)
    }
}
