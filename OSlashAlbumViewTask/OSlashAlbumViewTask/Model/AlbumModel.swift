//
//  AlbumModel.swift
//  OSlashAlbumViewTask
//
//  Created by Dilip on 25/10/22.
//

import Foundation

// MARK: - albumDatum
struct albumDatum: Codable {
    let id: String
    let width, height: Int
    let urls: Urls

    enum CodingKeys: String, CodingKey {
        case id
        case width, height
        case urls
    }
}


// MARK: - Urls
struct Urls: Codable {
    let raw, full, regular, small: String
    let thumb, smallS3: String

    enum CodingKeys: String, CodingKey {
        case raw, full, regular, small, thumb
        case smallS3 = "small_s3"
    }
}


typealias albumData = [albumDatum]


