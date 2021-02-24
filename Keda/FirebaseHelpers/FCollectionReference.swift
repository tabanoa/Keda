//
//  FCollectionReference.swift
//  Keda Profile
//
//  Created by Matthew Mukherjee on 12/22/2020.

import Foundation
import FirebaseFirestore


enum FCollectionReference: String {
    case User
    case Recent
    case Messages
    case Typing
}


func FirebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference {
    
    return Firestore.firestore().collection(collectionReference.rawValue)
}
