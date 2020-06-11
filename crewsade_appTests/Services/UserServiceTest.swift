//
//  UserServiceTest.swift
//  crewsade_appTests
//
//  Created by Hugo Lefrant on 10/06/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import XCTest
@testable import crewsade_app

class UserServiceTest: XCTestCase {

    // FIXME: getUserInformation() asynchrone donc le test executé en synchrone va se finir de suite sans tester
    func testGetInformationsUser(){
        UserService().getUserInformations(id: "1z38Vvou88RUmFUDnH109tQeqwX2"){user in
            XCTAssertEqual("hugo2", user?.username)
            XCTAssertEqual(URL(string:"https://firebasestorage.googleapis.com/v0/b/crewsade-f8c30.appspot.com/o/user_profiles%2F1z38Vvou88RUmFUDnH109tQeqwX2%2Fprofile_picture?alt=media&token=d7928ef1-a63b-4b56-a525-3e6057339939"), user?.Image)
            XCTAssertEqual(["Challenge":6,"Victory":3, "Tricks": 0, "Spots":0], user?.stats)
        }
    }
}
