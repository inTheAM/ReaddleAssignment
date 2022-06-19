//
//  ReaddleAssignmentUITests.swift
//  ReaddleAssignmentUITests
//
//  Created by Ahmed Mgua on 06/06/2022.
//

import XCTest

extension XCUIApplication {
    func launch(withArguments arguments: [String]) {
        launchArguments = arguments
        launch()
    }
}

class ReaddleAssignmentUITests: XCTestCase {

    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        app.terminate()
        try super.tearDownWithError()
    }
    
    func testSignInButtonExistsAndUpdatesUIOnSignInOrOut() throws {
        app.launch(withArguments: ["MockData"])
        
        // Checking existence of sign in button
        let signInButton = app.navigationBars.buttons["sign-in-button"]
        XCTAssert(signInButton.waitForExistence(timeout: 5))
        
        // Checking existence of add item button. Should be disabled
        let addItemButton = app.navigationBars.buttons["add-item-button"]
        XCTAssert(addItemButton.waitForExistence(timeout: 5))
        XCTAssertFalse(addItemButton.isEnabled)
        
        // Signing in
        signInButton.tap()
        let signInAlert = app.alerts["Sign in to your Google account?"]
        XCTAssert(signInAlert.waitForExistence(timeout: 5))
        signInAlert.buttons["OK"].tap()
        
        // Checking add item button is enabled on sign in
        XCTAssert(addItemButton.isEnabled)
        
        // Checking sign in button has changed to sign out
        let signOutButton = app.navigationBars.buttons["sign-out-button"]
        XCTAssert(signOutButton.waitForExistence(timeout: 5))
        
        // Signing out
        signOutButton.tap()
        let signOutAlert = app.alerts["Sign out?"]
        XCTAssert(signOutAlert.waitForExistence(timeout: 5))
        signOutAlert.buttons["OK"].tap()
        
        XCTAssert(signInButton.waitForExistence(timeout: 5))
        XCTAssertFalse(addItemButton.isEnabled)
    }
    
    func testLayoutButtonExistsAndUpdatesUIForLayoutChange() throws {
        app.launch(withArguments: ["MockData"])
        
        // Check layout is initialized as grid
        let vFileIcon = app.cells["file-icon-vertical"]
        XCTAssert(vFileIcon.waitForExistence(timeout: 5))
        
        // Check list toggle exists
        let listToggle = app.navigationBars.buttons["toggle-list-button"]
        XCTAssert(listToggle.waitForExistence(timeout: 5))
        // Change layout to list and check list toggle disappears
        listToggle.tap()
        XCTAssertFalse(listToggle.waitForExistence(timeout: 5))
        
        // Check layout has changed to list
        XCTAssertFalse(vFileIcon.waitForExistence(timeout: 5))
        let hFileIcon = app.cells["file-icon-horizontal"]
        XCTAssert(hFileIcon.waitForExistence(timeout: 5))
        
        // Check grid toggle exists
        let gridToggle = app.navigationBars.buttons["toggle-grid-button"]
        XCTAssert(gridToggle.waitForExistence(timeout: 5))
        
        // Change layout back to grid
        gridToggle.tap()
        
        // Check grid toggle disappears and list toggle reappears
        XCTAssertFalse(gridToggle.waitForExistence(timeout: 5))
        XCTAssert(listToggle.waitForExistence(timeout: 5))
        XCTAssertFalse(hFileIcon.waitForExistence(timeout: 5))
        XCTAssert(vFileIcon.waitForExistence(timeout: 5))
    }
    

    func testStaticUIElementsExistOnLaunch() throws {
        app.launch(withArguments: ["MockData"])
        
        let header = app.navigationBars["Files"]
        let collectionView = app.collectionViews["files-collection-view"]
        let iconImage = app.images["file-image"]
        let filename = app.staticTexts["file.pdf"]
        let deleteItem = app.buttons["Delete"]
        
        XCTAssert(header.waitForExistence(timeout: 5))
        XCTAssert(collectionView.waitForExistence(timeout: 5))
        XCTAssert(iconImage.waitForExistence(timeout: 5))
        XCTAssert(filename.waitForExistence(timeout: 5))
        filename.press(forDuration: 1)
        XCTAssert(deleteItem.waitForExistence(timeout: 5))
    }
    
    func testUIIsCorrectlyConfiguredIfPreviousSignInRestored() throws {
        app.launch(withArguments: ["SignedIn"])
        
        // Checking sign in button has changed to sign out
        let signOutButton = app.navigationBars.buttons["sign-out-button"]
        XCTAssert(signOutButton.waitForExistence(timeout: 5))
        // Checking existence of add item button. Should be disabled
        let addItemButton = app.navigationBars.buttons["add-item-button"]
        XCTAssert(addItemButton.waitForExistence(timeout: 5))
        XCTAssert(addItemButton.isEnabled)
    }
    
}
