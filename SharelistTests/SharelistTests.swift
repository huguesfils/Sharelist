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
    
    func testWhenAddDocuementToDbThenFetchForUpdate() {
        let expectation = XCTestExpectation(description: "Update list")
        
        // Assume that you have a list with a valid ID that you want to update
        let originalList = ListModel(title: "Original Test List", userId: "testUserId", listItems: [], guests: [])
        let dataController = DataController()
        dataController.addDocument(originalList) { error in
            XCTAssertNil(error, "Error adding document for update")
            
            // Fetch the list to get the updated version with a new ID
            self.dataController.fetchLists(forUserId: "testUserId") { result in
                switch result {
                case .success(let lists):
                    guard let updatedList = lists.first else {
                        XCTFail("Error fetching updated list for update")
                        return
                    }
                    
                    var updatedListCopy = updatedList
                    updatedListCopy.title = "Updated Test List"
                    
                    // Now update the list with the new ID
                    self.dataController.updateList(updatedListCopy) { error in
                        XCTAssertNil(error, "Error updating list")
                        expectation.fulfill()
                    }
                case .failure(let error):
                    XCTFail("Error fetching lists for update: \(error.localizedDescription)")
                }
            }
        }
       
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testDeleteList() {
        sleep(2)
        
        let expectation = XCTestExpectation(description: "Delete list")

        let listToDelete = ListModel(title: "Test List to Delete", userId: "testUserId", listItems: [], guests: [])
        let dataController = DataController()
        dataController.addDocument(listToDelete) { error in
            XCTAssertNil(error, "Error adding document for delete")
sleep(2)
            self.dataController.fetchLists(forUserId: "testUserId") { result in
                switch result {
                case .success(let lists):
                    
                    if let listIdToDelete = lists.first?.id {
                        print(lists.count) // est appelé 2 fois. 1er appel = 1, 2ème appel = 0
                        print(listIdToDelete)

                        sleep(2)
                        self.dataController.deleteList(withId: listIdToDelete) { error in
                            if let error = error {
                                XCTFail("Error deleting list: \(error.localizedDescription)")
                            } else {
                                print("fulfill")
                                expectation.fulfill()
                            }
                        }
                    } else {
                        // Aucune liste à supprimer
                        print("No lists found to delete")
                        expectation.fulfill()
                    }

                case .failure(let error):
                    XCTFail("Error fetching lists for delete: \(error.localizedDescription)")
                }
            }
        }

        wait(for: [expectation], timeout: 10.0)
    }
}
