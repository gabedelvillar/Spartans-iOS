//
//  ViewController.swift
//  Spartans
//
//  Created by Gabriel Del VIllar De Santiago on 11/29/19.
//  Copyright © 2019 Gabriel Del VIllar De Santiago. All rights reserved.
//

import UIKit

class HomeController: UIViewController {
    
    let cardsDeckView = UIView()
    let buttonsStackView = HomeBottomControlsStackView()
    
    let cardViewModels: [CardViewModel] = {
        let producers = [
            User(name: "Kelly", age: 23, activitty: "Endurance Training", imageNames: ["kelly1", "kelly2", "kelly3"]),
            User(name: "Jane", age: 18, activitty: "Powerlifting", imageNames: ["jane1, jane2, jane3"])
        ] as [ProduceCardViewModel]
        
        let viewModels = producers.map({return $0.toCardViewModel()})
        
        return viewModels
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupLayout()
        
        setupDummyCards()
    }
    
    // MARK:- Fileprivate
    
    fileprivate func setupDummyCards(){
        cardViewModels.forEach { (cardViewModel) in
            let cardView = CardView(frame: .zero)
            cardView.cardViewModel = cardViewModel
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperview()
        }
    }
    
    fileprivate func setupLayout() {
        let overallStackView = UIStackView(arrangedSubviews: [cardsDeckView, buttonsStackView])
        
        overallStackView.axis = .vertical
        
        view.addSubview(overallStackView)
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        
        
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 0, left: 8, bottom: 0, right: 8)
        
        overallStackView.bringSubviewToFront(cardsDeckView)
    }


}

