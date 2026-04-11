//
//  Date+Format.swift
//  RedHotChiliDevs
//
//  Created by Augusto Lima on 11/4/2026.
//

import Foundation

extension Date {
    
    /// Provides a localized string representation of the date using
    /// `DateFormatter` with `.medium` date style and `.short` time style.
    var dateTimeBaseFormat: String {
        DateFormatter.baseFormatter.string(from: self)
    }
}
