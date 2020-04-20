//
//  StringExtension.swift
//  GitSearcher
//
//  Created by Dinesh Danda on 4/1/20.
//  Copyright © 2020 Dinesh Danda. All rights reserved.
//

import Foundation

extension String {
func localized() -> String {
    return NSLocalizedString(self, comment: "")
}
}
