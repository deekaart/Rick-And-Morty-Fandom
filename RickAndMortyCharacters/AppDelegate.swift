//
//  AppDelegate.swift
//  RickAndMortyCharacters
//
//  Created by Murad on 27.10.22.
//

import UIKit
import Kingfisher

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let basevc = HomeViewController(vm: HomeViewModel())
        basevc.title = "Characters"
        let vc = UINavigationController(rootViewController: basevc)
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        let cache = KingfisherManager.shared.cache
        cache.clearMemoryCache()
    }
}

