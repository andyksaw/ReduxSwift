//
//  Actions.swift
//  ReduxSwiftExamples
//
//  Created by andysaw on 2018/10/29.
//  Copyright © 2018 andysaw. All rights reserved.
//

import ReduxSwift

struct IncrementCounterAction: StoreAction {
    struct Payload {
        let amount: Int
    }
    var payload: Payload
}
