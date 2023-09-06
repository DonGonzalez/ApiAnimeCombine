//
//  vfdvdfv.swift
//  ApiAnimeCombine
//
//  Created by Robert B on 28/05/2023.
//

import Foundation
import UIKit
import Foundation
import Combine

class DetailAnimeViewModel : UIViewController {
    
   private var navigator: UINavigationController?
   private var publishedSingleData = PassthroughSubject<Anime,ErrorMessage>()
    var singleData: SingleAnime?
    
   private init(navigator: UINavigationController, singleData: SingleAnime) {
        super.init(nibName: nil, bundle: nil)
        self.navigator = navigator
        self.singleData = singleData
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension DetailAnimeViewModel {
    
    static func create(navigator: UINavigationController, singleData:SingleAnime) {
        let viewModel = DetailAnimeViewModel(navigator: navigator, singleData: singleData)
        let vc = DetailAnimeViewController()
        vc.assignDependencies(viewModel: viewModel)
        vc.title = "CombineAnimeDetail"
        vc.view.backgroundColor = .white
        navigator.pushViewController(vc, animated: false)
        if #available(iOS 16.0, *) {
            navigator.navigationItem.backBarButtonItem?.isHidden = false
        } else {
            // Fallback on earlier versions
        }
    }
}
