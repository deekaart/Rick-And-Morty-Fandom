//
//  UITableViewCell+Ext.swift
//  RickAndMortyCharacters
//
//  Created by Murad on 27.10.22.
//

import UIKit

protocol ReusableView {
    static var reuseIdentifier: String { get }
}

extension ReusableView {
    static var reuseIdentifier: String {
        String(describing: self)
    }
}

extension UITableViewCell: ReusableView {}
