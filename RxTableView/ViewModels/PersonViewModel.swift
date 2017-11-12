//
//  PersonViewModel.swift
//  RxTableView
//
//  Created by Kevin Le on 11/9/17.
//  Copyright © 2017 OptimumStack. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

final class StringKey : NSObject {
    let string: String
    init(string: String) {
        self.string = string
    }
    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? StringKey else {
            return false
        }
        return string == other.string
    }
    
    override var hash: Int {
        return string.hashValue
    }
}

let imageCache = NSCache<StringKey, UIImage>()


final class PersonViewModel {
    var observableUsers: Observable<[RenderedPerson]>?
    
    init(restClient:RESTClient) {
        
        self.observableUsers = restClient.getUsers()
            .map {
                $0.data.flatMap {
                    RenderedPerson(name: "\($0.first_name) \($0.last_name)", image: self.imageFromURL(imageUrl: $0.avatar))
                }
            }
            .observeOn(MainScheduler.instance)
            .share(replay:1)
    }
    
    // MARK: - Private
    private func imageFromURL(imageUrl urlString: String) -> UIImage? {
        if let imageFromCache = imageCache.object(forKey: StringKey(string: urlString)) {
            return imageFromCache
        }
        
        if let url = NSURL(string: urlString) {
            if let data = NSData(contentsOf: url as URL) {
                let imageFromUrl = UIImage(data: data as Data)!
                imageCache.setObject(imageFromUrl, forKey: StringKey(string: urlString))
                return imageFromUrl
            }
        }
        
        return nil
    }
}
