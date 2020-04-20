//
//  AppLocalizedStrings.swift
//  GitSearcher
//
//  Created by Dinesh Danda on 4/1/20.
//  Copyright © 2020 Dinesh Danda. All rights reserved.
//

import Foundation

enum AppLocalizedStrings: String {
  case discription = "GitHub Searcher"
  case details = "Details"
    
    var localized: String {
        return self.rawValue.localized()
    }
}


