//
//  FirebaseHelper.swift
//  ChatPOC
//
//  Created by CSS on 06/03/18.
//  Copyright © 2018 CSS. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage


typealias UploadTask = StorageUploadTask
typealias SnapShot = DataSnapshot
typealias EventType = DataEventType

class FirebaseHelper{
    
   private var ref: DatabaseReference?
    
    private var storage : Storage?
 
   static var shared = FirebaseHelper()
    
    // Write Text Message
    
    func write(to userId : Int, with text : String, type chatType : ChatType = .single){
        
        self.storeData(to: userId, with: text, mime: .text, type: chatType)
        
    }
    
    
    // Upload from data
    
    func write(to userId : Int, with data : Data, mime type : Mime, type chatType : ChatType = .single, completion : @escaping (Bool)->())->UploadTask{
        
        let metadata = self.initializeStorage(with: type)
        
        return self.upload(data: data,forUser : userId, mime: type, type : chatType, metadata: metadata, completion: { (url) in
            
            completion(url != nil)
            
            guard url != nil else {
                return
            }
            
            self.storeData(to: userId, with: url?.absoluteString, mime: type, type: chatType)
            
        })
        
    }
    
    
    // Upload from Filepath
    
    func write(to userId : Int, file url : URL, mime type : Mime, type chatType : ChatType = .single , completion : @escaping (Bool)->())->UploadTask{
        
        let metadata = self.initializeStorage(with: type)
        
        return self.upload(file: url,forUser : userId, mime: type, type : chatType,metadata: metadata, completion: { (url) in
            
            completion(url != nil)
            
            guard url != nil else {
                return
            }
            
            self.storeData(to: userId, with: url?.absoluteString, mime: type, type: chatType)
            
        })
        
        
    }
    
    // Update Message in Specific Path
    
    func update(chat: ChatEntity, key : String, toUser user : Int, type chatType : ChatType = .single){
       
        let chatPath = chatType == .group ? getGroupChat(with: user) : getRoom(forUser: user)
        
        self.update(chat: chat, key: key, inRoom: chatPath)
        
    }
    
    
}


//MARK:- Helper Functions


extension FirebaseHelper {
    
    // Initializing DB
    
    private func initializeDB(){
        
        if ref == nil {
           let db = Database.database()
           db.isPersistenceEnabled = true
           self.ref = db.reference()
        }
        
    }
    
    // Initializing Storage
    
    private func initializeStorage(with type : Mime)->StorageMetadata{
        
        if self.storage == nil {
            self.storage = Storage.storage()
        }
        
        
        let metadata = StorageMetadata()
        metadata.contentType = type.contentType
        
        return metadata
    }
    

    // Update Values in specific path
    
    private func update(chat : ChatEntity, key : String, inRoom room : String){
       
        self.ref?.child(room).child(key).updateChildValues(chat.JSONRepresentation)
        
    }
    
    
   
    // Common Function to Store Data
    
    private func storeData(to userId : Int, with string : String?, mime type : Mime, type chatType : ChatType){
    
        let chat = ChatEntity()
    
        chat.read = MessageStatus.sent.rawValue
        chat.reciever = userId
        chat.sender = User.main.id
        chat.number = .removeNil(User.main.country_code) +  .removeNil(User.main.mobile)
    
        chat.timeStamp = Formatter.shared.removeDecimal(from: Date().timeIntervalSince1970)
        chat.type = type.rawValue
        
        if type == .text {
            
            chat.text = string
            
        } else {
            
            chat.url = string
            
        }
        
        if chatType == .group {
            chat.groupId = userId
        }
        
        self.initializeDB()
        let chatPath = chatType == .group ? getGroupChat(with: userId) : getRoom(forUser: userId)
        self.ref?.child(chatPath).child(ref!.childByAutoId().key).setValue(chat.JSONRepresentation)
        
    }
    
    
    
    //MARK:- Upload Data to Storage Bucket
    
