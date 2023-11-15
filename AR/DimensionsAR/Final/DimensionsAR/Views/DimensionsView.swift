//
//  DimensionsView.swift
//  DimensionsAR
//
//  Created by Tony Ngo on 06.10.2022.
//

import UIKit

final class DimensionsView: UIView {
    let widthLabel = UILabel()
    let heightLabel = UILabel()
    let depthLabel = UILabel()

    init() {
        super.init(frame: .zero)

        let stack = UIStackView(arrangedSubviews: [widthLabel, heightLabel, depthLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
