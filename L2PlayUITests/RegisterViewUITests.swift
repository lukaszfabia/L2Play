//
//  RegisterViewUITests.swift
//  L2PlayUITests
//
//  Created by Lukasz Fabia on 14/01/2025.
//

import XCTest
@testable import L2Play

extension XCUIElement {
    func clearText() {
        guard let stringValue = self.value as? String else { return }
        if !stringValue.isEmpty {
            tap()
            let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
            typeText(deleteString)
        }
    }
}


final class RegisterViewUITests: XCTestCase {
    
    private var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        
        let language = "en"
        let locale = Locale(identifier: language)
        app.launchArguments.append(contentsOf: ["-AppleLanguages", "(\(locale.identifier))"])
        
        app.launch()
        
        let signup = app.buttons["Sign Up"]
        XCTAssertTrue(signup.exists, "Sign up button not found")
        signup.tap()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    func testRegisterViewElementsExist() throws {
        XCTAssertTrue(app.staticTexts["Get started with Email"].exists, "Get Started with Email label not found")
        XCTAssertTrue(app.textFields["First name"].exists, "First name field not found")
        XCTAssertTrue(app.textFields["Last name"].exists, "Last name field not found")
        XCTAssertTrue(app.textFields["Email address"].exists, "Email address field not found")
        XCTAssertTrue(app.secureTextFields["Password"].exists, "Password field not found")
        XCTAssertTrue(app.buttons["SubmitButton"].exists, "Sign Up button not found")
        XCTAssertTrue(app.buttons["Sign up with Google"].exists, "Google sign up button not found")
        XCTAssertTrue(app.staticTexts["Terms and privacy policy agreement"].exists, "Terms and privacy policy not found")
        XCTAssertTrue(app.buttons["Login link"].exists, "Already have an account link not found")
        XCTAssertTrue( app.buttons["Password requirements"].exists, "Password requirements not found")
        
    }
    
    
    func testDisableSubmitButton() throws {
        let submitBtn = app.buttons["SubmitButton"]
        
        XCTAssertFalse(submitBtn.isEnabled, "Submit button should be disabled if input text is empty")
        
        let firstNameField = app.textFields["First name"]
        let lastNameField = app.textFields["Last name"]
        let emailField = app.textFields["Email address"]
        let passwordField = app.secureTextFields["Password"]
        
        firstNameField.tap()
        firstNameField.typeText("Joe")
        
        lastNameField.tap()
        lastNameField.typeText("Doe")
        
        emailField.tap()
        emailField.typeText("joe.doe@example.com")
        
        passwordField.tap()
        passwordField.typeText("StrongPass123!")
        
        XCTAssertTrue(submitBtn.isEnabled, "Submit button should be enabled if all input text is valid")
        
        firstNameField.tap()
        firstNameField.clearText()
        XCTAssertFalse(submitBtn.isEnabled, "Submit button should be disabled if first name is empty \(submitBtn.isEnabled)")
        
        firstNameField.typeText("Joe")
        XCTAssertTrue(submitBtn.isEnabled, "Submit button should be enabled after filling all fields correctly")
    }
    
    func testPasswordRequirements() throws {
        let accordion = app.buttons["Password requirements"]
        XCTAssertTrue(accordion.exists, "Password requirements accordion not found")

        accordion.tap()
    }

    
    func testShowPassword() throws {
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.secureTextFields["Password"].tap()
    
        let eye = elementsQuery.buttons["Password"]

        XCTAssertTrue(eye.exists, "Show password button not found")
      
        let passwordField0 = app.secureTextFields["Password"]
        
        XCTAssertTrue(passwordField0.exists, "Password field not found")
        
        passwordField0.typeText("P@ssw0rdzpwr")
        
        eye.tap()
        
        let passwordField1 = app.textFields["Password"]
        
        XCTAssertFalse(passwordField0.exists, "Password field should not be secure now")
        XCTAssertTrue(passwordField1.exists, "Password field should be visible now")
        
    }
    
    func testSignUpOut()  throws {
        let name = "Mary"
        let lastname = "Jane"
        let email = "mary.jane@gmail.com"
        let password = "P@ssw0rd!@2003"

        
        let firstNameField = app.textFields["First name"]
        XCTAssertTrue(firstNameField.exists, "First name field not found")
        
        
        let lastNameField = app.textFields["Last name"]
        XCTAssertTrue(lastNameField.exists, "Last name field not found")
        
        let emailField = app.textFields["Email address"]
        XCTAssertTrue(emailField.exists, "Email address field not found")
        
        let passwordField = app.secureTextFields["Password"]
        XCTAssertTrue(passwordField.exists, "Password field not found")
        
        firstNameField.tap()
        firstNameField.typeText(name)
        
        lastNameField.tap()
        lastNameField.typeText(lastname)
        
        emailField.tap()
        emailField.typeText(email)
        
        passwordField.tap()
        passwordField.typeText(password)
        
        let submit = app.buttons["SubmitButton"]
        XCTAssertTrue(submit.exists, "Sign Up button not found")
        
        submit.tap()

        
        let welcomeNavigationBar = app.navigationBars["Welcome, \(name)!"]
        let exists = welcomeNavigationBar.waitForExistence(timeout: 10)
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

        let removeBtn = collectionViewsQuery.buttons["Remove account"].staticTexts["Remove account"]
        
        XCTAssertTrue(removeBtn.exists, "No delete account button")
        
        removeBtn.tap()
        
        let confirmEmail = app2.textFields["Email..."]
        
        XCTAssertTrue(confirmEmail.exists, "No confirm field")
        
        confirmEmail.tap()
        confirmEmail.typeText(email)
        
        let remove = app2.buttons["Delete"].images["xmark"]
        
        XCTAssertTrue(remove.exists, "No confirm delete button")
        // cancel
        remove.tap()
        // and try again
        app2.buttons["Delete"].images["xmark"].tap()
        
        
        let lastDelete = app2.alerts["Confirm Deletion"].scrollViews.otherElements.buttons["Delete"]
        
        XCTAssertTrue(lastDelete.exists, "No last delete confirmation")
        
        lastDelete.tap()
            
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 11.0, tvOS 13.0, watchOS 7.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
}
