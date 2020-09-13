//
//  StoreMiddleware.swift
//  ReduxSwift
//
//  Created by Andy Saw on 2020/09/13.
//  Copyright © 2020 andysaw. All rights reserved.
//

public protocol StoreMiddleware {

    typealias NextMiddleware = (StoreActionable) -> Void

    func handle<State: StoreStorable>(store: Store<State>, action: StoreActionable, next: NextMiddleware)
}
