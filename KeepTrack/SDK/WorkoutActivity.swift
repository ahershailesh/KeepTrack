//
//  Workout.swift
//  KeepTrack
//
//  Created by Shailesh Aher on 19/08/20.
//  Copyright © 2020 Shailesh Aher. All rights reserved.
//

import Foundation

struct WorkoutActivity: Performable, Decodable {
    var activity: Activity { return .workout }

    let startTime: String
    let endTime: String
    let rounds: Int
    let dayTime: DayTime
    let weight: Float
    let note: String
}
