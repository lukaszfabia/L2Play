//
//  LoginViewUITests.swift
//  L2PlayUITests
//
//  Created by Lukasz Fabia on 14/01/2025.
//

import XCTest
@testable import L2Play

final class LoginViewUITests: XCTestCase {
    
    private var app: XCUIApplication!
    
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        
        let language = "en"
        let locale = Locale(identifier: language)
        app.launchArguments.append(contentsOf: ["-AppleLanguages", "(\(locale.identifier))"])
        
        app.launch()
        
        let loginButton = app.buttons["Login"]
        XCTAssertTrue(loginButton.exists, "Login button not found")
        loginButton.tap()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    func testLoginViewElementsExist() throws {
        XCTAssertTrue(app.staticTexts["Welcome Label"].exists, "Welcome label not found")
        XCTAssertTrue(app.staticTexts["Back Label"].exists, "Back label not found")
        XCTAssertTrue(app.textFields["Email address"].exists, "Email address field not found")
        XCTAssertTrue(app.secureTextFields["Password"].exists, "Password field not found")
        XCTAssertTrue(app.buttons["signInButton"].exists, "Sign In button not found")
        XCTAssertTrue(app.buttons["Continue with Google button"].exists, "Google button not found")
        XCTAssertTrue(app.staticTexts["Terms and Privacy Policy Agreement"].exists, "Terms agreement text not found")
        XCTAssertTrue(app.buttons["Forgot password link"].exists, "Forgot password link not found")
        XCTAssertTrue(app.buttons["Don't have an account link"].exists, "Don't have an account link not found")
    }
    
    func testLoginWithEmptyFields() throws {
        let signInButton = app.buttons["signInButton"]
        
        XCTAssertFalse(signInButton.isEnabled, "It should be disabled until all fields are filled")
    }
    
    func testLoginFields() throws {
        let joeDoeExampleComTextField = app.textFields["Email address"]
        XCTAssertTrue(joeDoeExampleComTextField.exists, "Email field should exist")
        joeDoeExampleComTextField.tap()
        joeDoeExampleComTextField.typeText("xdxdxdxd")
        
        let loginSecureTextField = app.secureTextFields["Password"]
        XCTAssertTrue(loginSecureTextField.exists, "Password field should exist")
        loginSecureTextField.tap()
        loginSecureTextField.typeText("123")
        
        let signInButton = app.buttons["signInButton"]
        
        XCTAssertTrue(signInButton.exists, "Sign In button should exist")
        XCTAssertTrue(signInButton.isEnabled, "Sign In button should be enabled for non-empty fields")
    }
    
    
    func testNavigateToRestorePass() throws {
        let forgotPass = app.buttons["Forgot password link"]
        XCTAssertTrue(forgotPass.exists, "Not found forgot password")
        
        forgotPass.tap()
        
        let back = app.navigationBars["Password restoring"].buttons["Login"]
        
        XCTAssertTrue(back.exists, "Can't back to main")
        
        back.tap()
    }
    
    func testNavigateToNoAcc() throws {
        let noacc = app.scrollViews.otherElements.buttons["Don't have an account link"]
        
        XCTAssertTrue(noacc.exists, "No signup option")
        
        noacc.tap()
        
        let back = app.navigationBars["Create Account"].buttons["Login"]
        
        XCTAssertTrue(back.exists, "No back")
        
        back.tap()
    }
    
    
    func testLogInOut() throws {
        let email = "kontodologowania@gmail.com"
        let password = "P@ssw0rd"
        let name = "Log"
        
        let joeDoeExampleComTextField = app.textFields["Email address"]
        XCTAssertTrue(joeDoeExampleComTextField.exists, "Email field should exist")
        joeDoeExampleComTextField.tap()
        joeDoeExampleComTextField.typeText(email)
        
        let loginSecureTextField = app.secureTextFields["Password"]
        XCTAssertTrue(loginSecureTextField.exists, "Password field should exist")
        loginSecureTextField.tap()
        loginSecureTextField.typeText(password)
        
        let signInButton = app.buttons["signInButton"]
        XCTAssertTrue(signInButton.exists, "Sign In button should exist")
        XCTAssertTrue(signInButton.isEnabled, "Sign In button should be enabled for non-empty fields")
        signInButton.tap()
        
        let welcomeNavigationBar = app.navigationBars["Welcome, \(name)!"]
        let exists = welcomeNavigationBar.waitForExistence(timeout: 4)
        XCTAssertTrue(exists, "Should navigate to the welcome screen after sign-in")
    
        let profile = app.tabBars["Tab Bar"].buttons["Profile"]
        
        XCTAssertTrue(profile.exists, "No profile found")
            
        profile.tap()
        
        let app2 = app!
        let settings = app2.navigationBars["Profile"].buttons["gear"]
        
        XCTAssertTrue(settings.exists, "No settings found")
        
        settings.tap()
        
        let collectionViewsQuery = app2.collectionViews
        collectionViewsQuery.firstMatch.swipeUp()
        
        let logout = collectionViewsQuery.buttons["Logout"]
        
        XCTAssertTrue(logout.exists, "No logout button")
        
        logout.tap()
        
        app.alerts["Are you sure to logout?"].scrollViews.otherElements.buttons["Logout"].tap()
                
        
    }

}
