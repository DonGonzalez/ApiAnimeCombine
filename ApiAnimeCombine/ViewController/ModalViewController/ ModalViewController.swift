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
        dissmisButton.addTarget(self, action: #selector(dissmisModalViewController), for: .touchUpInside)
    }
    
    @objc func dissmisModalViewController() {
        if self.modalType == .filter{
            self.selectedFilter = nil
            self.dismiss(animated: false, completion: nil)
        }
        if self.modalType == .sort{
            self.boxSelectedArray.removeAll()
            self.dismiss(animated: false, completion: nil)
        }
        
    }
    
    override func viewDidLoad() {
        configureModalVC()
        setup(modalType: modalType)
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
                self.dimmingView.removeFromSuperview()
            }, completion: { _ in
            })
        }
    }
}
