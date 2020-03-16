//
//  LaunchListQuery.Data+Helpers.swift
//  LaunchX
//
//  Created by Christophe Delhaze on 16/3/20.
//  Copyright © 2020 Christophe Delhaze. All rights reserved.
//

/// Creating an empty set of LaunchListQuery.Data to init API calls
extension LaunchListQuery.Data {
    static var empty: LaunchListQuery.Data {
        var launchListData = LaunchListQuery.Data()
        launchListData.launchesPast = [LaunchListQuery.Data.LaunchesPast]()
        launchListData.launchesUpcoming = [LaunchListQuery.Data.LaunchesUpcoming]()
        return launchListData
    }
}

