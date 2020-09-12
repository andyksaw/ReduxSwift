//
//  AnyStoreReducer.swift
//  ReduxSwift
//
//  Created by Andy Saw on 2020/09/13.
//  Copyright © 2020 andysaw. All rights reserved.
//

public final class AnyStoreReducer<State: StoreStorable>: StoreStateReducable {

    private let _reduce: (StoreActionable, State) -> State

    public init<Reducer: StoreStateReducable>(_ reducer: Reducer) where Reducer.State == State {
        self._reduce = reducer.reduce(with:currentState:)
    }

    public func reduce(with action: StoreActionable, currentState: State) -> State {
        _reduce(action, currentState)
    }
}
