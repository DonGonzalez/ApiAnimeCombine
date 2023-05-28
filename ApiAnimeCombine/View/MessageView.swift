//
//  fregrtgfd.swift
//  ApiAnimeCombine
//
//  Created by Robert B on 28/05/2023.
//

import Foundation
import UIKit
import Foundation
import Combine

class MessageView: UIView {
    
    private var errorData: MessageErrorType?
    
    init(errorData: MessageErrorType) {
        self.errorData = errorData
        super.init(frame: .zero)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        // titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 20)
        titleLabel.isHighlighted = true
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 1
        titleLabel.text = "Message:"
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    private let messageLabel: UILabel = {
        let messageLabel = UILabel()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.font = .systemFont(ofSize:15)
        messageLabel.isHighlighted = false
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.adjustsFontSizeToFitWidth = true
        messageLabel.baselineAdjustment = .alignCenters
        messageLabel.lineBreakMode = .byWordWrapping
        return messageLabel
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.layer.cornerRadius = 8
        stackView.spacing = 1
        stackView.axis = .vertical
        stackView.alignment = .center
        //  stackView.distribution = .fillEqually
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(messageLabel)
        return stackView
    }()
    
    private func configure() {
        self.layer.cornerRadius = 8
        self.addSubview(stackView)
        stackView.backgroundColor = errorData?.backgroundColor
        messageLabel.text = errorData?.message
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            stackView.leftAnchor.constraint(equalTo: self.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: self.rightAnchor)
        ])
        NSLayoutConstraint.activate([
            messageLabel.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])
    }
}
