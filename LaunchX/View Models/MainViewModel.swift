//
//  MainViewModel.swift
//  LaunchX
//
//  Created by Christophe Delhaze on 15/3/20.
//  Copyright © 2020 Christophe Delhaze. All rights reserved.
//

import Apollo
import RxSwift
import RxCocoa
import RxDataSources
import RxApolloClient

class MainViewModel {
    
    /// To make sure all bindings are freed and we don't have any memory leak.
    private let disposeBag = DisposeBag()
    
    /// Past Launches or Future / Upcoming Launches selection
    let selection: Selection

    /// Serach criteria
    let search: Search

    /// Data received from the GraphQL API call
    let launches: Launches
        
    /// Initialize our view model
    /// Send a first GraphQL API call to get all the launches
    /// Create the bindings to filter the display between past and future launches and to search the database using GraphQL API
    init(launchListData: LaunchListQuery.Data = LaunchListQuery.Data()) {

        /// To combine the segment Index  ( past / future ) with the data received from the server
        func combineObservable(segmentIndex: Observable<Int>, launchData: Observable<LaunchListQuery.Data>) -> Observable<(Int, LaunchListQuery.Data)> {
            return Observable.combineLatest(segmentIndex.startWith(0), launchData)
        }

        /// To combine the segment Index ( past / future ) with the search criteria
        func combineObservable(segmentIndex: Observable<Int>, search: Observable<(missionName: String?, rocketName: String?, launchYear: String?)>) -> Observable<(Int, (missionName: String?, rocketName: String?, launchYear: String?))> {
            return Observable.combineLatest(segmentIndex.startWith(0), search.startWith((missionName: nil, rocketName: nil, launchYear: nil)))
        }

        let segmentIndexSubject = PublishRelay<Int>()
        let searchSubject = PublishRelay<(missionName: String?, rocketName: String?, launchYear: String?)>()
        
        let launchDataSections = combineObservable(segmentIndex: segmentIndexSubject.asObservable(), search: searchSubject.asObservable()).map({ (arg0) -> Observable<[LaunchDataSection]> in
            let (segmentIndex, (missionName, rocketName, launchYear)) = arg0
            return combineObservable(segmentIndex: Observable.just(segmentIndex), launchData: Network.shared.apollo.rx.fetch(query: LaunchListQuery(rocketName: rocketName, missionName: missionName, launchYear: launchYear)).asObservable())
                .map({ (arg) -> [LaunchDataSection] in
                    let (segmentIndex, launchListData) = arg
                    let launchesPast = launchListData.launchesPast ?? [LaunchListQuery.Data.LaunchesPast]()
                    let launchesUpcoming = launchListData.launchesUpcoming ?? [LaunchListQuery.Data.LaunchesUpcoming]()
                    return [segmentIndex == 0 ? LaunchDataSection(header: "", items: launchesPast.compactMap({ $0 })) : LaunchDataSection(header: "", items: launchesUpcoming.compactMap({ $0 }))]
                })
            })
            .asDriver(onErrorJustReturn: Observable.just([LaunchDataSection]()))

        self.selection = Selection(segmentIndex: segmentIndexSubject)
        self.search = Search(criteria: searchSubject)
        self.launches = Launches(launchDataSections: launchDataSections)
        
    }
        
}
