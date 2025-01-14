//
//  RegisterViewUITests.swift
//  L2PlayUITests
//
//  Created by Lukasz Fabia on 14/01/2025.
//

import XCTest

final class RegisterViewUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testRegisterViewFieldsInteraction() throws {
        let signup = app.textFields["Sign Up"]
        signup.tap()
        
        XCTAssertTrue(app.staticTexts["Create Account"].exists, "RegisterView title not found")

        let firstNameField = app.textFields["First name"]
        XCTAssertTrue(firstNameField.exists, "First name field not found")
        firstNameField.tap()
        firstNameField.typeText("John")
        
        let lastNameField = app.textFields["Last name"]
        XCTAssertTrue(lastNameField.exists, "Last name field not found")
        lastNameField.tap()
        lastNameField.typeText("Doe")
        
        let emailField = app.textFields["Email address"]
        XCTAssertTrue(emailField.exists, "Email field not found")
        emailField.tap()
        emailField.typeText("john.doe@example.com")
        
        let passwordField = app.secureTextFields["Password"]
        XCTAssertTrue(passwordField.exists, "Password field not found")
        passwordField.tap()
        passwordField.typeText("StrongP@ssword1")

        let signUpButton = app.buttons["Sign up button"]
        XCTAssertTrue(signUpButton.exists, "Sign up button not found")
        XCTAssertTrue(signUpButton.isEnabled, "Sign up button should be enabled after entering valid data")

        signUpButton.tap()
        
        let spinner = app.otherElements["Loading spinner"]
        XCTAssertTrue(spinner.waitForExistence(timeout: 2), "Loading spinner did not appear")
        XCTAssertFalse(spinner.exists, "Loading spinner did not disappear after processing")

        let mainViewText = app.staticTexts["Main View"]
        XCTAssertTrue(mainViewText.exists, "Navigation to Main View failed after successful registration")
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
