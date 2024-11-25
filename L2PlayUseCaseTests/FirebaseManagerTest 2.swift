//
//  FirebaseManager.swift
//  L2PlayTests
//
//  Created by Lukasz Fabia on 24/11/2024.
//

import XCTest
@testable import L2Play

final class FirebaseManagerTest: XCTestCase {
    var manager: FirebaseManager!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        
        
        manager = FirebaseManager()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        manager = nil
        
        super.tearDown()
    }

    func testFindAll() {
       
        let expectation = self.expectation(description: "FindAll completion handler is called")
        
        manager.findAll(collection: "games") { (result: Result<[Game], Error>) in
            switch result {
            case .success(let games):
       
                XCTAssertFalse(games.isEmpty, "Games list should not be empty")
                
                XCTAssertNotNil(games.first?.name, "First game should have a name")
                
            case .failure(let error):

                XCTFail("Failed to fetch games: \(error.localizedDescription)")
            }
            
      
            expectation.fulfill()
        }
        

        waitForExpectations(timeout: 5, handler: nil)
    }


    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
