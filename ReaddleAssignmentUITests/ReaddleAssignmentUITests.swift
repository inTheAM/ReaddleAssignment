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
        let fileIcon = app.cells["file-icon-vertical"]
        let iconImage = app.images["file-image"]
        let filename = app.staticTexts["file.pdf"]
        
        
        XCTAssert(header.waitForExistence(timeout: 5))
        XCTAssert(layoutToggle.waitForExistence(timeout: 5))
        XCTAssert(collectionView.waitForExistence(timeout: 5))
        XCTAssert(fileIcon.waitForExistence(timeout: 5))
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
    
    func testSwitchingLayoutChangesCollectionViewLayout() throws {
        let listToggle = app.navigationBars.buttons["toggle-list-button"]
        _ = listToggle.waitForExistence(timeout: 5)
        
        let vFileIcon = app.cells["file-icon-vertical"]
        XCTAssert(vFileIcon.waitForExistence(timeout: 5))
        listToggle.tap()
        XCTAssertFalse(vFileIcon.exists)
        
        let hFileIcon = app.cells["file-icon-horizontal"]
        XCTAssert(hFileIcon.waitForExistence(timeout: 5))
        
        
        let gridToggle = app.navigationBars.buttons["toggle-grid-button"]
        _ = gridToggle.waitForExistence(timeout: 5)
        gridToggle.tap()
        
        XCTAssertFalse(hFileIcon.exists)
        XCTAssert(vFileIcon.waitForExistence(timeout: 5))
    }
}
