//
//  Store.swift
//  ReduxSwift
//
//  Created by andysaw on 2018/10/28.
//  Copyright © 2018 andysaw. All rights reserved.
//

public protocol StoreState {}

public final class Store<State> where State: StoreState {
    private typealias Listener = (StoreState) -> Void
    private typealias ListenerKey = Int

    private var listeners = [ListenerKey: Listener]()
    private var orderedListeners = [ListenerKey]()
    private let reducers: [StoreReducer]

    private var state: State {
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

    public func subscribe<Listenable: StoreListenable>(_ listener: Listenable) where Listenable.BoundState.State == State {
        let identifier = listener.hashValue

        orderedListeners.append(identifier)
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

    public func unsubscribe<Listenable: StoreListenable>(_ listener: Listenable) {
        let identifier = listener.hashValue

        orderedListeners = orderedListeners.filter { $0.hashValue != identifier }
        listeners.removeValue(forKey: identifier)
    }

    public func dispatch<Action: StoreAction>(action: Action) {
        state = reducers.reduce(into: state) { currentState, reducer in
            currentState = reducer.reduce(with: action, currentState: currentState)
        }
    }
}

public protocol StoreStateSlice {
    associatedtype State: StoreState
    init(state: State)
}

public protocol StoreListenable: class, Hashable {
    associatedtype BoundState: StoreStateSlice
    func stateDidUpdate(_ state: BoundState)
}

public protocol StoreReducer {
    func reduce<Action: StoreAction, State: StoreState>(with action: Action, currentState: State) -> State
}

public protocol StoreAction {
    associatedtype Payload
    var payload: Payload { get set }
}
