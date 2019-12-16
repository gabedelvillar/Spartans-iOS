//
//  MatchesHorizontalController.swift
//  Spartans
//
//  Created by Gabriel Del VIllar De Santiago on 12/15/19.
//  Copyright © 2019 Gabriel Del VIllar De Santiago. All rights reserved.
//

import LBTATools
import Firebase

class MatchesHorizontalController: LBTAListController<MatchesCell, Match>{
    weak var rootMatchesController: MatchesMessagesController?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        
        fetchMatches()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 4, bottom: 0, right: 16)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let match = self.items[indexPath.item]
//        let controller = ChatLogController(match: match)
//        navigationController?.pushViewController(controller, animated: true)
        rootMatchesController?.didSelectMatchFromHeader(match: match)
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

extension MatchesHorizontalController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 110, height: view.frame.height)
       }
    
}
