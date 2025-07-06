//
//  OnboardingViewController.swift
//  RestMobileSocialList
//
//  Created by Олег Дмитриев on 06.07.2025.
//

import UIKit

protocol OnboardingViewControllerDelegate: AnyObject {
    func onboardingDidFinish()
}

class OnboardingViewController: UIViewController {
    
    weak var delegate: OnboardingViewControllerDelegate?
    
    private let builder = UIBuilder()
    
    private lazy var onboardingImageView: UIImageView = builder.addImage("onboarding-bg", scale: .scaleToFill)
    
    private lazy var onboardingLabel: UILabel = builder.addLabel("Rest Mobile", fz: 28, fw: .bold, color: .white)
    
    private lazy var onboardingImageOne = builder.addImage("onboarding-01")
    private lazy var onboardingImageTwo = builder.addImage("onboarding-02")
    private lazy var onboardingImageThree = builder.addImage("onboarding-03")
    private lazy var onboardingImageFour = builder.addImage("onboarding-04")
    
    private lazy var onboardingGradientOne: UIView = builder.addOnboardingGradient(x: 1, y: 0)
    private lazy var onboardingGradientTwo: UIView = builder.addOnboardingGradient(x: 0, y: 1)
    
    private lazy var onboardingBtn: UIButton = builder.addButton("GET STARTED")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateImages()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        [onboardingImageOne, onboardingImageTwo, onboardingImageThree, onboardingImageFour].forEach {
            $0.alpha = 0
            $0.transform = CGAffineTransform(translationX: 0, y: 20)
        }
        
        [onboardingLabel, onboardingBtn].forEach {
            $0.alpha = 0
        }
        
        view.addSubviews(onboardingImageView, onboardingLabel, onboardingGradientOne, onboardingGradientTwo, onboardingImageOne, onboardingImageTwo, onboardingImageThree, onboardingImageFour, onboardingBtn)
        
        onboardingLabel.textAlignment = .center
        
        onboardingBtn.addTarget(self, action: #selector(comeToHomeView), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            onboardingImageView.topAnchor.constraint(equalTo: view.topAnchor),
            onboardingImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            onboardingImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            onboardingImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
            // MARK: Title
            onboardingLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -280),
            onboardingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            onboardingLabel.widthAnchor.constraint(equalToConstant: 340),
            
            // MARK: Gradient blocks
            onboardingGradientOne.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            onboardingGradientOne.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -130),
            onboardingGradientOne.widthAnchor.constraint(equalToConstant: 118),
            onboardingGradientOne.heightAnchor.constraint(equalToConstant: 118),
            
            onboardingGradientTwo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            onboardingGradientTwo.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 130),
            onboardingGradientTwo.widthAnchor.constraint(equalToConstant: 118),
            onboardingGradientTwo.heightAnchor.constraint(equalToConstant: 118),
            
            // MARK: Images
            onboardingImageOne.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            onboardingImageOne.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            onboardingImageOne.widthAnchor.constraint(equalToConstant: 187),
            onboardingImageOne.heightAnchor.constraint(equalToConstant: 187),
            
            onboardingImageTwo.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            onboardingImageTwo.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            onboardingImageTwo.widthAnchor.constraint(equalToConstant: 163),
            onboardingImageTwo.heightAnchor.constraint(equalToConstant: 163),
            
            onboardingImageThree.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            onboardingImageThree.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            onboardingImageThree.widthAnchor.constraint(equalToConstant: 163),
            onboardingImageThree.heightAnchor.constraint(equalToConstant: 163),
            
            onboardingImageFour.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            onboardingImageFour.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100),
            onboardingImageFour.widthAnchor.constraint(equalToConstant: 187),
            onboardingImageFour.heightAnchor.constraint(equalToConstant: 187),
            
            onboardingBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            onboardingBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            onboardingBtn.widthAnchor.constraint(equalToConstant: 220),
            onboardingBtn.heightAnchor.constraint(equalToConstant: 52),
        ])
    }
    
    private func animateImages() {
        let duration: TimeInterval = 0.6
        let delayBetweenItems: TimeInterval = 0.15
        
        UIView.animate(withDuration: duration, delay: 0.1, options: .curveEaseOut, animations: {
            self.onboardingImageOne.alpha = 1
            self.onboardingImageOne.transform = .identity
        })
        
        UIView.animate(withDuration: duration, delay: 0.1 + delayBetweenItems * 1, options: .curveEaseOut, animations: {
            self.onboardingImageTwo.alpha = 1
            self.onboardingImageTwo.transform = .identity
        })
        
        UIView.animate(withDuration: duration, delay: 0.1 + delayBetweenItems * 2, options: .curveEaseOut, animations: {
            self.onboardingImageThree.alpha = 1
            self.onboardingImageThree.transform = .identity
        })
        
        UIView.animate(withDuration: duration, delay: 0.1 + delayBetweenItems * 3, options: .curveEaseOut, animations: {
            self.onboardingImageFour.alpha = 1
            self.onboardingImageFour.transform = .identity
        })
        
        UIView.animate(withDuration: duration, delay: 0.1 + delayBetweenItems * 8, options: .curveEaseOut, animations: {
            self.onboardingLabel.alpha = 1
            self.onboardingBtn.alpha = 1
        })
    }
    
    @objc
    func comeToHomeView() {
        delegate?.onboardingDidFinish()
    }
    
}
