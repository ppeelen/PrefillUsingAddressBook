//
//  StringHelpers.swift
//  Prefill
//
//  Created by Paul Peelen on 2016-01-20.
//  Copyright © 2016 Dashbox. All rights reserved.
//

import Foundation

extension String {
    
    /// Trim a string
    var trimmedString: String {
        return stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
    
}