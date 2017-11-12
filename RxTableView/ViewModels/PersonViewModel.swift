//
//  PersonViewModel.swift
//  RxTableView
//
//  Created by Kevin Le on 11/9/17.
//  Copyright © 2017 OptimumStack. All rights reserved.
//

import Foundation
import RxSwift

final class PersonViewModel {
    var observableUsers: Observable<[User]>?
    
    init(restClient _restClient:RESTClient) {
        restClient = _restClient
        
        /*
        let observables = restClient.getUsers();
        self.observableUsers = observables
            .map { people in
                people.data.map { person in
                    User(name: "\(person.first_name) \(person.last_name)", image: person.avatar)
                }
            }
            .observeOn(MainScheduler.instance)
            .share(replay:1)
        */
        
        self.observableUsers = restClient.getUsers()
            .map {
                $0.data.map {
                    User(name: "\($0.first_name) \($0.last_name)", image: $0.avatar)
                }
            }
            .observeOn(MainScheduler.instance)
            .share(replay:1)
    }
    
    // MARK: - Private
    private let restClient: RESTClient!
}