   private func upload(data : Data,forUser user : Int, mime : Mime, type chatType : ChatType, metadata : StorageMetadata, completion : @escaping (_  downloadUrl : URL?) -> ())->UploadTask{
       
        let chatPath = chatType == .group ? getGroupChat(with: user) : getRoom(forUser: user)
    
        let uploadTask = self.storage?.reference(withPath: chatPath).child(ProcessInfo().globallyUniqueString+mime.ext).putData(data, metadata: metadata, completion: { (metaData, error) in
            
            if error != nil ||  metaData == nil {
                
                print(" Error in uploading  ", error!.localizedDescription)
                
            } else {
                
                if let image = UIImage(data: data), let url = metadata.downloadURL()?.absoluteString {  // Store the uploaded image in Cache  
                    
                    Cache.shared.setObject(image, forKey: url as AnyObject)
                }
                
                completion(metaData?.downloadURL())
                
            }
            
        })
        
        return uploadTask!
        
    }
    
    
    //MARK:- Upload File to Storage Bucket
    
    private func upload(file url : URL,forUser user : Int, mime : Mime, type chatType : ChatType, metadata : StorageMetadata, completion : @escaping (_  downloadUrl : URL?) -> ())->UploadTask{
    
        let chatPath = chatType == .group ? getGroupChat(with: user) : getRoom(forUser: user)
        
        let uploadTask = self.storage?.reference(withPath: chatPath).child(ProcessInfo().globallyUniqueString+mime.ext).putFile(from: url, metadata: metadata, completion: { (metaData, error) in
            
            if error != nil || metaData == nil {
                
                print(" Error in uploading  ", error!.localizedDescription)
                
                
            } else {
                
                completion(metaData?.downloadURL())
                
            }
            
            
        })
        
        return uploadTask!
    }
    
    
    
}


//MARK:- Observers


extension FirebaseHelper {
    
    // Observe if any value changes
    
    func observe(path : String, with : EventType, value : @escaping ([ChatResponse])->())->UInt {
        
        self.initializeDB()
        
       return self.ref!.child(path).queryOrdered(byChild: "timeStamp").observe(with, with: { (snapShot) in
            
            value(self.getModal(from: snapShot))
            
        })
        
        
        
    }
    
    // Remove Firebase Observers
    
    func remove(observers : [UInt]){
        
        self.initializeDB()
        
        for observer in observers {
            
            self.ref?.removeObserver(withHandle: observer)
            
        }
        
    }
    
    
    
    // Observe Last message
    
    func observeLastMessage(path : String, with : EventType, value : @escaping ([ChatResponse])->())->UInt {
        
        self.initializeDB()
        
       return self.ref!.child(path).queryLimited(toLast: 1).observe(with, with: { (snapShot) in
            
            value(self.getModal(from: snapShot))
            
        })
        
    }
    
    
    // Get Values From SnapShot
    
    private func getModal(from snapShot : SnapShot)->[ChatResponse]{
        
        var chatArray = [ChatResponse]()
        var response : ChatResponse?
        var chat : ChatEntity?
        
        if let snaps = snapShot.valueInExportFormat() as? [String : NSDictionary] {
            
           for snap in snaps {
            
                 self.getChatEntity(with: &response, chat: &chat, snap: snap)
                 chatArray.append(response!)
                
            }
            
        } else if let snaps = snapShot.value as? NSDictionary {
            
            self.getChatEntity(with: &response, chat: &chat, snap: (key: snapShot.key , value: snaps))
            chatArray.append(response!)
        }
        
        
        return chatArray.sorted(by: { (obj1, obj2) -> Bool in
            return Int.val(val: obj1.response?.timeStamp)<Int.val(val: obj2.response?.timeStamp)
        })
    }
    
    
    
    private func getChatEntity( with response : inout ChatResponse?, chat : inout ChatEntity?,snap : (key : String, value : NSDictionary)){
        
        response = ChatResponse()
        chat = ChatEntity()
        
        response?.key = snap.key
        
        chat?.read = snap.value.value(forKey: FirebaseConstants.main.read) as? Int
        chat?.reciever = snap.value.value(forKey: FirebaseConstants.main.reciever) as? Int
        chat?.sender = snap.value.value(forKey: FirebaseConstants.main.sender) as? Int
        chat?.text = snap.value.value(forKey: FirebaseConstants.main.text) as? String
        chat?.timeStamp = snap.value.value(forKey: FirebaseConstants.main.timeStamp) as? Int
        chat?.type = snap.value.value(forKey: FirebaseConstants.main.type) as? String
        chat?.url = snap.value.value(forKey: FirebaseConstants.main.url) as? String
        chat?.number = snap.value.value(forKey: FirebaseConstants.main.number) as? String
        chat?.groupId = snap.value.value(forKey: FirebaseConstants.main.groupId) as? Int
        
        response?.response = chat
        
    }
    
    
}


