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
        self.backgroundColor = K.Colors.loadingBackground
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
            spinninCircleView.widthAnchor.constraint(equalToConstant: K.Loading.spinninCircleViewWidthAnchor),
            spinninCircleView.heightAnchor.constraint(equalToConstant: K.Loading.spinninCircleViewHeightAnchor),
            
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
        frame = CGRect(x: K.Loading.spinningCircleFrameX, y: K.Loading.spinningCircleFrameY, width: K.Loading.spinningCircleFrameWidth, height: K.Loading.spinningCircleFrameHeight)
        let rect = self.bounds
        let circularPath = UIBezierPath(ovalIn: rect)
        
        spinningCircle.path = circularPath.cgPath
        spinningCircle.fillColor = UIColor.clear.cgColor
        spinningCircle.strokeColor = UIColor.systemRed.cgColor
        spinningCircle.lineWidth = K.Loading.spinningCircleLineWidth
        spinningCircle.strokeEnd = K.Loading.spinningCircleStrokeEnd
        spinningCircle.lineCap = .round
        self.layer.addSublayer(spinningCircle)
    }
    
    func animate() {
        UIView.animate(withDuration: K.Loading.spinningCircleAnimationDuration, delay: K.Loading.spinningCircleAnimationDelay, options: .curveLinear, animations: {
            self.transform = CGAffineTransform(rotationAngle: .pi)
        }) { (completed) in
            UIView.animate(withDuration: K.Loading.spinningCircleAnimationDuration, delay: K.Loading.spinningCircleAnimationDelay, options: .curveLinear, animations: {
                self.transform = CGAffineTransform(rotationAngle: K.Loading.spinningCircleRotationAngle)
            }) { (completed) in
                self.animate()
            }
        }
    }
}

// MARK: - UIVIEW
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
