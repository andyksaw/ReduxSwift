//
//  ViewController.swift
//  ReduxSwiftExamples
//
//  Created by Andy Saw on 2018/10/28.
//  Copyright © 2018 andyksaw. All rights reserved.
//

import UIKit
import ReduxSwift

class ViewController: UIViewController, StoreListenable {
    struct BoundState: StoreStateSlice {
        typealias State = AppState

        let number: Int

        init(state: State) {
            number = state.number
        }
    }

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

    func stateDidUpdate(_ state: BoundState) {
        numberLabel.text = String(state.number)
        incrementButton.isEnabled = state.number < 10
        decrementButton.isEnabled = state.number > 0
    }

    @IBAction func incrementButtonTapped(_ sender: Any) {
        store.dispatch(
            action: IncrementCounterAction(payload: .init(amount: 1)),
            store: store
        )
    }

    @IBAction func decrementButtonTapped(_ sender: Any) {
        store.dispatch(
            action: IncrementCounterAction(payload: .init(amount: -1)),
            store: store
        )
    }
}
