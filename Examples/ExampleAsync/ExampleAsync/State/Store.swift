//
//  Store.swift
//  ExampleAsync
//
//  Created by Andy Saw on 2018/10/29.
//  Copyright © 2018 andyksaw. All rights reserved.
//

import ReduxSwift

struct AppState: StoreState {
    var isLoading: Bool
    var people: [Person]
}

let initialState = AppState(
    isLoading: true,
    people: []
)

let store = Store(initialState, reducers: [
//    AnyStoreReducer<AppState>(PeopleReducer())
])
