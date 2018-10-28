//
//  Store.swift
//  ReduxSwiftExamples
//
//  Created by andysaw on 2018/10/29.
//  Copyright © 2018 andysaw. All rights reserved.
//

import ReduxSwift

struct AppState: StoreState {
    var number: Int
}

let initialState = AppState(number: 0)
let store = Store<AppState>(initialState, reducers: [
    CounterReducer()
    ])
