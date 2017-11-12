//
//  RESTClient.swift
//  RxTableView
//
//  Created by Kevin Le on 11/9/17.
//  Copyright © 2017 OptimumStack. All rights reserved.
//

import Foundation
import RxSwift

enum RESTClientError: Error {
    case JSONUndecodable
    case HttpError(status: Int)
    case Other(NSError)
}

final class RESTClient {
    
    init(configuration: URLSessionConfiguration = URLSessionConfiguration.default) {
        self.session = URLSession(configuration: configuration)
    }
    
    func getUsers() -> Observable<People> {
        
        return Observable.create { observer in
            let task = self.session.dataTask(with: self.url) { data, response, error in
                
                if let error = error {
                    observer.onError(RESTClientError.Other(error as NSError))
                } else {
                    guard let HTTPResponse = response as? HTTPURLResponse else {
                        fatalError("Error HTTP response")
                    }
                    
                    if 200 ..< 300 ~= HTTPResponse.statusCode {
                        do {
                            let people = try JSONDecoder().decode(People.self, from: data!)
                            observer.onNext(people)
                        } catch _ {
                            observer.onError(RESTClientError.JSONUndecodable)
                        }
                        
                        observer.onCompleted()
                    }
                    else {
                        observer.onError(RESTClientError.HttpError(status: HTTPResponse.statusCode))
                    }
                }
            }
            
            task.resume()
            
            return Disposables.create(with: {
                task.cancel()
            })
        }
    }
    
    // MARK: - Private
    private let url: URL = URL(string: "https://reqres.in/api/users")!
    private let session: URLSession
}
