//
//  StoreListenable.swift
//  ReduxSwift
//
//  Created by andysaw on 2018/10/29.
//  Copyright © 2018 andysaw. All rights reserved.
//

public protocol StoreStateSlice: Equatable {
    associatedtype State: StoreState
    init(state: State)
}

public protocol StoreListenable: class, Hashable {
    associatedtype BoundState: StoreStateSlice
    func stateDidUpdate(_ state: BoundState)
}
