//
//  ContentView.swift
//  ProjectOneTestingApp
//
//  Created by Sohan Samant on 5/17/21.
//

import SwiftUI
import HealthKit

struct ContentView: View {
    
    // Creating private variable for health store new class
    private var healthStore: HealthStore?
    
    // List for storing the steps
    @State private var steps: [Step] = [Step]()
    
    // initializing health store with our new class
    init() {
        
        healthStore = HealthStore()
    }
    
    /* A function to calculate steps and update UI */
    private func updateUIFromStatistics(statisticsCollection: HKStatisticsCollection){
        
        // current date minus seven days
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        let endDate = Date()
        
        // enumerator to loop over the 7 day statistics
        statisticsCollection.enumerateStatistics(from: startDate, to: endDate) { (statistics, stop) in
            
            // variable for count the steps
            let count = statistics.sumQuantity()?.doubleValue(for: .count())
            
            // variable for getting steps
            let step = Step(count: Int(count ?? 0), date: statistics.startDate)
         
            // add element to List: step
            steps.append(step)
            
        }
    }
    
    var body: some View {
        
        Text("")
        Text("")
        Text("")
        Text("Project One Testing IOS Application").bold().foregroundColor(.yellow)
        Text("")
        
        Text("Displaying Step counts from Sohan's iPhone")
            .bold()
            .font(.headline)
            .foregroundColor(.blue)
            .italic()
            .fontWeight(.heavy)

        /* Display steps on the app */
        List(steps, id: \.id) { step in
            
            /* wrap the steps in vertical stack */
            VStack {
                Text("Steps: "+"\(step.count)").foregroundColor(.green)
                Text(step.date, style: .date).opacity(0.5)
            }
            
        }
            
            // After the screen appears do the following
            .onAppear {
                
                if let healthStore = healthStore {
                
                    // if Authorization is successfull then go and get steps data
                    healthStore.requestAuthorization { success in
                        
                        if success {
                            
                            healthStore.calculateSteps { statisticsCollection in
                                
                                if let statisticsCollection = statisticsCollection {
                                 
                                    // Update the UI here now. Calling update step function
                                    updateUIFromStatistics(statisticsCollection: statisticsCollection)
                                    
                                }
                            }
                        }
                    }
                }
            }
        }
    
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

