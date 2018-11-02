//
//  Store.swift
//  ReduxSwift
//
//  Created by Andy Saw on 2018/10/28.
//  Copyright © 2018 andyksaw. All rights reserved.
//

public protocol StoreState {}

public final class Store<State> where State: StoreState {
    private typealias Listener = (StoreState) -> Void
    private typealias ListenerKey = Int

    private var listeners = [ListenerKey: Listener]()
    private let reducers: [StoreReducer]

    private(set) var state: State {
        didSet {
            listeners.forEach { (_, propagateState) in
                propagateState(state)
            }
        }
    }

    public init(_ initialState: State, reducers: [StoreReducer]) {
        self.state = initialState
        self.reducers = reducers
    }

    /// Allows the given View to observe state changes in the store.
    /// Every time the state changes, a slice of the state (represented
    /// by a BoundState) will be returned to the View.
    ///
    /// The View *must* unsubscribe from the store when state changes
    /// no longer need to be observed (eg. when the ViewController disappears).
    ///
    /// - Parameter listener: View to receive state changes
    public func subscribe<Listenable: StoreListenable>(_ listener: Listenable) where Listenable.BoundState.State == State {
        let identifier = listener.hashValue

        // subscribe to store changes with a callback closure
        // in order to type erase the BoundState of StoreListenable
        listeners[identifier] = { [weak listener] state in
            guard let listener = listener else { return }
            guard let boundState = state as? Listenable.BoundState.State else { return }
            let stateSlice = Listenable.BoundState.init(state: boundState)
            listener.stateDidUpdate(stateSlice)
        }

        // send the current state to a listener immediately when it
        // subscribes so that it can display something if needed
        let stateSlice = Listenable.BoundState.init(state: state)
        listener.stateDidUpdate(stateSlice)
    }

    /// Stops the given View from receiving any further state changes
    /// in the store.
    ///
    /// - Parameter listener: View to stop receiving state changes
    public func unsubscribe<Listenable: StoreListenable>(_ listener: Listenable) {
        let identifier = listener.hashValue
        listeners.removeValue(forKey: identifier)
    }

    /// Dispatches an Action to request a change to the store's state
    ///
    /// - Parameters:
    ///   - actionType: Action type to be dispatched
    public func dispatch(actionType: StoreActionType) {
        switch actionType {
        case .action(let action):
            func buildNewState() {
                state = reducers.reduce(into: state) { currentState, reducer in
                    currentState = reducer.reduce(with: action, currentState: currentState)
                }
            }
            if Thread.isMainThread {
                buildNewState()
            } else {
                DispatchQueue.main.sync(execute: buildNewState)
            }

        case .thunk(let action):
            action(dispatch)
        }

    }
}
