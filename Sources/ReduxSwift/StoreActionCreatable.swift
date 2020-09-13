//
//  StoreActionCreatable.swift
//  ReduxSwift
//
//  Created by Andy Saw on 2020/09/13.
//  Copyright © 2020 andysaw. All rights reserved.
//

public protocol StoreActionCreatable {

    associatedtype Action: StoreActionInitable

    static func make(with input: Action.Input) -> Action
}

public protocol StoreActionInitable: StoreActionable {

    associatedtype Input
}
