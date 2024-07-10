//
//  IT21041648UITests.swift
//  IT21041648UITests
//
//  Created by Isuru Herath on 2024-04-19.
//

import XCTest

final class IT21041648UITests: XCTestCase {
    
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testButtonExists() throws {
        let button = app.buttons["Developer Info"]
        XCTAssertTrue(button.exists, "Button 'Developer Info' should exist")
    }
    
    func testTableViewExists() throws {
        let tableView = app.tables.element
        XCTAssertTrue(tableView.exists, "Table view should exist")
    }

    func testAddButtonExists() throws {
        let addButton = app.navigationBars.buttons["Add"]
        XCTAssertTrue(addButton.exists, "Add button should exist in the navigation bar")
    }



    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    

}


