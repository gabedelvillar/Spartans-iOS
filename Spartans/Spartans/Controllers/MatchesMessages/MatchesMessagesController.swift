//
//  MatchesMessages.swift
//  Spartans
//
//  Created by Gabriel Del VIllar De Santiago on 12/11/19.
//  Copyright © 2019 Gabriel Del VIllar De Santiago. All rights reserved.
//

import LBTATools
import Firebase

struct Match{
    let name, profileImageUrl: String
    
    init(dictionary: [String: Any]) {
        self.name = dictionary["name"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
    }
}

class MatchesCell: LBTAListCell<Match> {
    
    let profileImageView = UIImageView(image: #imageLiteral(resourceName: "kelly1").withRenderingMode(.alwaysOriginal), contentMode: .scaleAspectFill)
    let usernameLabel  = UILabel(text: "Username", font: .systemFont(ofSize: 14, weight: .semibold), textColor: .darkGray, textAlignment: .center, numberOfLines: 2)
    
    override var item: Match!{
        didSet{
            usernameLabel.text = item.name
            profileImageView.sd_setImage(with: URL(string: item.profileImageUrl))
            
        }
    }
    
    override func setupViews() {
        super.setupViews()
        profileImageView.clipsToBounds = true
        profileImageView.constrainWidth(80)
        profileImageView.constrainHeight(80)
        profileImageView.layer.cornerRadius = 80 / 2
        stack(stack(profileImageView, alignment: .center), usernameLabel)
    }
}

class MatchesMessagesController: LBTAListController<MatchesCell, Match>  {
    override func viewDidLoad(){
        super.viewDidLoad()
        
        
        
        fetchMatches()
        
        collectionView.backgroundColor = .white
        
        
    }
    
    // MARK: Fileprivate
    
    fileprivate func fetchMatches(){
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        
        Firestore.firestore().collection("matches_messages").document(currentUserId).collection("matches").getDocuments { (querySnpahot, err) in
            if let err = err {
                print("Failed to fetch matches", err)
                return
            }
            
            var matches = [Match]()
            querySnpahot?.documents.forEach({ (documentSnapshot) in
                let dictionary = documentSnapshot.data()
                matches.append(.init(dictionary: dictionary))
            })
            
            self.items = matches
            self.collectionView.reloadData()
        }
    }
    
   
}

// MARK: Extensions

extension MatchesMessagesController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 100, height: 120)
    }
}
