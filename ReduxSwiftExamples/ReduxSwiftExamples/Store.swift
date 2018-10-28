//
//  Store.swift
//  ReduxSwiftExamples
//
//  Created by Andy Saw on 2018/10/28.
//  Copyright © 2018 andyksaw. All rights reserved.
//

import ReduxSwift

struct AppState: StoreState {
    var number: Int
}

let initialState = AppState(number: 0)
let store = Store<AppState>(initialState, reducers: [
    CounterReducer()
    ])
