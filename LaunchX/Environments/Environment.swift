//
//  MainModels.swift
//  LaunchX
//
//  Created by Christophe Delhaze on 16/3/20.
//  Copyright © 2020 Christophe Delhaze. All rights reserved.
//

import Foundation

/// Structure to read environemnt files
public struct Environment {
    
    /// Different Environment types
    public enum EnvironmentType {
        case none
        case development
        case production
        
        func toString() -> String {
            switch self {
            case .none:
                return "None"
            case .development:
                return "Development"
            case .production:
                return "Production"
            }
        }
    }
    
    /// Keys to read environment dictionnary from the Info.plist
    public enum Keys {
        case serverApiURL
        case connectionProtocol
        case configName
        case apiVersion
        
        func value() -> String {
            switch self {
            case .serverApiURL:
                return "server_api_url"
            case .connectionProtocol:
                return "protocol"
            case .configName:
                return "config_name"
            case .apiVersion:
                return "api_version"
            }
        }
    }

    /// Retrieve the Info.plist and read environemt dictionnary
    fileprivate var infoDict: [String: Any] {
        get {
            guard let dict = Bundle.main.infoDictionary,
                let appSettings = dict["app_settings"] as? [String: AnyObject] else {
                    fatalError("Environment file not found")
            }
            
            return appSettings
        }
    }

    /// Read Key / value pair from Info.plist
    public func configuration(_ key: Keys) -> String {
        return infoDict[key.value()] as? String ?? ""
    }
    
    /// Return the current environment type
    public var environmentType: EnvironmentType {
        let configName = self.configuration(.configName)
        
        if configName == "Dev" {
            return .development
        } else if configName == "Prod" {
            return .production
        }
        
        return .none
    }

}
