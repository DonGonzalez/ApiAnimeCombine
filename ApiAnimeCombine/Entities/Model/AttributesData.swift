//
//  fdfdf.swift
//  ApiAnimeCombine
//
//  Created by Robert B on 28/05/2023.
//

import Foundation

struct AttributesData: Decodable {
    let createdAt: String?
    let updatedAt: String?
    let description: String?
    let canonicalTitle: String?
    let episodeCount: Int?
    let posterImage: PosterImageData?
}
