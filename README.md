# ReduxSwift
A basic implementation of [Redux](https://redux.js.org/) state-management in Swift

## Installation
#### Carthage
If you use Carthage to manage your dependencies, add the below to your `Cartfile`
```
github "andyksaw/ReduxSwift" ~> 0.1.1
```

#### Cocoapods
If you use Cocoapods to manage your dependencies, add the below to your `Podfile`
```
pod 'redux-swift', '~> 0.1.1'
```

## Getting Started

#### The Store
In Redux, the store is the single source of truth. 

Start by defining a struct type to represent your app's state and a globally accessible store to hold it. The easiest way is to define the store at the top of a file (eg. top of AppDelegate.swift) using a `let` declaration.

```Swift
struct AppState: StoreState {
  var counter: Int
}

let initialState = AppState(counter: 0)

let store = Store(initialState, reducers: [])
```

#### Listening to Changes
Anything that conforms to `StoreListenable` can be subscribed to the store to observe changes to the state.

```Swift
class ViewController: UIViewController, StoreListenable {
  // BoundState represents a slice of the store's state that
  // we want to watch for changes. In the below example the
  // `counter` property becomes bound to our ViewController
  struct BoundState: StoreStateSlice {
    typealias State = AppState
    
    let counter: Int
    
    init(state: State) {
      counter = state.counter
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    // subscribe this ViewController to the Store whenever it appears
    store.subscribe(self)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    // unsubscribe this ViewController whenever it disappears
    store.unsubscribe(self)
  }

  // every time the state changes, this method is called. We could
  // for example, update a label with this value inside here
  func stateDidUpdate(_ state: BoundState) {
     print(state.counter)
  }
}
```

#### Requesting a State Change
In Redux, the only way to change the store's state is through an *action*.

```Swift
struct IncrementCounterAction: StoreAction {
  let amount: Int
}
```

We then dispatch the action to the store.
```Swift
class ViewController: UIViewController {
  // ...
  
  @IBAction func buttonWasTapped() {
    let incrementAction = IncrementCounterAction(amount: 1)
    store.dispatch(actionType: .action(incrementAction))
  }
}
```

#### Updating the State
The actual state updating is performed by a *reducer*. This simply receives an action and determines how to update the store.

```Swift
struct CounterReducer: StoreReducer {
   func reduce<State>(with action: StoreAction, currentState: State) -> State where State : StoreState {
      guard var state = currentState as? AppState else { return currentState }

      switch action {
      case let action as IncrementCounterAction:
          state.counter += action.payload.amount

      default:
          return currentState
      }

      return state as! State
  }
}
```

The reducer needs to be registered when you first set up the store. It is good practise to create a reducer for each feature/module, instead of creating one monolithic reducer.
```Swift
let store = Store(initialState, reducers: [
  CounterReducer(),
  AnotherReducer(),
  OneMoreReducer(),
  // etc...
])
```

We now have working uni-directional state management!
(See included examples for more details)


##### Extra: Async Actions (Thunks)
The above examples work for synchronous state updates. However, an API request for example should not be performed on the main thread. In these cases we can dispatch a *thunk* instead of a regular action.

```Swift
struct FetchStartedAction: StoreAction {}
struct FetchSucceededAction: StoreAction {
  let data: String
}
struct FetchFailedAction: StoreAction {
  let errorMessage: String
}

func fetchApiData() {
  store.dispatch(actionType: .thunk { dispatch in
     dispatch(.action(FetchStartedAction()))
  
     // simulating an API request...
     DispatchQueue.global().async {
       // if the api request succeeded...
       let successAction = FetchSucceededAction(data: "Hello World!")
       dispatch(.action(successAction))
       
       // if the api request failed...
       let failedAction = FetchFailedAction(errorMessage: "Server is unavailable")
       dispatch(.action(failedAction))
     }
  })
}
```

As you can see, a thunk is a special type of action that runs a block of code, and can **dispatch other actions** when it deems appropriate.

##### Extra: Action Creators
The problem with the above approach is that we have a large block of code inside the `dispatch()` call. This is not only a little ugly but more importantly it's unreusable.

By moving it into an *action creator*, we can use the action anywhere without having to duplicate the code. An action creator is essentially just an **action factory**.

```Swift
struct FetchActionCreator: StoreActionCreator {
  static make(input: Input) -> StoreActionType {
    return .thunk { dispatch in
      // ...
  }
}
```

And now we can use it anywhere...
```Swift
func fetchApiData() {
  store.dispatch(actionType: FetchActionCreator.make())
}
```

## Todo
- [x] Basic implementation
- [x] Pass only a slice of the Store to listeners
- [ ] Middleware
- [x] Thunk (async action) support
- [ ] Unit tests

## Attribution
Credit to the original creators of Redux, Dan Abramov and Andrew Clark
