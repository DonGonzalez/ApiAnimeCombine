//
//  FilterModule.swift
//  ApiAnimeCombine
//
//  Created by Robert B on 08/06/2023.
//

import UIKit
import Foundation

extension ModalViewController {
    
    //MARK: RadioButton
    func createRadioButton (numberOfButtons: Int, view: UIViewController) {
        
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
            radioScrollView.heightAnchor.constraint(equalTo: view.view.heightAnchor, multiplier: 0.6),
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
        
        var buttonArray: [UIButton] = []
        for i in FilterType.allCases {
            
            let radioButton = UIButton(type: .custom, primaryAction: UIAction(title: i.title, handler: { action in
                let chosenFilter = FilterType.type(title: action.title)
                // MARK: RadioButton logic
                for radioButton in buttonArray {
                    
                    if radioButton.titleLabel?.text == action.title {
                        
                        radioButton.setImage(UIImage(systemName: "circle.fill"), for: .normal)
                        self.selectedFilter = chosenFilter
                    } else {
                        radioButton.setImage(UIImage(systemName: "circle"), for: .normal)
                    }
                }
                // if user dont chose filter, button will be inactive
            }
                                                                             ))
            radioButton.translatesAutoresizingMaskIntoConstraints = false
            // Configure image, use information from AnimeVC
            if radioButton.titleLabel?.text ==  self.filterSelect?.title {
                radioButton.setImage(UIImage(systemName: "circle.fill"), for: .normal)
            } else {
                radioButton.setImage(UIImage(systemName: "circle"), for: .normal)
            }
            radioButton.setTitleColor(.black, for: .normal)
            radioButton.tintColor = .black
            radioButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 100, bottom: 0, right: 0)
            radioButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
            radioButton.imageView?.contentMode = .scaleAspectFill
            radioButton.contentHorizontalAlignment = .leading
            buttonArray.append(radioButton)
            container.addArrangedSubview(radioButton)
            NSLayoutConstraint.activate([
                radioButton.widthAnchor.constraint(equalTo: container.widthAnchor)
            ])
        }
        
        let confirmButton = UIButton(type: .system, primaryAction: UIAction(handler: { [self] action in
            // Pass information about selected filter to AnimeVC
            self.clickFilterButton.send()
            self.filteSelect.send(selectedFilter ?? .emptyEnum)
            self.dismiss(animated: false, completion: nil)
            
            
        }))
        confirmButton.setTitle("Confirm & Exit", for: .normal)
        confirmButton.setTitleColor(.black, for: .normal)
        confirmButton.backgroundColor =  .systemBlue
        confirmButton.layer.cornerRadius = 6
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(confirmButton)
        NSLayoutConstraint.activate([
            confirmButton.topAnchor.constraint(equalTo: container.bottomAnchor, constant: 8),
            confirmButton.rightAnchor.constraint(equalTo: container.rightAnchor),
            confirmButton.widthAnchor.constraint(equalToConstant: 130),
            confirmButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
}
