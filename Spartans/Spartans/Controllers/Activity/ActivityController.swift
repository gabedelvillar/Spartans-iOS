//
//  ActivityController.swift
//  Spartans
//
//  Created by Gabriel Del VIllar De Santiago on 12/16/19.
//  Copyright © 2019 Gabriel Del VIllar De Santiago. All rights reserved.
//

import UIKit
import HealthKit
import LBTATools

//struct TodayActivity{
//    let energyBurned, restEnergyBurned, stepCount, distanceWalkingRunning, flightsClimbed: String
//
//    init(dictionary: [String: HKQuantity]) {
//        self.energyBurned = "\(dictionary["HKQuantityTypeIdentifierActiveEnergyBurned"]?.doubleValue(for: .kilocalorie()) ?? 0.0) kCal"
//        self.restEnergyBurned = "\(dictionary["HKQuantityTypeIdentifierBasalEnergyBurned"]?.doubleValue(for: .kilocalorie()) ?? 0.0) kCal"
//        self.stepCount = "\(dictionary["HKQuantityTypeIdentifierStepCount"]?.doubleValue(for: .count()) ?? 0.0) steps"
//        self.distanceWalkingRunning = "\(dictionary["HKQuantityTypeIdentifierDistanceWalkingRunning"]?.doubleValue(for: .mile()) ?? 0.0) mi"
//        self.flightsClimbed = "\(dictionary["HKQuantityTypeIdentifierFlightsClimbed"]?.doubleValue(for: .count()) ?? 0.0) floors"
//    }
//}

struct TodayActivity{
    let activityType: String
    let activityUnit: String
    
    init(activityType: String, activityUnit: String) {
        self.activityType = activityType
        self.activityUnit = activityUnit
    }
    
}

class TodayActivityCell: LBTAListCell<TodayActivity> {
    
    let activityTypeLabel = UILabel()
    let activityUnitLabel = UILabel()
    
    override var item: TodayActivity!{
        didSet {
            self.activityTypeLabel.text = item.activityType
            self.activityUnitLabel.text = item.activityUnit
        }
    }
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        layer.cornerRadius = 6.0
        clipsToBounds = true
        
        activityTypeLabel.textColor = #colorLiteral(red: 0.9995598197, green: 0.2849038243, blue: 0.004397562239, alpha: 1)
        activityUnitLabel.font = .systemFont(ofSize: 25, weight: .bold)
        hstack(stack(activityTypeLabel, activityUnitLabel, spacing: 16), alignment: .center).padLeft(20)
        
    }
}

class ActivityController: LBTAListController<TodayActivityCell, TodayActivity>{
    
   
    
    
    // MARK: Lifecylce Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        collectionView.contentInset = .init(top: 20, left: 20, bottom: 20, right: 20)
        collectionView.backgroundColor = #colorLiteral(red: 0.9500772357, green: 0.9445468783, blue: 0.9707426429, alpha: 1)
        setupHealthStore()
       
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    // MARK: Fileprivate
    
    fileprivate func getActivity(quantityTypeIdentifier: HKQuantityTypeIdentifier, quantityString: String){
       
        
        let calendar = NSCalendar.current
        
        var interval = DateComponents()
        
        interval.day = 1
        
        // set anchor date to Monday at 3:00am
        
        var anchorComponents = calendar.dateComponents([.day, .month, .year, .weekday], from: Date())
        
        //let offset = (1 + (anchorComponents.day!) - 2) % 7
        anchorComponents.day! -= 1
        anchorComponents.hour = 0
        
        guard let anchorDate = calendar.date(from: anchorComponents) else {return}
        
        guard let quantityType = HKSampleType.quantityType(forIdentifier: quantityTypeIdentifier) else{
                   print("Active Energy Burned is no longer available in HealthKit")
                   return
               }
        
        // create query
        let query = HKStatisticsCollectionQuery(quantityType: quantityType, quantitySamplePredicate: nil, options: .cumulativeSum, anchorDate: anchorDate, intervalComponents: interval)
        
        // set the result handler
        query.initialResultsHandler = { query, results, err in
            guard let statsCollection = results else {
                return
            }
            
            let endDate = Date()
            guard let startDate = calendar.date(byAdding: .day, value: 0, to: endDate) else {return}
            
            
            // step counts ovet the past 3 months
            statsCollection.enumerateStatistics(from: startDate, to: endDate) {[unowned self] statistics, stop in
                
                if let quantity = statistics.sumQuantity(){
                    let date = statistics.startDate
                    //let value = quantity.doubleValue(for: HKUnit.count())
                   
                  
                    print(quantityTypeIdentifier.rawValue)
                    print("DATE: ", date)
                    print("VALUE: ", quantity)
                    
                    
                    let activity = TodayActivity(activityType: quantityString, activityUnit: "\(quantity)")
                    self.items.append(activity)
                    
                    
                }
            }
            
        }
        
       
        HKHealthStore().execute(query)
  
    }
    fileprivate func setupHealthStore() {
        if HKHealthStore.isHealthDataAvailable() {
            
            let healthStore = HKHealthStore()
            
            guard let energyBurned = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned),
                let restEnergyBurned = HKObjectType.quantityType(forIdentifier: .basalEnergyBurned),
                let stepCount = HKObjectType.quantityType(forIdentifier: .stepCount),
                let distanceWalkingRunning = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning),
                let flightsClimbed = HKObjectType.quantityType(forIdentifier: .flightsClimbed)
            else {
                return
            }
            let allTypes = Set([ HKObjectType.workoutType(),
                                 energyBurned,
                                 restEnergyBurned,
                                 stepCount,
                                 distanceWalkingRunning,
                                 flightsClimbed,
                                 
                
            ])
            
            
            
            healthStore.requestAuthorization(toShare: nil, read: allTypes) { (success, err) in
                if !success {
                    print("Failed to get user authorizatoin to read activity data")
                    if let err = err{
                        print("Failed to get user authorizatoin to read activity data: ", err)
                        return
                    }
                }
                
                print("successfully received authorizaton by the user to read activity data")
                self.getActivity(quantityTypeIdentifier: .activeEnergyBurned, quantityString: "Active Energy")
                self.getActivity(quantityTypeIdentifier: .basalEnergyBurned, quantityString: "Resting Energy")
                self.getActivity(quantityTypeIdentifier: .stepCount, quantityString: "Steps")
                self.getActivity(quantityTypeIdentifier: .distanceWalkingRunning, quantityString: "Walking + Running Distance")
                self.getActivity(quantityTypeIdentifier: .flightsClimbed, quantityString: "Flights Climbed")
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
        
    }

    
    
}

// MARK: Extensions
extension ActivityController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       return .init(width: view.frame.width - 40, height: 110)
    }
}
