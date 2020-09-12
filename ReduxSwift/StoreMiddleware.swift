//
//  StoreMiddleware.swift
//  ReduxSwift
//
//  Created by Andy Saw on 2020/09/13.
//  Copyright © 2020 andysaw. All rights reserved.
//

public protocol StoreMiddleware {

    var next: StoreMiddleware? { get set }

    func handle<State: StoreStorable>(store: Store<State>, action: StoreActionable)
}
