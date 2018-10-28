//
//  ViewController.swift
//  ReduxSwiftExamples
//
//  Created by andysaw on 2018/10/28.
//  Copyright © 2018 andysaw. All rights reserved.
//

import UIKit
import ReduxSwift

struct AppState: StoreState {
    var number: Int
}

let initialState = AppState(number: 3)
let store = Store<AppState>(initialState, reducers: [
    CounterReducer()
])

final class CounterReducer: StoreReducer {
    func reduce<Action, State>(with action: Action, currentState: State) -> State where Action : StoreAction, State : StoreState {
        guard var state = currentState as? AppState else { return currentState }

        switch action {
        case let action as IncrementCounterAction:
            state.number += action.payload.amount

        default:
            return currentState
        }

        return state as! State
    }
}

struct IncrementCounterAction: StoreAction {
    struct Payload {
        let amount: Int
    }
    var payload: Payload
}

class ViewController: UIViewController, StoreListenable {
    @IBOutlet private weak var numberLabel: UILabel!
    @IBOutlet private weak var incrementButton: UIButton!
    @IBOutlet private weak var decrementButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.subscribe(self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        store.unsubscribe(self)
    }

    func stateDidUpdate(_ state: StoreState, oldState: StoreState?) {
        guard let state = state as? AppState else { return }

        numberLabel.text = String(state.number)
        incrementButton.isEnabled = state.number < 10
        decrementButton.isEnabled = state.number > 0
    }

    @IBAction func incrementButtonTapped(_ sender: Any) {
        let action = IncrementCounterAction(payload: .init(amount: 1))
        store.update(with: action)
    }

    @IBAction func decrementButtonTapped(_ sender: Any) {
        let action = IncrementCounterAction(payload: .init(amount: -1))
        store.update(with: action)
    }
}

