//
//  AnalyticsManager.swift
//  Sharelist
//
//  Created by Hugues Fils on 30/12/2023.
//

import Foundation
import FirebaseAnalytics

final class AnalyticsManager {
    
    private init() {}
    
    static let shared = AnalyticsManager()
    
    public func logEventAccountCreated() {
//        Analytics.logEvent("AccountCreated", parameters: <#T##[String : Any]?#>)
    }
    
}
