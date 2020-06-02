//
//  MainModels.swift
//  LaunchX
//
//  Data Models required by the MainViewModel
//
//  Created by Christophe Delhaze on 16/3/20.
//  Copyright © 2020 Christophe Delhaze. All rights reserved.
//

import SwiftUI
import Combine
import Apollo

/// Indicate if we should display the Past Launches or Future / Upcoming Launches
struct Selection {
}

/// Used to specify the serach criteria
struct Search {
}

/// Data received from the GraphQL API call
struct Launches {
}

///Common structure use to display data in the Lanches List.
struct launchListRow: Hashable {
    var launchDateLocal: String?
    var videoLink: String?
    var missionName: String?
    var rocketName: String?
    var isVideoPlayerHidden: Bool = true
}

///Helper to convert a past launch into a LaunchListRow
extension LaunchListQuery.Data.LaunchesPast {
    
    var aslaunchListRow: launchListRow {
        launchListRow(launchDateLocal: self.launchDateLocal, videoLink: self.links?.videoLink, missionName: self.missionName, rocketName: self.rocket?.rocketName)
    }
    
}

///Helper to convert an upcoming launch into a LaunchListRow
extension LaunchListQuery.Data.LaunchesUpcoming {
    
    var aslaunchListRow: launchListRow {
        launchListRow(launchDateLocal: self.launchDateLocal, videoLink: self.links?.videoLink, missionName: self.missionName, rocketName: self.rocket?.rocketName)
    }
    
}
