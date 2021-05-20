//
//  Step.swift
//  ProjectOneTestingApp
//
//  Created by Sohan Samant on 5/18/21.
//
// the main objective of this model is to associate the steps with the date

import Foundation

/* simple model to be used */
struct Step: Identifiable {

    let id = UUID()
    let count: Int
    let date: Date
    
}
