//
//  StoreObservable.swift
//  ReduxSwift
//
//  Created by Andy Saw on 2018/10/29.
//  Copyright © 2018 andysaw. All rights reserved.
//

public protocol StoreObservable: AnyObject {

    associatedtype StateSlice: StoreStateSlicable

    func stateDidUpdate(to state: StateSlice)
}
