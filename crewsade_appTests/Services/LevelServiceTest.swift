//
//  LevelServiceTest.swift
//  crewsade_appTests
//
//  Created by Hugo Lefrant on 10/06/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import XCTest
@testable import crewsade_app

class LevelServiceTest: XCTestCase {
    func testGetLevels(){
        LevelService().getLevels(){ levels in
            XCTAssertEqual("New", levels)
        }
    }
}
