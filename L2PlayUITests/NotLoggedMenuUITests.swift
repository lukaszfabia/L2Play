//
//  NotLoggedMenu.swift
//  L2PlayUITests
//
//  Created by Lukasz Fabia on 14/01/2025.
//

import XCTest

final class NotLoggedMenuUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        let language = "en"
        let locale = Locale(identifier: language)
                
        app.launchArguments.append(contentsOf: ["-AppleLanguages", "(\(locale.identifier))"])
        app.launch()
        
    }

    override func tearDownWithError() throws {
        app = nil
    }


    func testNotLoggedMenuElementsExist() throws {
        XCTAssertTrue(app.buttons["Continue with Google button"].exists, "Google button not found")
        XCTAssertTrue(app.buttons["Sign Up"].exists, "Sign Up button not found")
        XCTAssertTrue(app.buttons["Login"].exists, "Login button not found")
    }

    func testNavigateToRegisterView() throws {
        let signUpButton = app.buttons["Sign Up"]
        XCTAssertTrue(signUpButton.exists, "Sign Up button not found")
        signUpButton.tap()
        

        let registerView = app.navigationBars["Create Account"]
        XCTAssertTrue(registerView.exists, "Register view not displayed after tapping Sign Up")
    }

    func testNavigateToLoginView() throws {
        let loginButton = app.buttons["Login"]
        XCTAssertTrue(loginButton.exists, "Login button not found")
        loginButton.tap()
        
        let loginView = app.navigationBars["Login"]

        XCTAssertTrue(loginView.exists, "Login view not displayed after tapping Login")
    }
}
