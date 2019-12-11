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
        
        query.getDocuments { (snapshot, err) in
            self.hud.dismiss()
            if let err = err {
                print("Failed to fetch users: ", err)
                return
            }
            
            snapshot?.documents.forEach({ (documentSnapshot) in
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                if user.uid != Auth.auth().currentUser?.uid {
                    self.setupCardFromUser(user: user)
                }
                
//                self.cardViewModels.append(user.toCardViewModel())
//                self.lastFetchUser = user
                
            })
            
        }
    }
    
    fileprivate func setupCardFromUser(user: User) {
        let cardView = CardView(frame: .zero)
        cardView.delegate = self
        cardView.cardViewModel = user.toCardViewModel()
        cardsDeckView.addSubview(cardView)
        cardsDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
    }
    
    
    @objc fileprivate func handleRefresh(){
        fetchUsersFromFirestore()
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
    
    
}

