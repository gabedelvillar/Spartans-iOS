//
//  ViewController.swift
//  Spartans
//
//  Created by Gabriel Del VIllar De Santiago on 11/29/19.
//  Copyright © 2019 Gabriel Del VIllar De Santiago. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD


class HomeController: UIViewController {
    
    
    let cardsDeckView = UIView()
    let bottomControls = HomeBottomControlsStackView()
    
    var cardViewModels = [CardViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        bottomControls.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        bottomControls.likeButton.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        bottomControls.dislikeButton.addTarget(self, action: #selector(handleDislike), for: .touchUpInside)
        
        setupLayout()
        
        fetchCurrentUser()
        
//        setupFirestoreUserCards()

    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // kick out the user when they logout
        if Auth.auth().currentUser == nil{
            let registrationController = RegistrationController()
            let navController = UINavigationController(rootViewController: registrationController)
            navController.modalPresentationStyle = .fullScreen
            present(navController, animated: true)
        }
    }
    
    // MARK:- Fileprivate
    
    var lastFetchUser: User?
    
    fileprivate var user: User?
    fileprivate let hud = JGProgressHUD(style: .dark)
    
    var topCardView: CardView?
    
    @objc fileprivate func handleDislike(){
        
       performSwipeAnimation(translation: -700, angle: -15)
    }
    
    fileprivate func performSwipeAnimation(translation: CGFloat, angle: CGFloat){
        let duration = 0.5
               
               let translationAnimation = CABasicAnimation(keyPath: "position.x")
               translationAnimation.toValue = translation
               translationAnimation.duration = duration
               translationAnimation.fillMode = .forwards
               translationAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
               translationAnimation.isRemovedOnCompletion = false
               
               let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
               rotationAnimation.toValue = angle * CGFloat.pi / 180
               rotationAnimation.duration = duration
               
               let cardView = topCardView
               topCardView = cardView?.nextCardView
               
               CATransaction.setCompletionBlock {
                   cardView?.removeFromSuperview()
                  
               }
               
               cardView?.layer.add(translationAnimation, forKey: "translation")
               cardView?.layer.add(rotationAnimation, forKey: "rotation")
               
               CATransaction.commit()
    }
    
    @objc fileprivate func handleLike(){
        
        performSwipeAnimation(translation: 700, angle: 15)
        
    }
    
    fileprivate func fetchCurrentUser(){
        hud.textLabel.text = "Loading"
        hud.show(in: view)
        cardsDeckView.subviews.forEach({$0.removeFromSuperview()})
        
        Firestore.firestore().fetchCurrentUser { (user, err) in
            if let err = err{
                print("Failed to fetch user", err)
                self.hud.dismiss()
                return
            }
            
            self.user = user
            self.fetchUsersFromFirestore()
        }
       
    }
    
    fileprivate func fetchUsersFromFirestore() {

        var query: Query = Firestore.firestore().collection("users")
        
        if let activity = user?.activity{
            query = Firestore.firestore().collection("users").whereField("activity", isEqualTo: activity)
        }
        
        topCardView = nil
        query.getDocuments { (snapshot, err) in
            self.hud.dismiss()
            if let err = err {
                print("Failed to fetch users: ", err)
                return
            }
            
            var previousCardView: CardView?
            
            snapshot?.documents.forEach({ (documentSnapshot) in
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                if user.uid != Auth.auth().currentUser?.uid {
                let cardView = self.setupCardFromUser(user: user)
                    previousCardView?.nextCardView = cardView
                    previousCardView = cardView
                    if self.topCardView == nil{
                        self.topCardView = cardView
                    }
                }
 
                
            })
            
        }
    }
    
    fileprivate func setupCardFromUser(user: User) -> CardView{
        let cardView = CardView(frame: .zero)
        cardView.delegate = self
        cardView.cardViewModel = user.toCardViewModel()
        cardsDeckView.addSubview(cardView)
        cardsDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
        return cardView
    }
    
    
    @objc fileprivate func handleRefresh(){
        if topCardView == nil{
            fetchUsersFromFirestore()
        }
    }
    
    fileprivate func setupFirestoreUserCards(){
        cardViewModels.forEach { (cardViewModel) in
            let cardView = CardView(frame: .zero)
            cardView.cardViewModel = cardViewModel
            cardsDeckView.addSubview(cardView)
            cardsDeckView.sendSubviewToBack(cardView)
            cardView.fillSuperview()
        }
    }
    
    fileprivate func setupLayout() {
        let overallStackView = UIStackView(arrangedSubviews: [cardsDeckView, bottomControls])
        
        overallStackView.axis = .vertical
        
        view.addSubview(overallStackView)
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        
        
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 0, left: 8, bottom: 0, right: 8)
        
        overallStackView.bringSubviewToFront(cardsDeckView)
    }


}

// MARK: Extensions

extension HomeController: SettingsControllerDelegate {
    func didSaveSettings() {
        fetchCurrentUser()
    }
    
}

extension HomeController: LoginControllerDelegate {
    func didFinishLogginIn() {
        fetchCurrentUser()
    }
    
   
    

}

extension HomeController: CardViewDelegate{
    func showMoreInfo(cardViewModel: CardViewModel) {
        let cardDetailsController = UserDetailsController()
        cardDetailsController.cardViewModel = cardViewModel
        cardDetailsController.modalPresentationStyle = .fullScreen
        present(cardDetailsController, animated: true)
    }
    
    func didRemoveCard(cardView: CardView) {
        self.topCardView?.removeFromSuperview()
        self.topCardView = self.topCardView?.nextCardView
       }
}

