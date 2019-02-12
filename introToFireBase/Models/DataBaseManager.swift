//
//  DataBaseManager.swift
//  introToFireBase
//
//  Created by Oniel Rosario on 2/12/19.
//  Copyright © 2019 Oniel Rosario. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth


final class DataBaseManager {
    private init() {}
    static var db: Firestore = {
        let store = Firestore.firestore()
        return store
    }()
    
    static func postRaceReviewToDatabase() {
        var ref: DocumentReference? = nil
        ref = db.collection("raceReviews").addDocument(data: ["racename":"NYC Marathon"], completion: { (error) in
            if let error = error {
                print("posting race failed with error: \(error)")
            } else {
                print("post created at ref: \(ref?.documentID ?? "no document ID")")
            }
        })
    }
}
