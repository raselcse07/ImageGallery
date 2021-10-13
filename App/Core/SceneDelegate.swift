//
//  SceneDelegate.swift
//  ImageGallery
//
//  Created by Rasel on 2021/10/14.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        startFlow(windowScene: windowScene)
    }
    
    private func startFlow(windowScene: UIWindowScene) {
        // create a `UINavigationController`
        let navigationController = UINavigationController()
        // create `UIWindow` from window scene
        window = UIWindow(windowScene: windowScene)
        window?.makeKeyAndVisible()
        // set rootViewController
        window?.rootViewController = navigationController
        // start flow from coordinator
        let initialCoordinator = SplashCoordinator(navigationController: navigationController)
        initialCoordinator.start()
    }
}

