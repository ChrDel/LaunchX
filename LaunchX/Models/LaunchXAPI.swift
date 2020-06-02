// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class LaunchListQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query LaunchList($rocketName: String, $missionName: String, $launchYear: String) {
      launchesUpcoming(find: {rocket_name: $rocketName, mission_name: $missionName, launch_year: $launchYear}) {
        __typename
        mission_name
        links {
          __typename
          video_link
        }
        rocket {
          __typename
          rocket_name
        }
        launch_date_local
      }
      launchesPast(find: {rocket_name: $rocketName, mission_name: $missionName, launch_year: $launchYear}) {
        __typename
        mission_name
        links {
          __typename
          video_link
        }
        rocket {
          __typename
          rocket_name
        }
        launch_date_local
      }
    }
    """

  public let operationName: String = "LaunchList"

  public var rocketName: String?
  public var missionName: String?
  public var launchYear: String?

  public init(rocketName: String? = nil, missionName: String? = nil, launchYear: String? = nil) {
    self.rocketName = rocketName
    self.missionName = missionName
    self.launchYear = launchYear
  }

  public var variables: GraphQLMap? {
    return ["rocketName": rocketName, "missionName": missionName, "launchYear": launchYear]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("launchesUpcoming", arguments: ["find": ["rocket_name": GraphQLVariable("rocketName"), "mission_name": GraphQLVariable("missionName"), "launch_year": GraphQLVariable("launchYear")]], type: .list(.object(LaunchesUpcoming.selections))),
      GraphQLField("launchesPast", arguments: ["find": ["rocket_name": GraphQLVariable("rocketName"), "mission_name": GraphQLVariable("missionName"), "launch_year": GraphQLVariable("launchYear")]], type: .list(.object(LaunchesPast.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(launchesUpcoming: [LaunchesUpcoming?]? = nil, launchesPast: [LaunchesPast?]? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "launchesUpcoming": launchesUpcoming.flatMap { (value: [LaunchesUpcoming?]) -> [ResultMap?] in value.map { (value: LaunchesUpcoming?) -> ResultMap? in value.flatMap { (value: LaunchesUpcoming) -> ResultMap in value.resultMap } } }, "launchesPast": launchesPast.flatMap { (value: [LaunchesPast?]) -> [ResultMap?] in value.map { (value: LaunchesPast?) -> ResultMap? in value.flatMap { (value: LaunchesPast) -> ResultMap in value.resultMap } } }])
    }

    public var launchesUpcoming: [LaunchesUpcoming?]? {
      get {
        return (resultMap["launchesUpcoming"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [LaunchesUpcoming?] in value.map { (value: ResultMap?) -> LaunchesUpcoming? in value.flatMap { (value: ResultMap) -> LaunchesUpcoming in LaunchesUpcoming(unsafeResultMap: value) } } }
      }
      set {
        resultMap.updateValue(newValue.flatMap { (value: [LaunchesUpcoming?]) -> [ResultMap?] in value.map { (value: LaunchesUpcoming?) -> ResultMap? in value.flatMap { (value: LaunchesUpcoming) -> ResultMap in value.resultMap } } }, forKey: "launchesUpcoming")
      }
    }

    public var launchesPast: [LaunchesPast?]? {
      get {
        return (resultMap["launchesPast"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [LaunchesPast?] in value.map { (value: ResultMap?) -> LaunchesPast? in value.flatMap { (value: ResultMap) -> LaunchesPast in LaunchesPast(unsafeResultMap: value) } } }
      }
      set {
        resultMap.updateValue(newValue.flatMap { (value: [LaunchesPast?]) -> [ResultMap?] in value.map { (value: LaunchesPast?) -> ResultMap? in value.flatMap { (value: LaunchesPast) -> ResultMap in value.resultMap } } }, forKey: "launchesPast")
      }
    }

    public struct LaunchesUpcoming: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Launch"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("mission_name", type: .scalar(String.self)),
        GraphQLField("links", type: .object(Link.selections)),
        GraphQLField("rocket", type: .object(Rocket.selections)),
        GraphQLField("launch_date_local", type: .scalar(String.self)),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(missionName: String? = nil, links: Link? = nil, rocket: Rocket? = nil, launchDateLocal: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "Launch", "mission_name": missionName, "links": links.flatMap { (value: Link) -> ResultMap in value.resultMap }, "rocket": rocket.flatMap { (value: Rocket) -> ResultMap in value.resultMap }, "launch_date_local": launchDateLocal])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var missionName: String? {
        get {
          return resultMap["mission_name"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "mission_name")
        }
      }

      public var links: Link? {
        get {
          return (resultMap["links"] as? ResultMap).flatMap { Link(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "links")
        }
      }

      public var rocket: Rocket? {
        get {
          return (resultMap["rocket"] as? ResultMap).flatMap { Rocket(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "rocket")
        }
      }

      public var launchDateLocal: String? {
        get {
          return resultMap["launch_date_local"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "launch_date_local")
        }
      }

      public struct Link: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["LaunchLinks"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("video_link", type: .scalar(String.self)),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(videoLink: String? = nil) {
          self.init(unsafeResultMap: ["__typename": "LaunchLinks", "video_link": videoLink])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var videoLink: String? {
          get {
            return resultMap["video_link"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "video_link")
          }
        }
      }

      public struct Rocket: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["LaunchRocket"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("rocket_name", type: .scalar(String.self)),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(rocketName: String? = nil) {
          self.init(unsafeResultMap: ["__typename": "LaunchRocket", "rocket_name": rocketName])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var rocketName: String? {
          get {
            return resultMap["rocket_name"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "rocket_name")
          }
        }
      }
    }

    public struct LaunchesPast: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Launch"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("mission_name", type: .scalar(String.self)),
        GraphQLField("links", type: .object(Link.selections)),
        GraphQLField("rocket", type: .object(Rocket.selections)),
        GraphQLField("launch_date_local", type: .scalar(String.self)),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(missionName: String? = nil, links: Link? = nil, rocket: Rocket? = nil, launchDateLocal: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "Launch", "mission_name": missionName, "links": links.flatMap { (value: Link) -> ResultMap in value.resultMap }, "rocket": rocket.flatMap { (value: Rocket) -> ResultMap in value.resultMap }, "launch_date_local": launchDateLocal])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var missionName: String? {
        get {
          return resultMap["mission_name"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "mission_name")
        }
      }

      public var links: Link? {
        get {
          return (resultMap["links"] as? ResultMap).flatMap { Link(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "links")
        }
      }

      public var rocket: Rocket? {
        get {
          return (resultMap["rocket"] as? ResultMap).flatMap { Rocket(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "rocket")
        }
      }

      public var launchDateLocal: String? {
        get {
          return resultMap["launch_date_local"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "launch_date_local")
        }
      }

      public struct Link: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["LaunchLinks"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("video_link", type: .scalar(String.self)),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(videoLink: String? = nil) {
          self.init(unsafeResultMap: ["__typename": "LaunchLinks", "video_link": videoLink])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var videoLink: String? {
          get {
            return resultMap["video_link"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "video_link")
          }
        }
      }

      public struct Rocket: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["LaunchRocket"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("rocket_name", type: .scalar(String.self)),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(rocketName: String? = nil) {
          self.init(unsafeResultMap: ["__typename": "LaunchRocket", "rocket_name": rocketName])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var rocketName: String? {
          get {
            return resultMap["rocket_name"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "rocket_name")
          }
        }
      }
    }
  }
}
