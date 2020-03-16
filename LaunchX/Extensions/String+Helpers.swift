//
//  String+Helpers.swift
//  LaunchX
//
//  Created by Christophe Delhaze on 15/3/20.
//  Copyright © 2020 Christophe Delhaze. All rights reserved.
//

import UIKit

extension String {
    
    /// To display the time at the place of launch
    var localStringToDate: Date? {

        //Discarding the timezone offset to display the date that was recorded at launch location
        let localDateString = String(self.dropLast(6))
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

        return dateFormatter.date(from: localDateString)
        
    }
    
}
