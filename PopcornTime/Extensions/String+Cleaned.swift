//
//  String+Cleaned.swift
//  PopcornTime
//
//  Created by Stephen Radford on 23/03/2016.
//  Copyright © 2016 PopcornTime. All rights reserved.
//

import Foundation

extension String {
    
    var cleaned: String {
        var s = stringByReplacingOccurrencesOfString("&amp;", withString: "&")
        s = s.stringByReplacingOccurrencesOfString("&", withString: "&amp;")
        s = s.stringByReplacingOccurrencesOfString("\"", withString: "&quot;")
        return s
    }
    
}