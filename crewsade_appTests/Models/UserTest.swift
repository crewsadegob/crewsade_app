//
//  UserTest.swift
//  crewsade_appTests
//
//  Created by Hugo Lefrant on 10/06/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//
//
import XCTest
@testable import crewsade_app
class UserTest: XCTestCase {

    
    func testInitUser(){
        let user = User(username: "Hugo", Image: URL(string: "https://asklarry.fr/img/refresha-citron-vert-starbucks.jpg"), id: "djf45bj2", stats: ["Victory": 3, "Challenge": 15])
        
        XCTAssertEqual("Hugo", user.username)
         XCTAssertEqual(URL(string: "https://asklarry.fr/img/refresha-citron-vert-starbucks.jpg"), user.Image)
         XCTAssertEqual("djf45bj2", user.id)
         XCTAssertEqual(["Victory": 3, "Challenge": 15], user.stats)
        
    }
}
