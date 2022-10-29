//
//  Colors.swift
//  RickAndMortyCharacters
//
//  Created by Murad on 28.10.22.
//

import UIKit

enum AssetsColor {
    case background
    case text
    case rmgreen
    case gray
    case red
    case purple
}

extension UIColor {
    static func appColor(_ name: AssetsColor) -> UIColor? {
        switch name {
        case .background:
            return UIColor(named: "background")
        case .text:
            return UIColor(named: "text")
        case .rmgreen:
            return UIColor(named: "rmgreen")
        case .gray:
            return UIColor(named: "gray")
        case .red:
            return UIColor.systemRed
        case .purple:
            return UIColor.systemPurple
        }
    }
}
