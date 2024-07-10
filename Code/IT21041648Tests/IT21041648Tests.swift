//
//  IT21041648Tests.swift
//  IT21041648Tests
//
//  Created by Isuru Herath on 2024-04-19.
//

import XCTest
@testable import IT21041648

final class IT21041648Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

class ViewControllerTests: XCTestCase {
    var viewController: ViewController!
    
    override func setUp() {
        super.setUp()
        viewController = ViewController()
        _ = viewController.view // Load the view hierarchy
    }
    
    override func tearDown() {
        super.tearDown()
        viewController = nil
    }
    
    func testCreateItem() {
        let initialItemCount = viewController.models.count
        
        viewController.createItem(name: "Test Device", desc: "Test Description")
        
        XCTAssertEqual(viewController.models.count, initialItemCount + 1)
    }
    
    func testUpdateItem() {
        let item = Device(context: viewController.context)
        item.name = "Old Name"
        item.issue = "Old Description"
        item.fixed = false
        item.dateGiven = Date()
        
        viewController.models.append(item)
        
        viewController.updateItem(item: item, newname: "New Name", newDesc: "New Description")
        
        XCTAssertEqual(item.name, "New Name")
        XCTAssertEqual(item.issue, "New Description")
    }
    
    func testDeleteItem() {
        let item = Device(context: viewController.context)
        item.name = "Test Device"
        item.issue = "Test Description"
        item.fixed = false
        item.dateGiven = Date()
        
        viewController.models.append(item)
        let initialItemCount = viewController.models.count
        
        viewController.deleteItem(item: item)
        
        XCTAssertEqual(viewController.models.count, initialItemCount - 1)
    }
    

}
