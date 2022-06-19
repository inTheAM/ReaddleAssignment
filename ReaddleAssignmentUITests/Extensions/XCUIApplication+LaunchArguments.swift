//
//  XCUIApplication+LaunchArguments.swift
//  ReaddleAssignmentUITests
//
//  Created by Ahmed Mgua on 19/06/2022.
//

import XCTest

extension XCUIApplication {
    func launch(withArguments arguments: [String]) {
        launchArguments = arguments
        launch()
    }
}
