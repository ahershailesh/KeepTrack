//
//  Activities.swift
//  KeepTrack
//
//  Created by Shailesh Aher on 19/08/20.
//  Copyright © 2020 Shailesh Aher. All rights reserved.
//

import Foundation

enum Activity: String, Codable {
    case running, sleeping, working, workout
}

enum DayTime: String, Codable {
    case morning, afternoon, evening, night
}
