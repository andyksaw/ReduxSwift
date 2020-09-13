//
//  StoreStateReducable.swift
//  ReduxSwift
//
//  Created by Andy Saw on 2018/10/29.
//  Copyright © 2018 andyksaw. All rights reserved.
//

public protocol StoreStateReducable {

    associatedtype State: StoreStorable

    func reduce(with action: StoreActionable, currentState: State) -> State
}
