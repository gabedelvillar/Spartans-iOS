//
//  CardView.swift
//  Spartans
//
//  Created by Gabriel Del VIllar De Santiago on 12/3/19.
//  Copyright © 2019 Gabriel Del VIllar De Santiago. All rights reserved.
//

import UIKit
import SDWebImage

protocol CardViewDelegate {
    func showMoreInfo(cardViewModel: CardViewModel)
}

class CardView: UIView {
    
    var delegate: CardViewDelegate?
    
    var cardViewModel: CardViewModel! {
        didSet {
//            let imageName = cardViewModel.imageUrls.first ?? ""
//            // load our image using some kind of url instead
//            if let url = URL(string: imageName){
////                imageView.sd_setImage(with: url)
//                imageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "top_left_profile"), options: .continueInBackground)
//            }
            swipingPhotosController.cardViewModel = self.cardViewModel
            
            informationLabel.attributedText = cardViewModel.attributedString
            informationLabel.textAlignment = cardViewModel.textAlignment
            
            (0..<cardViewModel.imageUrls.count).forEach { (_) in
                    let barView = UIView()
                    barView.backgroundColor = barDeselectedColor
                    barsStackView.addArrangedSubview(barView)
                }
                
                barsStackView.arrangedSubviews.first?.backgroundColor = .white
                setupImageIndexObserver()
        }
    }
    
    
    
    // encapsulation
//    fileprivate let imageView = UIImageView(image: #imageLiteral(resourceName: "kelly3"))
    fileprivate let swipingPhotosController = SwipingPhotosController(isCardViewMode: true)
    fileprivate  let gardiantLayer = CAGradientLayer()
    fileprivate let informationLabel = UILabel()
    fileprivate let barsStackView = UIStackView()
    // MARK:- Configurations
    fileprivate let threshHold: CGFloat = 80


    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        
        addGestureRecognizer(panGesture)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    var imageIndex = 0
    fileprivate let barDeselectedColor = UIColor(white: 0, alpha: 0.1)
    
    //MARK:- Fileprivate
    
    fileprivate func setupImageIndexObserver(){
        cardViewModel.imageIndexObserver = { [weak self] (idx, imageUrl) in
//            if let url = URL(string: imageUrl ?? "") {
//                 self?.imageView.sd_setImage(with: url)
//            }
           
            
            self?.barsStackView.arrangedSubviews.forEach { (view) in
                view.backgroundColor = self?.barDeselectedColor
            }
            
            self?.barsStackView.arrangedSubviews[idx].backgroundColor = .white
        }
    }
    
    @objc fileprivate func handleTap(gesture: UITapGestureRecognizer) {
        let tapLocation = gesture.location(in: nil)
        let shouldAdvanceNextPhoto = tapLocation.x > frame.width / 2 ? true : false
        
        if shouldAdvanceNextPhoto {
            cardViewModel.advanceToNextPhoto()
        } else{
            cardViewModel.goToPreviousPhoto()
        }
        
    }
    
    fileprivate let moreInfoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "info_icon").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleMoreInfo), for: .touchUpInside)
        
        return button
    }()
    
    @objc fileprivate func handleMoreInfo(){
        
        delegate?.showMoreInfo(cardViewModel: self.cardViewModel)
    }
    
    fileprivate func setupLayout() {
        // custom drawing code
        layer.cornerRadius = 10
        clipsToBounds = true
        
        let swipingPhotosView = swipingPhotosController.view!
        addSubview(swipingPhotosView)
        swipingPhotosView.fillSuperview()
        
//        setupBarsStackView()
        
        // gradiant layer
        setupGradiantLayer()
        
        addSubview(informationLabel)
        informationLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 16))
        
        informationLabel.textColor = .white
        
        informationLabel.numberOfLines = 0
        
        addSubview(moreInfoButton)
        moreInfoButton.anchor(top: nil, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 16, right: 16), size: .init(width: 44, height: 44))
    }
    
    fileprivate func setupBarsStackView(){
        addSubview(barsStackView)
        barsStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 8, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 4))
        
        barsStackView.spacing = 4
        barsStackView.distribution = .fillEqually
        
    }
    
    fileprivate func setupGradiantLayer(){
       
        gardiantLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gardiantLayer.locations = [0.5, 1.1]
        layer.addSublayer(gardiantLayer)
        
    }
    
    override func layoutSubviews() {
        gardiantLayer.frame = self.frame
    }
    
    @objc fileprivate func handlePan(gesture: UIPanGestureRecognizer){
        
        
        switch gesture.state {
        case .began:
            self.superview?.subviews.last?.layer.removeAllAnimations()
        case .changed:
            handleChanged(gesture)
        case .ended:
            handleEnded(gesture)
        default:
            ()
        }
    }
    
    fileprivate func handleChanged(_ gesture: UIPanGestureRecognizer) {
        
        // rotation
        let translation = gesture.translation(in: nil)
        let degrees: CGFloat = translation.x / 20
        let angle = degrees * .pi / 180
        
        let rotationalTansformation = CGAffineTransform(rotationAngle: angle)
        self.transform = rotationalTansformation.translatedBy(x: translation.x, y: translation.y)
        
      }
    
    fileprivate func handleEnded(_ gesture: UIPanGestureRecognizer) {
        
        let translationDirection: CGFloat = gesture.translation(in: nil).x > 0 ? 1:-1
        let shouldDismissCard = abs(gesture.translation(in: nil).x) > threshHold
        
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            
            if shouldDismissCard {
                
                self.layer.frame = CGRect(x: 600 * translationDirection, y: 0, width: self.frame.width, height: self.frame.height)
                

                
            } else {
                self.transform = .identity
            }
            
        }) { (_) in
            self.transform = .identity
            if shouldDismissCard{
                self.removeFromSuperview()
            }
            
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
