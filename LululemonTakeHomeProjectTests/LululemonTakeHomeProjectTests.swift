//
//  LululemonTakeHomeProjectTests.swift
//  LululemonTakeHomeProjectTests
//
//  Created by Samuel Adama on 1/6/23.
//

import XCTest
@testable import LululemonTakeHomeProject

final class LululemonTakeHomeProjectTests: XCTestCase {
    var sut: HomeView!
    var persistenceManager: GarmentStorePersistentManager!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        sut = HomeView()
        persistenceManager = GarmentStorePersistentManager()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        persistenceManager = nil
        try super.tearDownWithError()
    }
    
    func testAlphabeticalSortingGarments() throws {
        
        var arrayToSort: [TestModel] = [TestModel(name: "Tom", date: "2023-01-07"), TestModel(name: "Hank", date: "2023-01-07"), TestModel(name: "Alan", date: "2023-01-07" )]
        let expectedResults: [TestModel] = [TestModel(name: "Alan", date: "2023-01-07"), TestModel(name: "Hank", date: "2023-01-07" ), TestModel(name: "Tom", date: "2023-01-07")]
        arrayToSort.sort {
            $0.name.lowercased() < $1.name.lowercased()
        }
        XCTAssertEqual(arrayToSort, expectedResults)
    }
    
    func testDateCreatedSortingGarments() throws {
        
        var arrayToSort: [TestModel] = [TestModel(name: "Tom", date: "2025-09-07"), TestModel(name: "Alex", date: "2024-05-10"), TestModel(name: "Zico", date: "2023-02-08")]
        let expectedResults: [TestModel] = [TestModel(name: "Zico", date: "2023-02-08"), TestModel(name: "Alex", date: "2024-05-10"), TestModel(name: "Tom", date: "2025-09-07")]
        arrayToSort.sort {
            $0.date < $1.date
        }
        XCTAssertEqual(arrayToSort, expectedResults)
    }
    
    func testfetchingGarment() throws {
        
        persistenceManager.addNewGarment("Belt")
        let allGarments = persistenceManager.getAllGarments()
        
        XCTAssertNotNil(allGarments)
    }
    
    func testAddingGarment() throws {
        persistenceManager.addNewGarment("Jacket")
        let allGarments = persistenceManager.getAllGarments()
        
        let index = allGarments.count - 1

        XCTAssertEqual(allGarments[index].name, "Jacket")
    }
    
    func testRemoveAllGarment() throws {
        persistenceManager.getAllGarments().forEach { index in
            persistenceManager.deleteGarment(clothes: index)
        }
        
        let allGarments = persistenceManager.getAllGarments()
        
        XCTAssertEqual(allGarments.count, 0, "Should be nil")
    }
}


struct TestModel: Equatable {
    let name: String
    let date: String
}
