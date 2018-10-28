//
//  Actions.swift
//  ReduxSwiftExamples
//
//  Created by Andy Saw on 2018/10/28.
//  Copyright © 2018 andyksaw. All rights reserved.
//

import ReduxSwift

struct IncrementCounterAction: StoreAction {
    struct Payload {
        let amount: Int
    }
    var payload: Payload
}
