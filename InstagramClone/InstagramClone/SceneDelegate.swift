//
//  SceneDelegate.swift
//  InstagramClone
//
//  Created by 김초원 on 2023/01/19.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = .systemBackground
        window?.tintColor = .label
        window?.rootViewController = TabBarController()
        window?.makeKeyAndVisible()
    }

}

