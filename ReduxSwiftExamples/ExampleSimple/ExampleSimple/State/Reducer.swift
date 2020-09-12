//
//  Reducer.swift
//  ReduxSwiftExamples
//
//  Created by Andy Saw on 2018/10/28.
//  Copyright © 2018 andyksaw. All rights reserved.
//

import ReduxSwift

final class CounterReducer: StoreReducer {

    func reduce<State>(with action: StoreAction, currentState: State) -> State where State : StoreState {
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
