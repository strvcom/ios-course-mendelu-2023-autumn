//
//  ExamplesViewController.swift.swift
//  SampleARApp
//
//  Created by Tony Ngo on 02.09.2022.
//

import Foundation
import UIKit

enum Example: String, CaseIterable {
    case customScene = "SceneKit scene"
    case realityComposer = "RC scene"
    case customBezierPath = "Geometry from bezier path"
    case customGeometry = "Custom Geometry"
    case planeDetection = "Plane detection"
    case bodyTracking = "Body tracking"
    case vision = "Vision - hand tracking"
}

extension Example {
    func viewController() -> UIViewController {
        switch self {
        case .customScene:
             SceneKitModelExample()
        case .customBezierPath:
             BezierPathGeometryExample()
        case .customGeometry:
             GeometryExample()
        case .planeDetection:
             PlaneDetectionExample()
        case .bodyTracking:
             BodyTrackingExample()
        case .vision:
             VisionHandExample()
        case .realityComposer:
            RCExample()
        }
    }
}

final class ExamplesViewController: UIViewController {

    static let cellIdentifier: String = "ExampleCell"

    private let examples: [Example] = Example.allCases

    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "AR Examples"
        setupUI()
    }
}

extension ExamplesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellIdentifier) else {
            fatalError()
        }

        var config = UIListContentConfiguration.cell()
        config.text = examples[indexPath.row].rawValue
        cell.contentConfiguration = config
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        examples.count
    }
}

extension ExamplesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let viewController = examples[indexPath.row].viewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
}

private extension ExamplesViewController {
    func setupUI() {
        tableView.delegate = self

        tableView.dataSource = self

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.cellIdentifier)

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
