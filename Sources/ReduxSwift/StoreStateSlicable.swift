//
//  StoreStateSlicable.swift
//  ReduxSwift
//
//  Created by Andy Saw on 2020/09/13.
//  Copyright © 2020 andysaw. All rights reserved.
//

public protocol StoreStateSlicable: Equatable {

    associatedtype ParentState: StoreStorable

    init(from state: ParentState)
}
