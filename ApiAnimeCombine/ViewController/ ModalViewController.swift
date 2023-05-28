//
//  fdgfgsd.swift
//  ApiAnimeCombine
//
//  Created by Robert B on 28/05/2023.
//

import Foundation
import Foundation
import UIKit
import Combine


class ModalViewController: UIViewController, UISearchBarDelegate {
    // MARK: Enums
    enum UserFilterOption {
        case sort
        case filter
        
        var title: String {
            switch self {
            case .sort: return "Sort"
            case .filter: return  "Filter"
            }
        }
    }
    
    enum FilterType: String, CaseIterable {
        case winter
        case spring
        case summer
        case fall
        case emptyEnum
        
        var title: String {
            switch self {
            case .winter:
                return "Winter"
            case .spring:
                return "Spring"
            case .summer:
                return "Summer"
            case .fall:
                return "Fall"
            case .emptyEnum:
                return "None"
            }
        }
        
        var filterValue: String {
            switch self {
            case .winter:
                return "&filter[season]=winter"
            case .spring:
                return "&filter[season]=spring"
            case .summer:
                return "&filter[season]=summer"
            case.fall:
                return "&filter[season]=fall"
            case .emptyEnum:
                return ""
            }
        }
        
        static func type( title: String) -> FilterType {
            return FilterType.allCases.first { $0.title == title} ?? .winter
        }
    }
    
    enum SortType: String, CaseIterable {
        
        case User_Count
        case Favorites_Count
        case Episode_Count
        
        var title: String {
            switch self {
            case .User_Count:
                return "User Count"
            case .Favorites_Count:
                return "Favorites Count"
            case .Episode_Count:
                return "Episode Count"
            }
        }
        var sortValue: String {
            switch self {
            case .User_Count:
                return "userCount"
            case .Favorites_Count:
                return "favoritesCount"
            case .Episode_Count:
                return "episodeCount"
            }
        }
        
        static func type( title: String) -> SortType {
            return SortType.allCases.first { $0.title == title} ?? .User_Count
        }
    }
    // MARK: Variable
    var viewModel: AnimeViewModel?
    // var use to configure ModalVC
    var modalType: UserFilterOption!
    // vars with data from AnimeMV
    var filterSelect: ModalViewController.FilterType?
    // use to configure ModalVC
    let customTransitioningDelegate = TransitioningDelegate()
    // save inf. about selected radioButton
    var selectedFilter: FilterType?
    // MARK: Publisher
    var modalCancelable = Set<AnyCancellable>()
    // save info. about selected boxButton
    var boxSelectedArray: [ModalViewController.SortType] = []
    var clickSortButton = PassthroughSubject<Void,Never>()
    var clickFilterButton = PassthroughSubject<Void,Never>()
    var sortSelect = PassthroughSubject<[ModalViewController.SortType],Never>()
    var filteSelect = PassthroughSubject<ModalViewController.FilterType,Never>()
    
    // MARK: Common content for sort and filter VM
    let dissmisButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.white
        button.setImage(UIImage(systemName: "xmark.seal"), for: .normal)
        button.imageView?.heightAnchor.constraint(lessThanOrEqualToConstant: 35).isActive = true
        button.imageView?.widthAnchor.constraint(lessThanOrEqualToConstant: 35).isActive = true
        button.addTarget(ModalViewController.self, action: #selector(dissmisModalViewController), for: .touchUpInside)
        button.tintColor = UIColor.systemBlue
        return button
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .center
        label.isHighlighted = true
        label.numberOfLines = 0
        return label
    }()
    
