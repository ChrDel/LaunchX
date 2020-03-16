//
//  Network.swift
//  LaunchX
//
//  Created by Christophe Delhaze on 14/3/20.
//  Copyright © 2020 Christophe Delhaze. All rights reserved.
//

import Apollo
import ApolloAlamofire
import RxApolloClient

/// Network component to make the GraphQL API call
class Network {
    
    static let shared = Network()
    
    static internal var apiUrl: String {
        let environment = Environment()
        let serverUrl = environment.configuration(.serverApiURL)
        let `protocol` = environment.configuration(.connectionProtocol)
        // In the current case we do not nead this
        //let apiVersion = environment.configuration(.apiVersion)
        
        return "\(`protocol`)://\(serverUrl)"
        // case that would include an apiVersion
        //return "\(`protocol`)://\(serverUrl)/\(apiVersion)"
    }
    
    private(set) lazy var apollo = ApolloClient(networkTransport: AlamofireTransport(url: URL(string: Network.apiUrl)!, loggingEnabled:  false))
    
}
