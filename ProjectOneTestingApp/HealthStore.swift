//
//  HealthStore.swift
//  ProjectOneTestingApp
//
//  Created by Sohan Samant on 5/18/21.
//  Class for all health realted details

import Foundation
import HealthKit


extension Date {
    
    static func mondayAt12AM() -> Date {
        
        return Calendar(identifier: .iso8601).date(from: Calendar(identifier:
                                                                    .iso8601).dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
    }
}

class HealthStore {
    
    // creating object for the class
    var healthStore: HKHealthStore?
    
    /* */
    var query: HKStatisticsCollectionQuery?
    
    
    // initializing the object
    init() {
        
        // checking if health data is available or not
        if(HKHealthStore.isHealthDataAvailable()){
            
            healthStore = HKHealthStore()
        }
        else {
            return
        }
    }
    
    
    /* - Function for calculating steps - */
    
    func calculateSteps(completion: @escaping (HKStatisticsCollection?) -> Void) {
        
        /* Since we are calculating steps, we initialize variable */
        let stepType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        
        /* Define from when do you want to start counting the dates */
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())
        
        /* Get start time of the day: Day will start at 12 AM */
        let anchorDate = Date.mondayAt12AM()
        
        /* We need to calculate steps daily, so we need to declare the variable */
        let daily = DateComponents(day: 1)
     
        /* Creating a variable to query the data
           This variable will be used for accessing the samples.
           strictStartDate means the sample must fall withint
         */
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)
        
        
        /* To perform the query we need to create Query Object
           Options: cumulativeSum - means get data from watch and get from iphone too..One day you went with watch and other                         day you went with iphone..Calculate both of them together.
         
         */
        query = HKStatisticsCollectionQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum, anchorDate: anchorDate, intervalComponents: daily)
    
    
        /*  Below is actual call back handler.
            Query Handler will get fired whenever we execute the query
            
         */
        query!.initialResultsHandler = { query, statisticsCollection, error in
            completion(statisticsCollection)
        }
        
        /* After creating the query, we are executing the query */
        if let healthStore = healthStore, let query = self.query {
            
            healthStore.execute(query)
            
        }
    
    }
    
    
    // requesting authorization for accessing health data
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        
        /* Since we only need step counts, we need to initialize step count variables */
        let stepType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        
        guard let healthStore = self.healthStore else { return completion(false) }
        
        /*
            Requesting authorization function to give a pop-up
            in the app for the user so that user can give consent in sharing their health data.
            Below function will be called from main calls (ContentView.swift)
        */
        
        healthStore.requestAuthorization(toShare: [], read: [stepType]) { (success, error) in
            
            completion(success)
        }
        
    }
    
    
    
    
    
}
