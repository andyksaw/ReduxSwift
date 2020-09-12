//
//  StoreTests.swift
//  ReduxSwiftTests
//
//  Created by Andy Saw on 2020/09/13.
//  Copyright © 2020 andysaw. All rights reserved.
//

import XCTest

@testable import ReduxSwift

class StoreTests: XCTestCase {

    func testStoreUsesInitialState() {
        struct State: StoreStorable {
            let foo: String
        }
        let initialState = State(foo: "bar")
        let store = Store<State>(initialState, reducers: [])

        XCTAssertEqual(store.state, initialState)
    }
}
