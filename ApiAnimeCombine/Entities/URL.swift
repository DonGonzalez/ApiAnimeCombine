//
//  ghfcdfgx.swift
//  ApiAnimeCombine
//
//  Created by Robert B on 28/05/2023.
//

import Foundation


extension URL {
    
    static func makeURLWithEndpoint(endpoint: String) -> URL {
        URL(string:"https://kitsu.io/api/edge\(endpoint)")!
    }
}
