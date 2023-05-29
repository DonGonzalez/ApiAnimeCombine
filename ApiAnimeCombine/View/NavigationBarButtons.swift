//
//  dfgfdgfdgf.swift
//  ApiAnimeCombine
//
//  Created by Robert B on 28/05/2023.
//

import Foundation
import Foundation
import UIKit

extension AnimeViewController {
    
    func createNavigationBarButtons() {
        
        let sortButton = UIBarButtonItem(barButtonSystemItem: .search,
                                         target: self,
                                         action: #selector(sortActionBT))
        
        
        let filterButton = UIBarButtonItem(barButtonSystemItem: .organize,
                                           target: self,
                                           action:#selector(filterActionBT))
        
        
        sortButton.customView?.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        navigationItem.setRightBarButtonItems([sortButton, filterButton], animated: false)
    }
    
    @objc private func filterActionBT () {
        self.modalViewControler.send(ModalViewController.UserFilterOption.filter)
        self.toolBarItemDidTap(type: .filter)
        self.searchBar.searchTextField.isUserInteractionEnabled = false
    }
    
    @objc private func sortActionBT () {
        self.toolBarItemDidTap(type: .sort)
        self.modalViewControler.send(ModalViewController.UserFilterOption.sort)
        self.searchBar.searchTextField.isUserInteractionEnabled = false
    }
    
    func toolBarItemDidTap(type: ModalViewController.UserFilterOption) {
        
        if type == .sort {
            print("sort tap")
            let modalCV = self.viewModel?.createUserFiltringMenu(modalType: type, sortSelect: self.viewModel?.sortDataToSend ?? [], filterSelect:  self.viewModel?.filterDataToSend ?? .emptyEnum)
            self.present(modalCV!, animated: false)
        }
        if type == .filter {
            print("filter tap")
            let modalCV = self.viewModel?.createUserFiltringMenu(modalType: type, sortSelect:  self.viewModel?.sortDataToSend ?? [], filterSelect:  self.viewModel?.filterDataToSend ?? .emptyEnum )
            self.present(modalCV!, animated: false)
        }
    }
}



