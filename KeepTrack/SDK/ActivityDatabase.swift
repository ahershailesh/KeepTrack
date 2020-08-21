//
//  ActivityDatabase.swift
//  KeepTrack
//
//  Created by Shailesh Aher on 19/08/20.
//  Copyright © 2020 Shailesh Aher. All rights reserved.
//

import Foundation
import Firebase

typealias ErrorCallBack = (Error?) -> Void

protocol RunningActivityCollectable {
    func save(runningActivity: RunningActivity, callBack: ErrorCallBack?)
    func getRunningActivities(completion: @escaping ([RunningActivity]) -> Void)
    func remove(activity: RunningActivity)
    func update(activity: RunningActivity)
    func clearRunningActivities()
}

protocol Documentable {
    var documentID: String { get }
}

protocol FBDatabaseServable {
    func getAll<T: Decodable>(completionBlock: @escaping ([T], Error?)-> Void)
    func save<T: Encodable>(object: T, errorBlock: ErrorCallBack?)
    func update<T: Encodable & Documentable>(object: T, errorBlock: ErrorCallBack?)
    func delete<T: Documentable>(object: T, errorBlock: ErrorCallBack?)
    func delete(errorBlock: ErrorCallBack?)
}

class FBDatabaseService: FBDatabaseServable {
    private let collection: CollectionReference
    private let decoder: JSONDecoder
    
    init(path: String, decoder: JSONDecoder = JSONDecoder()) {
        self.decoder = decoder
        collection = Firestore.firestore().collection(path)
    }
    
    func getAll<T: Decodable>(completionBlock: @escaping ([T], Error?)-> Void) {
        collection.getDocuments { [weak self] (querySnapshot, err) in
            if let querySnapshot = querySnapshot {
                let objects = querySnapshot.documents.compactMap { document -> T? in
                    var dictionary = document.data()
                    dictionary["documentID"] = document.documentID
                    if let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted) {
                        let object = try? self?.decoder.decode(T.self, from: data)
                        return object
                    } else {
                        return nil
                    }
                }
                completionBlock(objects, nil)
            } else if let err = err {
                completionBlock([], err)
            }
        }
    }
    
    func save<T: Encodable>(object: T, errorBlock: ErrorCallBack?) {
        guard let dictionary = object.dict else { errorBlock?(nil); return  }
        collection.addDocument(data: dictionary, completion: errorBlock)
    }
    
    func update<T: Encodable & Documentable>(object: T, errorBlock: ErrorCallBack?) {
        guard let dictionary = object.dict else { errorBlock?(nil); return  }
        collection.document(object.documentID).updateData(dictionary, completion: errorBlock)
    }
    
    func delete<T: Documentable>(object: T, errorBlock: ErrorCallBack?) {
         collection.document(object.documentID).delete(completion: errorBlock)
    }
    
    func delete(errorBlock: ErrorCallBack?) {
        collection.getDocuments { (querySnapshot, err) in
            if let querySnapshot = querySnapshot {
                querySnapshot.documents.forEach { document in
                    document.reference.delete()
                }
                errorBlock?(nil)
            } else if let err = err {
                errorBlock?(err)
            }
        }
    }
}
