//
//  ReaddleAssignmentUITests.swift
//  ReaddleAssignmentUITests
//
//  Created by Ahmed Mgua on 06/06/2022.
//

import XCTest

class ReaddleAssignmentUITests: XCTestCase {

    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false

        app.launchArguments = ["MockData"]
        
        app.launch()
    }

    override func tearDownWithError() throws {
        app.terminate()
        try super.tearDownWithError()
    }

    func testUIElementsExistOnLaunch() throws {
        let header = app.navigationBars["Readdle"]
        let layoutToggle = app.navigationBars.buttons["toggle-list-button"]
        let collectionView = app.collectionViews["files-collection-view"]
        let mockFileIcon = app.cells["file-icon"]
        let iconImage = app.images["file-image"]
        let filename = app.staticTexts["file.pdf"]
        
        
        XCTAssert(header.waitForExistence(timeout: 5))
        XCTAssert(layoutToggle.waitForExistence(timeout: 5))
        XCTAssert(collectionView.waitForExistence(timeout: 5))
        XCTAssert(mockFileIcon.waitForExistence(timeout: 5))
        XCTAssert(iconImage.waitForExistence(timeout: 5))
        XCTAssert(filename.waitForExistence(timeout: 5))
    }
    
    func testSwitchingLayoutChangesButtonIcon() throws {
        let listToggle = app.navigationBars.buttons["toggle-list-button"]
        _ = listToggle.waitForExistence(timeout: 5)
        
        listToggle.tap()
        XCTAssertFalse(listToggle.exists)
        
        let gridToggle = app.navigationBars.buttons["toggle-grid-button"]
        XCTAssert(gridToggle.waitForExistence(timeout: 5))
        gridToggle.tap()
        XCTAssertFalse(gridToggle.exists)
        XCTAssert(listToggle.waitForExistence(timeout: 5))
    }
}
