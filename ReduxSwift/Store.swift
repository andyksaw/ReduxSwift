//
//  Store.swift
//  ReduxSwift
//
//  Created by andysaw on 2018/10/28.
//  Copyright © 2018 andysaw. All rights reserved.
//

public protocol StoreState {}

public final class Store<State> where State: StoreState {
    private var listeners: [StoreListenable] = []
    private let reducers: [StoreReducer]

    private var state: State {
        didSet {
            listeners.forEach { $0.stateDidUpdate(state, oldState: oldValue) }
        }
    }

    public init(_ initialState: State, reducers: [StoreReducer]) {
        self.state = initialState
        self.reducers = reducers
    }

    public func subscribe(_ listener: StoreListenable) {
        listeners.append(listener)

        // send the current state to a listener immediately when it
        // subscribes so that it can display something if needed
        listener.stateDidUpdate(state, oldState: nil)
    }

    public func unsubscribe(_ listener: StoreListenable) {
        listeners = listeners.filter { $0 !== listener }
    }

    public func update<Action: StoreAction>(with action: Action) {
        state = reducers.reduce(into: state) { currentState, reducer in
            currentState = reducer.reduce(with: action, currentState: currentState)
        }
    }
}

public protocol StoreListenable: class {
    func stateDidUpdate(_ state: StoreState, oldState: StoreState?)
}

public protocol StoreReducer {
    func reduce<Action: StoreAction, State: StoreState>(with action: Action, currentState: State) -> State
}

public protocol StoreAction {
    associatedtype Payload
    var payload: Payload { get set }
}
