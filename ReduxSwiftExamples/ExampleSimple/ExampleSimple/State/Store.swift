//
//  Store.swift
//  ReduxSwiftExamples
//
//  Created by Andy Saw on 2018/10/28.
//  Copyright © 2018 andyksaw. All rights reserved.
//

import ReduxSwift

struct AppState: StoreStorable {
    var number: Int
}

let initialState = AppState(number: 0)

let store = Store(
    initialState: initialState,
    reducers: [
        AnyStoreReducer(CounterReducer()),
    ]
)
