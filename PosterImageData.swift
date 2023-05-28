//
//  bfbb.swift
//  ApiAnimeCombine
//
//  Created by Robert B on 28/05/2023.
//

import Foundation

struct PosterImageData: Decodable {
    let tiny: String
    let large: String
    let small: String
    let medium: String
    let original: String
}
