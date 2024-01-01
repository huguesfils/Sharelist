//
//  SharelistTests.swift
//  SharelistTests
//
//  Created by Hugues Fils on 20/11/2023.
//

import XCTest
@testable import Sharelist

class DataControllerTests: XCTestCase {
    var dataController: DataController!
    
    override func setUp() {
        super.setUp()
        dataController = DataController()
    }
    
    override func tearDown() {
        dataController = nil
        super.tearDown()
    }
    
    func testAddDocument() {
        let expectation = XCTestExpectation(description: "Add document")
        
        let list = ListModel(title: "Test List", userId: "testUserId", listItems: [], guests: [])
        
        dataController.addDocument(list) { error in
            XCTAssertNil(error, "Error adding document")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFetchLists() {
        let expectation = XCTestExpectation(description: "Fetch lists")
        
        let userId = "testUserId"
        
        dataController.fetchLists(forUserId: userId) { result in
            switch result {
            case .success(let lists):
                XCTAssertEqual(lists.count, 2, "Lists count should be 2")
            case .failure(let error):
                XCTFail("Error fetching lists: \(error.localizedDescription)")
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testUpdateList() {
        let expectation = XCTestExpectation(description: "Update list")
        
        var list = ListModel(title: "Test List", userId: "testUserId", listItems: [], guests: [])
        
        dataController.addDocument(list) { error in
            XCTAssertNil(error, "Error adding document")
            
            // Mettez à jour l'ID de la liste avec l'ID renvoyé par addDocument()
            list.id = "updatedListId"
            
            self.dataController.updateList(list) { error in
                XCTAssertNil(error, "Error updating list")
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testDeleteList() {
        let expectation = XCTestExpectation(description: "Delete list")
        
        let listId = "testListId"
        
        dataController.deleteList(withId: listId) { error in
            XCTAssertNil(error, "Error deleting list")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
}
