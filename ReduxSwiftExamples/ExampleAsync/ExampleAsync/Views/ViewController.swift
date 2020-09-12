//
//  ViewController.swift
//  ExampleAsync
//
//  Created by Andy Saw on 2018/10/29.
//  Copyright © 2018 andyksaw. All rights reserved.
//

import UIKit
import ReduxSwift

class ViewController: UIViewController, StoreObservable {
    struct BoundState: StoreStateSlice, Equatable {
        typealias State = AppState

        let people: [Person]
        let isLoading: Bool

        init(state: State) {
            people = state.people
            isLoading = state.isLoading
        }
    }

    @IBOutlet private weak var loadingStackView: UIStackView!
    @IBOutlet private weak var tableView: UITableView!

    private var people: [Person] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        store.subscribe(self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        store.unsubscribe(self)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

//        store.dispatch(
//            actionType: FetchPeopleAction.make(with: .init(limit: 5, offset: 0))
//        )
    }

    func stateDidUpdate(_ state: BoundState) {
        people = state.people
        
        if state.isLoading {
            loadingStackView.isHidden = false
            tableView.isHidden = true
        } else {
            loadingStackView.isHidden = true
            tableView.isHidden = false
            tableView.reloadData()
        }
    }

}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let person = people[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: "basic_cell", for: indexPath)
        cell.textLabel?.text = person.name

        return cell
    }
}