    private func configureModalVC () {
        self.view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.widthAnchor.constraint(equalToConstant: self.view.bounds.width - 100),
            titleLabel.heightAnchor.constraint(equalToConstant: 50),
            titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
        self.transitioningDelegate = customTransitioningDelegate
        self.view.addSubview(dissmisButton)
        NSLayoutConstraint.activate([
            dissmisButton.widthAnchor.constraint(equalToConstant: 40),
            dissmisButton.heightAnchor.constraint(equalToConstant: 40),
            dissmisButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10),
            dissmisButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10)
        ])
    }
    
    @objc func dissmisModalViewController() {
        if self.modalType == .filter{
            self.selectedFilter = nil
            self.dismiss(animated: true, completion: nil)
        }
        if self.modalType == .sort{
            self.boxSelectedArray.removeAll()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        configureModalVC()
        setup(modalType: modalType)
    }
    override func viewWillAppear(_ animated: Bool) {
        print("modalVC")
    }
    
    // MARK: Initial
    init(modalType: UserFilterOption, sortSelect: [ModalViewController.SortType], filterSelect: ModalViewController.FilterType){
        super.init(nibName: nil, bundle: nil)
        self.modalType =  modalType
        self.filterSelect = filterSelect
        self.boxSelectedArray = sortSelect
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(modalType: UserFilterOption) {
        
        titleLabel.text = modalType.title
        
        //MARK: Create views for Sort option
        if modalType == .sort {
            self.createBoxButton(numberOfButtons: 3, view: self)
        }
        //MARK: Create views for Filter option
        if modalType == .filter {
            self.createRadioButton(numberOfButtons: 3, view: self)
        }
    }
    
    //MARK: RadioButton
    private func createRadioButton (numberOfButtons: Int, view: UIViewController) {
        
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
                print("Button tapped!")
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
                print(chosenFilter)
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
            print("click Confirm")
            // Pass information about selected filter to AnimeVC
            if self.selectedFilter != nil {
                self.clickFilterButton.send()
                self.filteSelect.send(selectedFilter!)
                self.dismiss(animated: false, completion: nil)
            }
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
    
    // MARK: Configuration BoxButton
    private func createBoxButton (numberOfButtons: Int, view: UIViewController) {
        
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
                print("Button tapped!")
                // MARK: BoxButton logic
                for boxButton in boxArray {
                    if boxButton.titleLabel?.text == action.title && boxButton.isSelected == false {
                        boxButton.setImage(UIImage(systemName: "circle.fill"), for: .normal)
                        boxButton.isSelected = true
                        self.boxSelectedArray.append(chosenSort)
                    } else if boxButton.titleLabel?.text == action.title && boxButton.isSelected == true   {
                        boxButton.setImage(UIImage(systemName: "circle"), for: .normal)
                        boxButton.isSelected = false
                        self.boxSelectedArray.removeAll {$0.self == chosenSort}
                    }
                }
                print(chosenSort)
            }))
            boxButton.translatesAutoresizingMaskIntoConstraints = false
            // Configure image, use information from AnimeVC
            if self.boxSelectedArray.contains(i) == true {
                boxButton.setImage(UIImage(systemName: "circle.fill"), for: .normal)
                boxButton.isSelected = true
            } else {
                boxButton.setImage(UIImage(systemName: "circle"), for: .normal)
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
            print("clickclear")
            
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
            print("click Confirm")
            // Pass information about selected sort to AnimeVC
            self?.sortSelect.send(self?.boxSelectedArray ?? [])
            self?.clickSortButton.send()
            self?.dismiss(animated: true, completion: nil)
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
            print(sender)
            var i = 0
            while i <= sender.count - 1 {
                do {
                    sender[i].setImage(UIImage(systemName: "circle"), for: .normal)
                    sender[i].isSelected = false
                    print("resetImage")
                    print(i)
                    i += 1
                }
            }
        }
    }
    
    //MARK: ModalVC window settings
    class TransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
        func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
            return PresentationController(presentedViewController: presented, presenting: presenting)
        }
    }
    
    class PresentationController: UIPresentationController {
        override var frameOfPresentedViewInContainerView: CGRect {
            let bounds = presentingViewController.view.bounds
            let size = CGSize(width: bounds.width - 50, height: bounds.height/2)
            let origin = CGPoint(x: bounds.midX - size.width / 2, y: bounds.midY - size.height / 2)
            return CGRect(origin: origin, size: size)
        }
        
        override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
            super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
            
            presentedView?.autoresizingMask = [
                .flexibleTopMargin,
                .flexibleBottomMargin,
                .flexibleLeftMargin,
                .flexibleRightMargin
            ]
            presentedView?.translatesAutoresizingMaskIntoConstraints = true
        }
        // MARK: Blurr effect
        let dimmingView: UIView = {
            let dimmingView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
            dimmingView.translatesAutoresizingMaskIntoConstraints = false
            return dimmingView
        }()
        
        override func presentationTransitionWillBegin() {
            super.presentationTransitionWillBegin()
            
            let superview = presentingViewController.view!
            superview.addSubview(dimmingView)
            NSLayoutConstraint.activate([
                dimmingView.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
                dimmingView.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
                dimmingView.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
                dimmingView.topAnchor.constraint(equalTo: superview.topAnchor)
            ])
            dimmingView.alpha = 0
            presentingViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
                self.dimmingView.alpha = 0.7
            }, completion: nil)
        }
        
        override func dismissalTransitionWillBegin() {
            super.dismissalTransitionWillBegin()
            presentingViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
                self.dimmingView.alpha = 0
            }, completion: { _ in
                self.dimmingView.removeFromSuperview()
            })
        }
    }
}
