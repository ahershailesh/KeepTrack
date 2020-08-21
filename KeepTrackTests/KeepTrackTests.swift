//
//  KeepTrackTests.swift
//  KeepTrackTests
//
//  Created by Shailesh Aher on 19/08/20.
//  Copyright © 2020 Shailesh Aher. All rights reserved.
//

import XCTest
@testable import KeepTrack

class KeepTrackTests: XCTestCase {

    private let database = FBDatabaseService(path: "test")
    
//    override class func setUp() {
//        super.setUp()
//        let filePath = Bundle(for: type(of: self)).path(forResource: "RunningActivity", ofType: "json")
//        let data = FileManager.default.contents(atPath: filePath!)
//        let activities = try! JSONDecoder().decode([RunningActivity].self, from: data!)
//        activities.forEach {
//            database.save(object: $0, errorBlock: nil)
//        }
//    }
//
//    override class func tearDown() {
//        super.tearDown()
//        database.delete(errorBlock: nil)
//    }
    
    func testRunningActivitySaving() throws {
        let runningActivity = RunningActivity(distance: 8,
                                                     startTime: "1",
                                                     endTime: "2",
                                                     rounds: 10,
                                                     dayTime: .afternoon,
                                                     note: "My Note")
        let expectations = XCTestExpectation(description: "should be save on the database without error")
        database.save(object: runningActivity) { (error) in
            if error == nil {
                expectations.fulfill()
            }
        }
        wait(for: [expectations], timeout: 2)
    }
    
    func testDelete() {
        let dataAvailableExpectation = XCTestExpectation(description: "Data should be available")
        let dataDeleteExpectation = XCTestExpectation(description: "Data should get delete")
        database.getAll { (activities: [RunningActivity], error) in
            if let firstActivity = activities.first {
                dataAvailableExpectation.fulfill()
                self.database.delete(object: firstActivity) { (error) in
                    if error == nil {
                        dataDeleteExpectation.fulfill()
                    }
                }
            }
        }
        wait(for: [dataAvailableExpectation, dataDeleteExpectation], timeout: 10)
    }
    
}
