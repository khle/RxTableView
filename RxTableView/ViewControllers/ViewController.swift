//
//  ViewController.swift
//  RxTableView
//
//  Created by Kevin Le on 11/9/17.
//  Copyright © 2017 OptimumStack. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindings()
    }
    
    // MARK: - Private
    private let viewModel: PersonViewModel = PersonViewModel(restClient: RESTClient())
    private func setupBindings() {
        viewModel.observableUsers?.bind(to: tableView.rx.items(cellIdentifier: "cell")) {
            _, person, cell in
            if let currentCell = cell as? TableViewCell {
                currentCell.label.text = person.name
                currentCell.imgView.image = person.image
                //currentCell.imgView.setImageFromURL(imageUrl: person.image)
            }
            }.disposed(by: disposeBag)
    }
}

