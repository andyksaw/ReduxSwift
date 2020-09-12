//
//  Store.swift
//  ReduxSwift
//
//  Created by Andy Saw on 2018/10/28.
//  Copyright © 2018 andyksaw. All rights reserved.
//

public final class Store<State: StoreStorable> {

    fileprivate typealias Observer = (State) -> Void

    private var observers = [ObjectIdentifier: Observer]()
    private let reducers: [AnyStoreReducer<State>]

    private(set) var state: State {
        didSet {
            observers.values.forEach { observer in
                observer(state)
            }
        }
    }

    public init(_ initialState: State, reducers: [AnyStoreReducer<State>]) {
        self.state = initialState
        self.reducers = reducers
    }
}

public extension Store {

    /// Allows the given View to observe state changes in the store.
    ///
    /// Every time the state changes, a slice of the state will be returned to the given observer.
    ///
    /// - Parameter observer: Class to be notified of state changes
    ///
    func subscribe<Observable: StoreObservable>(_ observingClass: Observable) where Observable.StateSlice.ParentState == State {
        let identifier = ObjectIdentifier(observingClass)

        observers[identifier] = { [weak observingClass] state in
            guard let observingClass = observingClass else { return }
            let stateSlice = Observable.StateSlice.init(from: state)
            observingClass.stateDidUpdate(to: stateSlice)
        }

        // Send the current state to a listener immediately when it
        // subscribes so that it can display something if needed
        let stateSlice = Observable.StateSlice.init(from: state)
        observingClass.stateDidUpdate(to: stateSlice)
    }

    /// Stops the given View from receiving any further state changes
    /// in the store.
    ///
    /// - Parameter observer: View to stop receiving state changes
    ///
    func unsubscribe<Observable: StoreObservable>(_ observer: Observable) {
        let identifier = ObjectIdentifier(observer)

        observers.removeValue(forKey: identifier)
    }

    /// Dispatches an Action to request that the store state be mutated
    ///
    /// - Parameter action: Action type to be dispatched
    ///
    func dispatch(action: StoreActionable) {
        func reduceNewState() {
            state = reducers.reduce(into: state) { combinedState, reducer in
                combinedState = reducer.reduce(with: action, currentState: combinedState)
            }
        }
        if Thread.isMainThread {
            reduceNewState()
        } else {
            DispatchQueue.main.sync(execute: reduceNewState)
        }
    }
}
