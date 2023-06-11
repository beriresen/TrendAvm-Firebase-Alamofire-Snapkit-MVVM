//
//  AppDelegate.swift
//  NewTrendAvm
//
//  Created by Berire Şen Ayvaz on 10.06.2023.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure() //Uygulama başlatıldığında bu yöntem çağrılır.FirebaseApp.configure() Firebase SDK'sını yapılandırır ve Firebase servislerine bağlantı sağlar.AppDelegate, uygulamanın başından sonuna kadar var olan bir nesnedir. Bu nedenle, Firebase yapılandırmasını AppDelegate içinde yaparak, Firebase yapılandırmasının uygulamanın tüm yaşam döngüsü boyunca sürdürülmesini sağlayabilirsiniz.

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

