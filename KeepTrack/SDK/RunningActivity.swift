//
//  RunningActivity.swift
//  KeepTrack
//
//  Created by Shailesh Aher on 19/08/20.
//  Copyright © 2020 Shailesh Aher. All rights reserved.
//

import Foundation

struct RunningActivity: Performable, Codable, Documentable {
    var activity: Activity { return .running }
    
    private(set) var documentID: String = "-1"
    let distance: Int
    let startTime: String
    let endTime: String
    let rounds: Int
    let dayTime: DayTime
    let note: String
}
