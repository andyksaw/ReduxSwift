//
//  Reducer.swift
//  ExampleAsync
//
//  Created by Andy Saw on 2018/10/29.
//  Copyright © 2018 andyksaw. All rights reserved.
//

import ReduxSwift

//final class PeopleReducer: StoreReducer {
//    func reduce<State>(with action: StoreAction, currentState: State) -> State where State : StoreState {
//        guard var state = currentState as? AppState else { return currentState }
//
//        switch action {
//        case is FetchPeopleStarted:
//            state.isLoading = true
//
//        case let action as FetchPeopleSucceeded:
//            state.people = action.people
//            state.isLoading = false
//
//        case is FetchPeopleFailed:
//            state.isLoading = false
//
//        default:
//            break
//        }
//
//        return state as! State
//    }
//}
