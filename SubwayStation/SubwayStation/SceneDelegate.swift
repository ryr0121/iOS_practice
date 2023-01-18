//
//  SceneDelegate.swift
//  SubwayStation
//
//  Created by 김초원 on 2023/01/18.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let winddowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: winddowScene)
        window?.backgroundColor = .systemBackground
        window?.rootViewController = UINavigationController(rootViewController: SubwaySearchViewController())
        window?.makeKeyAndVisible()
    }

}

