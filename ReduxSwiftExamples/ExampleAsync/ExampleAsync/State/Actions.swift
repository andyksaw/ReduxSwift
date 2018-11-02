//
//  Actions.swift
//  ExampleAsync
//
//  Created by Andy Saw on 2018/10/29.
//  Copyright © 2018 andyksaw. All rights reserved.
//

import ReduxSwift

struct FetchPeopleStarted: StoreAction {}
struct FetchPeopleSucceeded: StoreAction {
    let people: [Person]
}
struct FetchPeopleFailed: StoreAction {
    let errorMessage: String
}


struct FetchPeopleAction: StoreActionCreator {
    struct Input {
        let limit: Int
        let offset: Int
    }

    static func make(with input: Input) -> StoreActionType {
        return .thunk { dispatch in
            dispatch(.action(FetchPeopleStarted()))

            // simulate an API response that takes 2.5 seconds to return
            DispatchQueue.global().asyncAfter(deadline: .now() + 2.5) { [dispatch] in
                let mockApiSuccess = true
                if mockApiSuccess {
                    let successAction = FetchPeopleSucceeded(people: [
                        Person(name: "John Smith"),
                        Person(name: "John Smith"),
                        Person(name: "John Smith"),
                        Person(name: "John Smith"),
                        Person(name: "John Smith"),
                    ])
                    dispatch(.action(successAction))

                } else {
                    let failureAction = FetchPeopleFailed(errorMessage: "Fetch failed")
                    dispatch(.action(failureAction))
                }
            }
        }
    }
}
