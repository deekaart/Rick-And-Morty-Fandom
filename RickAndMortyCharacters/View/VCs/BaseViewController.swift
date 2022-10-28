//
//  BaseViewController.swift
//  RickAndMortyCharacters
//
//  Created by Murad on 27.10.22.
//

import Foundation
import UIKit

public class BaseViewController<VM: AnyObject>: UIViewController {

    internal var viewModel: VM

    init(vm: VM) {
        self.viewModel = vm
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
