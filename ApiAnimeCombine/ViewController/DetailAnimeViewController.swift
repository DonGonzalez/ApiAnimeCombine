//
//  dfvdfvdf.swift
//  ApiAnimeCombine
//
//  Created by Robert B on 28/05/2023.
//

import Foundation
import UIKit
import Foundation
import Combine

class DetailAnimeViewController: UIViewController {
 
    var viewModel: DetailAnimeViewModel?
 
    func assignDependencies(viewModel: DetailAnimeViewModel) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        scrollViewConfig()
    }
    
    private func scrollViewConfig() {
        let scrollView = DetailAnimeScrollView(data: viewModel!.singleData!)
        scrollView.contentSize = self.view.bounds.size
        self.view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
}
