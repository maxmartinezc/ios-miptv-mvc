//
//  LoadingView.swift
//  mitvmvc
//
//  Created by Max Martinez Cartagena on 13-03-22.
//

import UIKit

class LoadingView: UIView {

    let spinninCircleView: SpinninCircleView = {
        let scv = SpinninCircleView()
        scv.translatesAutoresizingMaskIntoConstraints = false
        return scv
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = K.Colors.background.withAlphaComponent(0.6)
        addSubview(spinninCircleView)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        NSLayoutConstraint.activate([
                        
            spinninCircleView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            spinninCircleView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            spinninCircleView.widthAnchor.constraint(equalToConstant: 100),
            spinninCircleView.heightAnchor.constraint(equalToConstant: 100),
            
        ])
    }

}

class SpinninCircleView: UIView {
    let spinningCircle = CAShapeLayer()
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        animate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        let rect = self.bounds
        let circularPath = UIBezierPath(ovalIn: rect)
        
        spinningCircle.path = circularPath.cgPath
        spinningCircle.fillColor = UIColor.clear.cgColor
        spinningCircle.strokeColor = UIColor.systemRed.cgColor
        spinningCircle.lineWidth = 10
        spinningCircle.strokeEnd = 0.25
        spinningCircle.lineCap = .round
        self.layer.addSublayer(spinningCircle)
        
    }
    func animate() {
        UIView.animate(withDuration: 1, delay: 0, options: .curveLinear, animations: {
            self.transform = CGAffineTransform(rotationAngle: .pi)
        }) { (completed) in
            UIView.animate(withDuration: 1, delay: 0, options: .curveLinear, animations: {
                self.transform = CGAffineTransform(rotationAngle: 0)
            }) { (completed) in
                self.animate()
            }
        }
    }
}

extension UIView {
    func showLoading() {
        let loadingView = LoadingView(frame: frame)
        self.addSubview(loadingView)
    }

    func hideLoading() {
        if let loadingView = subviews.first(where: { $0 is LoadingView }) {
            loadingView.removeFromSuperview()
        }
    }
}
