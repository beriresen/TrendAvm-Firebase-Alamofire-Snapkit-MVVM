//
//  LoginVCUnitTests.swift
//  NewTrendAvmTests
//
//  Created by Berire Şen Ayvaz on 14.06.2023.
//

import XCTest
@testable import NewTrendAvm


final class LoginVCUnitTests: XCTestCase {

    var loginVC = LoginVC()
    var tabBarController = UITabBarController()
    
    
    override func setUp() {
        super.setUp()
        loginVC = LoginVC()
        tabBarController = UITabBarController()
        
    }
    
    
    func testLoginToApp_SuccessfulLogin() {
        
        loginVC.txtUsername.text = "beriresen@gmail.com"  //test verileri
        loginVC.txtPassword.text = "123456"
        
        
        let vc1 = UIViewController()
        let vc2 = UIViewController()
        let vc3 = UIViewController()
        let vc4 = UIViewController()
        let viewControllers = [vc1, vc2, vc3,vc4]
        
        loginVC.loginToApp()         // Test edilen metodunu çağır
        
        tabBarController.setViewControllers(viewControllers, animated: false) // Tab bar kontrolcüsü için view controller'ları ayarla
        XCTAssertEqual(tabBarController.viewControllers?.count, viewControllers.count)
        let expectedTintColor = UIColor(named: "trendOrange")// Tab bar'ın tint rengini doğrula
        tabBarController.tabBar.tintColor = expectedTintColor
        XCTAssertEqual(tabBarController.tabBar.tintColor, expectedTintColor)
        let expectedBadgeValue = "5"  // Belirli bir sekmenin badge değerini doğrula
        tabBarController.tabBar.items?[2].badgeValue = expectedBadgeValue
        XCTAssertEqual(tabBarController.tabBar.items?[2].badgeValue, expectedBadgeValue)
        
    }

}
