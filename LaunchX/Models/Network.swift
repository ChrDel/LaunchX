//
//  Network.swift
//  LaunchX
//
//  Created by Christophe Delhaze on 14/3/20.
//  Copyright © 2020 Christophe Delhaze. All rights reserved.
//

import Apollo
import ApolloAlamofire
import SwiftUI
import Combine

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

extension ApolloClient {
    
    @discardableResult
    ///Wraps the network call into a Combine Promise. This allows us to avoid using a callback function from the Apollo framework.
    public func fetch<Query: GraphQLQuery>(query: Query) -> Future<LaunchListQuery.Data, Never> {
        Future<LaunchListQuery.Data, Never> { [weak self] promise in
            self?.fetch(query: query) { (result) in
                _ = result.publisher
                    .receive(on: RunLoop.main)
                    .sink(receiveCompletion: { (error) in
                    }) { (result) in
                        if let data = result.data {
                            promise(.success(data as! LaunchListQuery.Data))
                        } else {
                            promise(.success(LaunchListQuery.Data.empty))
                        }
                }
            }
        }
    }
    
}
