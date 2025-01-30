//
//  Artist.swift
//  Art Gallery
//
//  Created by Игорь Клевжиц on 29.01.2025.
//

import UIKit

struct Artist: Codable {
    let name: String
    let bio: String
    let image: String
    let works: [Work]
}
