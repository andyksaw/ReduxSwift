//
//  StoreReducer.swift
//  ReduxSwift
//
//  Created by Andy Saw on 2018/10/29.
//  Copyright © 2018 andyksaw. All rights reserved.
//

public protocol StoreReducer {
    func reduce<State: StoreState>(with action: StoreAction, currentState: State) -> State
}
