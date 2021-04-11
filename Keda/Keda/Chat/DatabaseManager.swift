//
//  DatabaseManager.swift
//  Keda
//
//  Created by Ben Jenkyn on 2021-03-28.
//  Copyright © 2021 Keda Team. All rights reserved.
//

import Foundation
import FirebaseDatabase


final class DatabaseManager{
    public static let shared = DatabaseManager()

    private let database = Database.database().reference()
    
}

extension DatabaseManager{
    public enum DatabaseError: Error {
        case failedToFetch

        public var localizedDescription: String {
            switch self {
            case .failedToFetch:
                return "This means it failed"
            }
        }
    }
}

// MARK: - Sending Messages / conversations
extension DatabaseManager{
    ///Creates a new conversation with target user uid and first message sent
    public func createNewConversation(with otherUserUid: String, name: String, firstMessage: Message, completion: @escaping (Bool) -> Void){
        guard let currentUid = UserDefaults.standard.value(forKey: "uid") as? String else{
            return
        }
        
        let ref = database.child("User").child("\(currentUid)")
        print(ref)
        
        ref.observeSingleEvent(of: .value, with: {[weak self]snapshot in
            guard var userNode = snapshot.value as? [String: Any] else {
                completion(false)
                print("user not found")
                return
            }
            
            let messageDate = firstMessage.sentDate
            let dateString = ChatViewController.dateFormatter.string(from: messageDate)
            
            var message = ""
            
            switch firstMessage.kind{
            
            case .text(let messageText):
                message = messageText
            case .attributedText(_):
                break
            case .photo(_):
                break
            case .video(_):
                break
            case .location(_):
                break
            case .emoji(_):
                break
            case .audio(_):
                break
            case .contact(_):
                break
            case .custom(_):
                break
            }
            
            let conversationId = "conversations_\(firstMessage.messageId)"
            
            let newConversationData: [String: Any] = [
                "id": conversationId,
                "other_user_uid": otherUserUid,
                "name": name,
                "latest_message": [
                    "date": dateString,
                    "message": message,
                    "is_read": false
                ]
            ]
            
            let recipient_newConversationData: [String: Any] = [
                "id": conversationId,
                "other_user_uid": currentUid,
                "name": "Self",
                "latest_message": [
                    "date": dateString,
                    "message": message,
                    "is_read": false
                ]
            ]
            // Update recipient conversation entry
            
            self?.database.child("User").child("\(otherUserUid)/conversations").observeSingleEvent(of: .value, with: { [weak self]snapshot in
                if var conversations = snapshot.value as? [[String: Any]]{
                    //append
                    conversations.append(recipient_newConversationData)
                    self?.database.child("User").child("\(otherUserUid)/conversations").setValue(conversationId)
                    print("other user id \(otherUserUid)/conversations")
                    
                }else{
                    // create
                    self?.database.child("User").child("\(otherUserUid)/conversations").setValue([recipient_newConversationData])
                }
            })
            
            //Update current user conversation entry
            if var conversations = userNode["conversations"] as? [[String: Any]]{
                // conversation array exists for current user
                // you should append
                
                conversations.append(newConversationData)
                userNode["conversations"] = conversations
                ref.setValue(userNode, withCompletionBlock: { [weak self] error, _ in
                    guard error == nil else{
                        completion(false)
                        return
                    }
                    self?.finishCreatingConversation(name: name,
                                                     conversationID: conversationId,
                                                     firstMessage: firstMessage,
                                                     completion: completion)
                })
                
            }else{
                // Conversation array does not exist
                // Create it
                userNode["conversations"] = [
                    newConversationData
                ]
                
                ref.setValue(userNode, withCompletionBlock: { [weak self] error, _ in
                    guard error == nil else{
                        completion(false)
                        return
                    }
                    
                    self?.finishCreatingConversation(name: name,
                                                     conversationID: conversationId,
                                                     firstMessage: firstMessage,
                                                     completion: completion)
                })
            }
        })
        
    }
    
