//
//  Reducer.swift
//  ReduxSwiftExamples
//
//  Created by Andy Saw on 2018/10/28.
//  Copyright © 2018 andyksaw. All rights reserved.
//

import ReduxSwift

final class CounterReducer: StoreStateReducable {

    typealias State = AppState

    func reduce(with action: StoreActionable, currentState: State) -> State {
        var state = currentState

        switch action {
        case let action as IncrementCounterAction:
            state.number += action.amount

        default:
            return currentState
        }

        return state
    }
}
