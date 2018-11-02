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
    /// BoundState specifies what properties of the app's
    /// state that we want to observe for changes. This prevents
    /// unrelated state changes causing updates to our View layer.
    ///
    /// In this case we only want to take the `number` value
    /// which can be either incremented or decremented.
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
        let incrementAction = IncrementCounterAction(payload: .init(amount: 1))
        store.dispatch(
            actionType: .action(incrementAction)
        )
    }

    @IBAction func decrementButtonTapped(_ sender: Any) {
        let decrementAction = IncrementCounterAction(payload: .init(amount: -1))
        store.dispatch(
            actionType: .action(decrementAction)
        )
    }
}

