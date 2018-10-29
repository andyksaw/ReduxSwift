//
//  LoggingMiddleware.swift
//  ExampleMiddleware
//
//  Created by Andy Saw on 2018/10/29.
//  Copyright © 2018 andyksaw. All rights reserved.
//

import ReduxSwift

public class LoggingMiddleware: StoreMiddleware {
    override func handle<Action, State>(action: Action, store: Store<State>) -> Action? where Action: StoreAction, State: StoreState {
        print("State: \(store.state)")
        print("Dispatching action: \(action.payload)")
        return action
    }

    public override init() {
        super.init()
    }
}
