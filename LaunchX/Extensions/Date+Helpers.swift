//
//  Date+Helpers.swift
//  LaunchX
//
//  Created by Christophe Delhaze on 15/3/20.
//  Copyright © 2020 Christophe Delhaze. All rights reserved.
//

import UIKit
import AVFoundation

extension Date {
    
    /// Format date and return a medium date string (typically with abbreviated text, such as “Nov 23, 1937” or “3:30:32 PM”)
    var toMediumDate: String {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .none
        return df.string(from: self)
    }
    
    /// Format date and return a long date string (typically with full text, such as “November 23, 1937” or “3:30:32 PM PST”)
    var toLongDate: String {
        let df = DateFormatter()
        df.dateStyle = .long
        df.timeStyle = .none
        return df.string(from: self)
    }
    

    /// Format date and return a long date string with a medium time string (typically with full date text and abbreviated time text, such as “November 23, 1937 at 3:30:32 PM”)
    var toLongDateTime: String {
        let df = DateFormatter()
        df.dateStyle = .long
        df.timeStyle = .medium
        return df.string(from: self)
    }
    
}
