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
    private func imageFromURL(imageUrl url: String) -> UIImage? {
        if let url = NSURL(string: url) {
            if let data = NSData(contentsOf: url as URL) {
                return UIImage(data: data as Data)!
            }
        }
        
        return nil
    }
}
