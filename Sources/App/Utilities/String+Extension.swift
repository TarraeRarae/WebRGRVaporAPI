//
//  File.swift
//  
//
//  Created by TarraeRarae on 04.09.2022.
//

import Foundation

extension String {
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}
