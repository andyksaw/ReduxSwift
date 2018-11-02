//
//  StoreAction.swift
//  ReduxSwift
//
//  Created by Andy Saw on 2018/10/29.
//  Copyright © 2018 andyksaw. All rights reserved.
//

public protocol StoreAction {}

public protocol StoreActionCreator {
    associatedtype Input
    static func make(with input: Input) -> StoreActionType
}

public typealias StoreDispatcher = (StoreActionType) -> Void
public typealias StoreAsyncAction = (@escaping StoreDispatcher) -> Void

public enum StoreActionType {
    case action(StoreAction)
    case thunk(StoreAsyncAction)
}
