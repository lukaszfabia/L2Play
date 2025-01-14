//
//  LoginViewUITests.swift
//  L2PlayUITests
//
//  Created by Lukasz Fabia on 14/01/2025.
//

import XCTest

final class LoginViewUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        
        let language = "en"
        let locale = Locale(identifier: language)
                
        app.launchArguments.append(contentsOf: ["-AppleLanguages", "(\(locale.identifier))"])
        
        let loginButton = app.buttons["Login"]
        XCTAssertTrue(loginButton.exists, "Login button not found")
        loginButton.tap()
        
        
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testLoginViewElementsExist() throws {
        let login = app.textFields["Login"]
        login.tap()
        
        XCTAssertTrue(app.staticTexts["Welcome Label"].exists, "Welcome label not found")
        XCTAssertTrue(app.staticTexts["Back Label"].exists, "Back label not found")
        XCTAssertTrue(app.textFields["Email address"].exists, "Email address field not found")
        XCTAssertTrue(app.secureTextFields["Password"].exists, "Password field not found")
        XCTAssertTrue(app.buttons["Sign in button"].exists, "Sign In button not found")
        XCTAssertTrue(app.buttons["Continue with Google button"].exists, "Google button not found")
        XCTAssertTrue(app.staticTexts["Terms and Privacy Policy Agreement"].exists, "Terms agreement text not found")
    }

    func testLoginWithEmptyFields() throws {
        let login = app.textFields["Login"]
        login.tap()
        
        let signInButton = app.buttons["Sign in button"]
        XCTAssertTrue(signInButton.exists, "Sign In button not found")
        XCTAssertFalse(signInButton.isEnabled, "Sign In button should be disabled for empty fields")
    }

    func testLoginWithInvalidData() throws {
        let login = app.textFields["Login"]
        login.tap()
        
        let emailField = app.textFields["Email address"]
        let passwordField = app.secureTextFields["Password"]
        let signInButton = app.buttons["Sign in button"]
        
        emailField.tap()
        emailField.typeText("invalid-email")
        
        passwordField.tap()
        passwordField.typeText("123")
        
        XCTAssertTrue(signInButton.isEnabled, "Sign In button should be enabled for non-empty fields")
        signInButton.tap()
        
        let errorMessage = app.staticTexts.matching(identifier: "Error Message").firstMatch
        XCTAssertTrue(errorMessage.exists, "Error message should appear for invalid credentials")
    }

    func testNavigateToRegisterView() throws {
        let login = app.textFields["Login"]
        login.tap()
        
        let registerLink = app.buttons["Don't have an account link"]
        XCTAssertTrue(registerLink.exists, "Register link not found")
        registerLink.tap()
        
        let registerView = app.navigationBars["Register"]
        XCTAssertTrue(registerView.exists, "Register view not displayed")
    }
}
