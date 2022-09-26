//
//  BoxOfficeViewReactor.swift
//  MovieSearch
//
//  Created by Seul Mac on 2022/09/26.
//

import Foundation
import RxSwift
import ReactorKit

final class BoxOfficeViewReactor: Reactor {
    private let boxOfficeUseCase = BoxOfficeUseCase()
    private let disposeBag: DisposeBag = .init()
    
    enum Action {
        case load
    }
    
    enum Mutation {
        case setBoxOfficeInformation(BoxOfficeInformation?)
    }
    
    struct State {
        var targetDate: String = "20220903"
        var currentBoxOffice: [BoxOfficeMovie] = []
    }
    
    var initialState = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .load:
            return boxOfficeUseCase.fetchBoxOfficeChart(with: self.currentState.targetDate)
                .map{ Mutation.setBoxOfficeInformation($0) }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setBoxOfficeInformation(let information):
            guard let information = information else { return state }
            newState.targetDate = information.targetDate
            newState.currentBoxOffice = information.boxOfficeMovies.sorted{ $0.rank < $1.rank }
        }
        return newState
    }
    
}
