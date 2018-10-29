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
    private let middleware: [StoreMiddleware]

    private(set) var state: State {
        didSet {
            listeners.forEach { (_, propagateState) in
                propagateState(state)
            }
        }
    }

    public init(_ initialState: State, reducers: [StoreReducer], middleware: [StoreMiddleware] = []) {
        self.state = initialState
        self.reducers = reducers
        self.middleware = middleware
    }

    public func subscribe<Listenable: StoreListenable>(_ listener: Listenable) where Listenable.BoundState.State == State {
        let identifier = listener.hashValue

        // subscribe to store changes with a callback closure
        // in order to type erase the BoundState of StoreListenable.
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
        listeners.removeValue(forKey: identifier)
    }

    public func dispatch<Action: StoreAction, TargetStore: Store>(action: Action, store: TargetStore) {
        var actionToDispatch: Action? = nil
        for m in middleware {
            guard let newAction = m.handle(action: action, store: store) else { return }
            actionToDispatch = newAction
        }

        if actionToDispatch == nil {
            return
        }

        state = reducers.reduce(into: state) { currentState, reducer in
            currentState = reducer.reduce(with: actionToDispatch!, currentState: currentState)
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

public class StoreMiddleware {
    func handle<Action: StoreAction, State: StoreState>(action: Action, store: Store<State>) -> Action? {
        return action
    }
}

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
