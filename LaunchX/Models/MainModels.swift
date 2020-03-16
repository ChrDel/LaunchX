//
//  MainModels.swift
//  LaunchX
//
//  Data Models required by the MainViewModel
//
//  Created by Christophe Delhaze on 16/3/20.
//  Copyright © 2020 Christophe Delhaze. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources
import Apollo

/// Indicate if we should display the Past Launches or Future / Upcoming Launches
struct Selection {
    let segmentIndex: PublishRelay<Int>
}

/// Used to specify the serach criteria
struct Search {
    let criteria: PublishRelay<(missionName: String?, rocketName: String?, launchYear: String?)>
}

/// Data received from the GraphQL API call
struct Launches {
    let launchDataSections: Driver<Observable<[LaunchDataSection]>>
}

/// Structure required by RxDataSources. Used to display the launches in the tableView
/// We will only have one section since i decided to have the past and future launches displayed separately
/// vs displaying them in sections.
struct LaunchDataSection {
    var header: String
    var items: [GraphQLSelectionSet]
}

/// Conforming to protocol required by RxDataSources
extension LaunchDataSection: SectionModelType {
    typealias Item = GraphQLSelectionSet
    init(original: LaunchDataSection, items: [Item]) {
        self = original
        self.items = items
    }
}
