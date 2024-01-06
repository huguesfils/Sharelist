//
//  DataControllerTests.swift
//  SharelistTests
//
//  Created by Hugues Fils on 20/11/2023.
//

import XCTest
@testable import Sharelist

class DataControllerTests: XCTestCase {

    var dataController: DataController!
    var testListModel: ListModel!

    override func setUp() {
        super.setUp()

        // Initialisez votre objet DataController pour les tests
        dataController = DataController()

        // Créez une liste de test pour une utilisation dans les tests
        testListModel = ListModel(id: "testListId", title: "Test List", userId: "testUserId", listItems: [], guests: [])
    }

    override func tearDown() {
        // Nettoyez les données après chaque test
        super.tearDown()
    }

    func testAddDocument() {
        let expectation = XCTestExpectation(description: "Add document expectation")

        dataController.addDocument(testListModel) { error in
            XCTAssertNil(error)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }

    func testFetchLists() {
        let expectation = XCTestExpectation(description: "Fetch lists expectation")

        // Ajoutez une liste de test avant de la récupérer
        dataController.addDocument(testListModel) { _ in
            self.dataController.fetchLists(forUserId: "testUserId") { result in
                switch result {
                case .success(let lists):
                    XCTAssertFalse(lists.isEmpty)
                case .failure(let error):
                    XCTFail("Error fetching lists: \(error.localizedDescription)")
                }
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 10.0)
    }

    func testUpdateList() {
        let expectation = XCTestExpectation(description: "Update list expectation")

        // Ajoutez une liste de test avant de la mettre à jour
        dataController.addDocument(testListModel) { _ in
            // Récupérez l'ID de la liste ajoutée pendant le test
            guard self.testListModel.id != nil else {
                XCTFail("Test list ID not set")
                return
            }

            // Mettez à jour la liste
            var updatedList = self.testListModel
            updatedList?.title = "Updated Test List"

            self.dataController.updateList(updatedList!) { error in
                XCTAssertNil(error)
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 10.0)
    }

    func testDeleteList() {
        let expectation = XCTestExpectation(description: "Delete list expectation")

        // Ajoutez une liste de test avant de la supprimer
        dataController.addDocument(testListModel) { _ in
            // Récupérez l'ID de la liste ajoutée pendant le test
            guard let testListId = self.testListModel.id else {
                XCTFail("Test list ID not set")
                return
            }
print(testListId)
            // Supprimez la liste
            self.dataController.deleteList(withId: testListId) { error in
                XCTAssertNil(error)
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 10.0)
    }}