    private func finishCreatingConversation(name: String, conversationID: String, firstMessage: Message, completion: @escaping (Bool) -> Void){
//        {
//            "id": String,
//            "type": text, photo, video,
//            "content": String,
//            "date": Date(),
//            "sender_uid": String,
//            "isRead": true/false,
//        }
        
        let messageDate = firstMessage.sentDate
        let dateString = ChatViewController.dateFormatter.string(from: messageDate)
        
        var message = ""
        switch firstMessage.kind{
        case .text(let messageText):
            message = messageText
        case .attributedText(_):
            break
        case .photo(_):
            break
        case .video(_):
            break
        case .location(_):
            break
        case .emoji(_):
            break
        case .audio(_):
            break
        case .contact(_):
            break
        case .custom(_):
            break
        }

        guard let currentUserUid = UserDefaults.standard.value(forKey: "uid") as? String else{
            completion(false)
            return
        }
        
        let collectionMessage: [String: Any] = [
            "id": firstMessage.messageId,
            "type": firstMessage.kind.messageKindString,
            "content": message,
            "date": dateString,
            "sender_uid": currentUserUid ,
            "is_read": false,
            "name": name
        ]
        
        let value: [String: Any] = [
            "messages": [
                collectionMessage
            ]
        ]
        print("adding convo \(conversationID)")
        
        database.child("Conversations").child("\(conversationID)").setValue(value, withCompletionBlock: {error, _ in
            guard error == nil else{
                completion(false)
                return
            }
        })
    }
    
    ///Fetches and returns all conversations for the user with passed in uid
    public func getAllConversations(for uid: String, completion: @escaping (Result<[Conversation], Error>) -> Void){
        database.child("User").child("\(uid)/conversations").observe(.value, with: { snapshot in
            guard let value = snapshot.value as? [[String: Any]] else{
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            let conversations: [Conversation] = value.compactMap({dictionary in
                guard let conversationId = dictionary["id"] as? String,
                      let name = dictionary["name"] as? String,
                      let otherUserUid = dictionary["other_user_uid"] as? String,
                      let latestMessage = dictionary["latest_message"] as? [String: Any],
                      let date = latestMessage["date"] as? String,
                      let message = latestMessage["message"] as? String,
                      let isRead = latestMessage["is_read"] as? Bool else{
                    return nil
                }
                
                let latestMessageObject = LatestMessage(date: date,
                                                        text: message,
                                                        isRead: isRead)
                
                return Conversation(id: conversationId,
                                    name: name,
                                    otherUserUid: otherUserUid,
                                    latestMessage: latestMessageObject)
            })
            completion(.success(conversations))
        })
    }
    
    ///gets all messages for a given conversation
    public func getAllMessagesForConversation(with id: String, completion: @escaping (Result<[Message], Error>) -> Void){
            database.child("Conversations").child("\(id)/messages").observe(.value, with: { snapshot in
                guard let value = snapshot.value as? [[String: Any]] else{
                    completion(.failure(DatabaseError.failedToFetch))
                    return
                }
                let messages: [Message] = value.compactMap({dictionary in
                    guard let name = dictionary["name"] as? String,
                          let isRead = dictionary["is_read"] as? Bool,
                          let messageID = dictionary["id"] as? String,
                          let content = dictionary["content"] as? String,
                          let senderUid = dictionary["sender_uid"] as? String,
                          let type = dictionary["type"] as? String,
                          let dateString = dictionary["date"] as? String,
                          let date = ChatViewController.dateFormatter.date(from: dateString)
                    else{
                        return nil
                    }
                    let sender = Sender(photoURL: "",
                                        senderId: senderUid,
                                        displayName: name)
                    
                    return Message(sender: sender,
                                   messageId: messageID,
                                   sentDate: date,
                                   kind: .text(content))
                })
                print("messages\(messages)")
                completion(.success(messages))
            })
    }
    
    ///Sends a messsage with target conversation and message
    public func sendMessage(to conversation: String, message: Message, completion: @escaping (Bool) -> Void){
        
    }
}
