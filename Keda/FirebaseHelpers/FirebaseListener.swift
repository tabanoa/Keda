//
//  FirebaseListener.swift
//  Keda Profile
//
//  Created by Matthew Mukherjee on 12/22/2020.
import Foundation
import Firebase


class FirebaseListener {
    
    static let shared = FirebaseListener()
    
    private init() {}
    
    //MARK: - FUser
    func downloadCurrentUserFromFirebase(userId: String, email: String) {
        
        FirebaseReference(.User).document(userId).getDocument { (snapshot, error) in
            
            guard let snapshot = snapshot else { return }
            
            if snapshot.exists {
                
                let user = FUser(_dictionary: snapshot.data() as! NSDictionary)
                user.saveUserLocally()
                
                user.getUserAvatarFromFirestore { (didSet) in
                    
                }
                
            } else {
                //first login
                
                if let user = userDefaults.object(forKey: kCURRENTUSER) {
                    FUser(_dictionary: user as! NSDictionary).saveUserToFireStore()
                }
                
            }
        }
    }
    
    func downloadUsersFromFirebase(isInitialLoad: Bool, limit: Int, lastDocumentSnapshot: DocumentSnapshot?, completion: @escaping (_ users: [FUser], _ snapshot: DocumentSnapshot?) ->Void) {
        
        var query: Query!
        var users: [FUser] = []
        
        let ageFrom = Int(userDefaults.object(forKey: kAGEFROM) as? Float ?? 18.0)
        let ageTo = Int(userDefaults.object(forKey: kAGETO) as? Float ?? 30.0)

        
        if isInitialLoad {
            query = FirebaseReference(.User).whereField(kAGE, isGreaterThan: ageFrom).whereField(kAGE, isLessThan: ageTo).whereField(kISMALE, isEqualTo: isclothingSizeMale()).limit(to: limit)
            
            print("first \(limit) users loading")
            
        } else {
            
            if lastDocumentSnapshot != nil {
                query = FirebaseReference(.User).whereField(kAGE, isGreaterThan: ageFrom).whereField(kAGE, isLessThan: ageTo).whereField(kISMALE, isEqualTo: isclothingSizeMale()).limit(to: limit).start(afterDocument: lastDocumentSnapshot!)
                
                print("next \(limit) user loading")

            } else {
                print("last snapshot is nil")
            }
        }
        
        if query != nil {
            
            query.getDocuments { (snapShot, error) in
                
                guard let snapshot = snapShot else { return }
                
                if !snapshot.isEmpty {
                    
                    for userData in snapshot.documents {
                        
                        let userObject = userData.data() as NSDictionary
                    }
                    
                    completion(users, snapshot.documents.last!)
                    
                } else {
                    print("no more users to fetch")
                    completion(users, nil)
                }
                
            }
            
        } else {
            completion(users, nil)
        }
    }
    
    
    func downloadUsersFromFirebase(withIds: [String], completion: @escaping (_ users: [FUser]) -> Void) {
        
        var usersArray: [FUser] = []
        var counter = 0
        
        for userId in withIds {
            
            FirebaseReference(.User).document(userId).getDocument { (snapshot, error) in
                
                guard let snapshot = snapshot else { return }
                
                if snapshot.exists {
                    
                    usersArray.append(FUser(_dictionary: snapshot.data()! as NSDictionary))
                    counter += 1
                    
                    if counter == withIds.count {
                        
                        completion(usersArray)
                    }
                    
                } else {
                    completion(usersArray)
                }
            }
        }
    }
    
    //MARK: - RecentChats
    func downloadRecentChatsFromFireStore(completion: @escaping (_ allRecents: [RecentChat]) -> Void) {
        
        FirebaseReference(.Recent).whereField(kSENDERID, isEqualTo: FUser.currentId()).addSnapshotListener { (querySnapshot, error) in
            
            var recentChats: [RecentChat] = []
            
            guard let snapshot = querySnapshot else { return }
            
            if !snapshot.isEmpty {
                
                for recentDocument in snapshot.documents {
                    
                    if recentDocument[kLASTMESSAGE] as! String != "" && recentDocument[kCHATROOMID] != nil && recentDocument[kOBJECTID] != nil {
                        
                        recentChats.append(RecentChat(recentDocument.data()))
                    }
                }
                
                recentChats.sort(by: { $0.date > $1.date })
                completion(recentChats)
                
            } else {
                completion(recentChats)
            }
        }
    }

    func updateRecents(chatRoomId: String, lastMessage: String) {
        
        FirebaseReference(.Recent).whereField(kCHATROOMID, isEqualTo: chatRoomId).getDocuments { (snapshot, error) in
            
            guard let snapshot = snapshot else { return }
            
            if !snapshot.isEmpty {
                
                for recent in snapshot.documents {
                    
                    let recentChat = RecentChat(recent.data())
                    
                    self.updateRecentItem(recent: recentChat, lastMessage: lastMessage)
                }
            }
        }
    }
    
    
    private func updateRecentItem(recent: RecentChat, lastMessage: String) {
        
        if recent.senderId != FUser.currentId() {
            recent.unreadCounter += 1
        }
        
        let values = [kLASTMESSAGE : lastMessage, kUNREADCOUNTER: recent.unreadCounter, kDATE : Date()] as [String: Any]
        
        
        FirebaseReference(.Recent).document(recent.objectId).updateData(values) { (error) in
            print("error updating recent ", error)
        }
    }
    
    func resetRecentCounter(chatRoomId: String) {
        
        FirebaseReference(.Recent).whereField(kCHATROOMID, isEqualTo: chatRoomId).whereField(kSENDERID, isEqualTo: FUser.currentId()).getDocuments { (snapshot, error) in
            
            guard let snapshot = snapshot else { return }
            
            if !snapshot.isEmpty {
                
                if let recentData = snapshot.documents.first?.data() {
                    let recent = RecentChat(recentData)
                    self.clearUnreadCounter(recent: recent)
                }
            }
        }
    }
    
    func clearUnreadCounter(recent: RecentChat) {
        
        let values = [kUNREADCOUNTER : 0] as [String : Any]
        
        FirebaseReference(.Recent).document(recent.objectId).updateData(values) { (error) in
            
            print("Reset recent counter", error)
        }
    }
}
