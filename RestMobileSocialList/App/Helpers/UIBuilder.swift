//
//  UIBuilder.swift
//  RestMobileSocialList
//
//  Created by Олег Дмитриев on 06.07.2025.
//

import UIKit

class UIBuilder {
    
    let offsetPage: CGFloat = 16
    let screenSizeW: CGFloat = UIScreen.main.bounds.width
    
    func addOnboardingImage(_ image: String, scale: UIView.ContentMode = .scaleAspectFit) -> UIImageView {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = UIImage(named: image)
        img.contentMode = scale
        img.layer.masksToBounds = true
        
        return img
    }
    
    func addOnboardingGradient(x: Int, y: Int) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.transform = CGAffineTransform(rotationAngle: .pi / 4)
        
        // обновляю гражиент после установки constraints
        DispatchQueue.main.async {
            view.addGradient(
                colors: [
                    UIColor(red: 81/255, green: 81/255, blue: 198/255, alpha: 1),
                    UIColor(red: 81/255, green: 81/255, blue: 198/255, alpha: 0)
                ],
                startPoint: CGPoint(x: x, y: y),
                endPoint: CGPoint(x: x, y: y)
            )
        }
        
        return view
    }
    
    func addLabel(_ text: String, fz: CGFloat = 16, fw: UIFont.Weight = .regular, numLine: Int = 0, color: UIColor = .black) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.numberOfLines = numLine
        label.font = .systemFont(ofSize: fz, weight: fw)
        label.textColor = color
        return label
    }
    
    func addButton(_ title: String) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.setTitleColor(.appWhite, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = .appBtnGray.withAlphaComponent(0.4)
        button.layer.cornerRadius = 26
        
        return button
    }
    
}
