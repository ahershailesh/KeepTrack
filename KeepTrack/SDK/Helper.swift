//
//  Helper.swift
//  KeepTrack
//
//  Created by Shailesh Aher on 19/08/20.
//  Copyright © 2020 Shailesh Aher. All rights reserved.
//

import Foundation

extension Encodable {
    var dict : [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else { return nil }
        return json
    }
}
