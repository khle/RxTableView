//
//  Person.swift
//  RxTableView
//
//  Created by Kevin Le on 11/9/17.
//  Copyright © 2017 OptimumStack. All rights reserved.
//

import Foundation
import UIKit

struct Person : Decodable {
    let id: Int
    let first_name: String
    let last_name: String
    let avatar: String
}

struct People : Decodable {
    let page: Int
    let per_page: Int
    let total: Int
    let total_pages: Int
    let data: [Person]
}

struct RenderedPerson {
    let name: String
    var image: UIImage?
}
