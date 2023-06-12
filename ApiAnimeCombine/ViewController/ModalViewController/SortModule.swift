//
//  SortModule.swift
//  ApiAnimeCombine
//
//  Created by Robert B on 08/06/2023.
//
import UIKit
import Foundation

extension ModalViewController {
    
    // MARK: Configuration BoxButton
    func createBoxButton (numberOfButtons: Int, view: UIViewController) {
        
        lazy var radioScrollView: UIScrollView = {
            let scroll = UIScrollView()
            scroll.translatesAutoresizingMaskIntoConstraints = false
            return scroll
        }()
        
        let container: UIStackView = {
            let stack = UIStackView()
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.axis = .vertical
            stack.spacing = 5
            stack.alignment = .leading
            stack.distribution = .fillEqually
            return stack
        }()
        
        view.view.addSubview(radioScrollView)
        NSLayoutConstraint.activate([
            radioScrollView.widthAnchor.constraint(equalTo: view.view.widthAnchor, multiplier: 0.8),
            radioScrollView.heightAnchor.constraint(equalTo: view.view.heightAnchor, multiplier: 0.4),
            radioScrollView.centerYAnchor.constraint(equalTo: view.view.centerYAnchor),
            radioScrollView.centerXAnchor.constraint(equalTo: view.view.centerXAnchor)
        ])
        
        radioScrollView.addSubview(container)
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: radioScrollView.topAnchor),
            container.leftAnchor.constraint(equalTo: radioScrollView.leftAnchor),
            container.widthAnchor.constraint(equalTo: radioScrollView.widthAnchor),
            container.heightAnchor.constraint(equalTo: radioScrollView.heightAnchor)
        ])
        
        var boxArray: [UIButton] = []
        for i in SortType.allCases {
            let boxButton = UIButton(type: .custom, primaryAction: UIAction(title: i.title, handler: { action in
                let chosenSort = SortType.type(title: action.title)
                // MARK: BoxButton logic
                for boxButton in boxArray {
                    if boxButton.titleLabel?.text == action.title && boxButton.isSelected == false {
                        boxButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
                        boxButton.isSelected = true
                        self.boxSelectedArray.append(chosenSort)
                    } else if boxButton.titleLabel?.text == action.title && boxButton.isSelected == true   {
                        boxButton.setImage(UIImage(systemName: "square"), for: .normal)
                        boxButton.isSelected = false
                        self.boxSelectedArray.removeAll {$0.self == chosenSort}
                    }
                }
            }))
            boxButton.translatesAutoresizingMaskIntoConstraints = false
            // Configure image, use information from AnimeVC
            if self.boxSelectedArray.contains(i) == true {
                boxButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
                boxButton.isSelected = true
            } else {
                boxButton.setImage(UIImage(systemName: "square"), for: .normal)
            }
            // I can't move image to left and set padding
            boxButton.setTitleColor(.black, for: .normal)
            boxButton.tintColor = .black
            // Configuration doesn't work
            boxButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 100, bottom: 0, right: 0)
            boxButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
            boxButton.contentHorizontalAlignment = .leading
            boxArray.append(boxButton)
            container.addArrangedSubview(boxButton)
            NSLayoutConstraint.activate([
                boxButton.widthAnchor.constraint(equalTo: container.widthAnchor),
                boxButton.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
        
        let clearButton = UIButton(type: .system, primaryAction: UIAction(handler: { action in
            self.boxSelectedArray.removeAll()
            restetButtonImage(boxArray)
        }))
        
        clearButton.setTitle("Clear", for: .normal)
        clearButton.setTitleColor(.black, for: .normal)
        clearButton.backgroundColor = .systemBlue
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(clearButton)
        NSLayoutConstraint.activate([
            clearButton.topAnchor.constraint(equalTo: container.bottomAnchor, constant: 8),
            clearButton.leftAnchor.constraint(equalTo: container.leftAnchor),
            clearButton.widthAnchor.constraint(equalToConstant: 80),
            clearButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        let confirmButton = UIButton(type: .system, primaryAction: UIAction(handler: { [weak self] action in
            // Pass information about selected sort to AnimeVC
            self?.sortSelect.send(self?.boxSelectedArray ?? [])
            self?.clickSortButton.send()
            self?.dismiss(animated: false, completion: nil)
        }))
        confirmButton.setTitle("Confirm & Exit", for: .normal)
        confirmButton.setTitleColor(.black, for: .normal)
        confirmButton.backgroundColor =  .systemGray5
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(confirmButton)
        NSLayoutConstraint.activate([
            confirmButton.topAnchor.constraint(equalTo: container.bottomAnchor, constant: 8),
            confirmButton.rightAnchor.constraint(equalTo: container.rightAnchor),
            confirmButton.widthAnchor.constraint(equalToConstant: 130),
            confirmButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        //Where put this??
        func restetButtonImage(_ sender: [UIButton]){
            var i = 0
            while i <= sender.count - 1 {
                do {
                    sender[i].setImage(UIImage(systemName: "square"), for: .normal)
                    sender[i].isSelected = false
                    i += 1
                }
            }
        }
    }
}
