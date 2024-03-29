//
//  SceneDelegate.swift
//  TaskListApp
//
//  Created by horze on 11.02.2024.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    private lazy var storageManager = StorageManager.shared

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: TaskListViewController())
        
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        StorageManager.shared.saveContext()
    }


}

