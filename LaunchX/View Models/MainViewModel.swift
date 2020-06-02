//
//  MainViewModel.swift
//  LaunchX
//
//  Created by Christophe Delhaze on 15/3/20.
//  Copyright © 2020 Christophe Delhaze. All rights reserved.
//

import Apollo
import SwiftUI
import Combine

class MainViewModel: ObservableObject {
    
    ///Used to filter the network call to display past launches in the first segment of the segmented control and the the upcoming launches in the second segment.
    @Published var segmentIndex: Int = 0
    
    ///Search criteria used for the GraphQL API call
    @Published var criteria: (missionName: String, rocketName: String, launchYear: String) = ("", "", "")
    
    ///Contains the filtered launches to be displayed in the MainView
    @Published var launches = [launchListRow]()
    
    ///Store all cancellable subscriptions to avoid memory leaks
    private var subscriptions = Set<AnyCancellable>()
    
    /// Initialize our view model
    /// Send a first GraphQL API call to get all the launches
    /// create the publisher / observer to update the GraphQL call when the search criteria change
    /// Create the publisher / observer to filter the display between past and future launches and to search the database using GraphQL API
    init(launchListData: LaunchListQuery.Data = LaunchListQuery.Data()) {
        
        ///We observe any changes made to the search criteria. We empty the current launches while the call to the network is in progress.
        $criteria
            .receive(on: DispatchQueue.main)
            .sink { (_) in
            self.launches = [launchListRow]()
        }
        .store(in: &subscriptions)
        
        ///Declare publisher that will emit the return of the GraphQL API call.
        let launchesPublisher = $criteria
            .receive(on: DispatchQueue.main)
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .flatMap { arg0 -> Future<LaunchListQuery.Data, Never> in
                let (missionName, rocketName, launchYear) = arg0
                return Network.shared.apollo.fetch(query: LaunchListQuery(rocketName: rocketName, missionName: missionName, launchYear: launchYear))
        }
                
        ///Combine the latest segmentIndex publisher whith the latest launches returned from the API call.
        ///We do this to filter the data without doing an API call. Or if the API data change to filter it with the current / latest value of the segmentIndex
        /// we map the result to an array of LaunchListRow that can be used by the MainView
        /// We then create an observer to assign the result to the launches
        Publishers.CombineLatest($segmentIndex,launchesPublisher)
            .receive(on: DispatchQueue.main)
            .map { arg0 -> [launchListRow] in
                let (segmentIndex, launches) = arg0
                let filteredLaunches = segmentIndex == 0 ? (launches.launchesPast ?? [LaunchListQuery.Data.LaunchesPast?]()).compactMap { $0?.aslaunchListRow } : (launches.launchesUpcoming ?? [LaunchListQuery.Data.LaunchesUpcoming]()).compactMap { $0?.aslaunchListRow }
                return filteredLaunches
        }
        .sink { (launches) in
            self.launches = launches
        }
        .store(in: &subscriptions)
        
    }
    
}
