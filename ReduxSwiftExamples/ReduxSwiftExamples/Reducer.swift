//
//  Reducer.swift
//  ReduxSwiftExamples
//
//  Created by andysaw on 2018/10/29.
//  Copyright © 2018 andysaw. All rights reserved.
//

import ReduxSwift

final class CounterReducer: StoreReducer {
    func reduce<Action, State>(with action: Action, currentState: State) -> State where Action : StoreAction, State : StoreState {
        guard var state = currentState as? AppState else { return currentState }

        switch action {
        case let action as IncrementCounterAction:
            state.number += action.payload.amount

        default:
            return currentState
        }

        return state as! State
    }
}
