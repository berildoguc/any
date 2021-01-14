//
//  DbUtil.swift
//  AnyMessage
//  Created by Haydar Kardeşler on 19/12/2018.
//  Copyright © 2018 Nuri Yigit. All rights reserved.
//

import Foundation
import SQLite
class DbUtil {
    static var sharedInstance = DbUtil()
    var db: Connection?
    var db2: OpaquePointer?

    let ContactInfo = Table("ContactInfo")
    let tblNotes = Table("Notes")
    let id = Expression<String>("id")
    let fbUserName = Expression<String?>("fbUserName")
    let twitterUserName = Expression<String?>("twitterUserName")
    let instagramUserName = Expression<String?>("instagramUserName")
    let gmailAddress = Expression<String?>("gmailAddress")
    let yahooAddress = Expression<String?>("yahooAddress")
    let outlookAddress = Expression<String?>("outlookAddress")
    let visibilityFbUsername = Expression<String>("visibilityFbUsername")
    let visibilityTwitterUsername = Expression<String>("visibilityTwitterUsername")
    let visibilityInstagramUsername = Expression<String>("visibilityInstagramUsername")
    let visibilityGmail = Expression<String>("visibilityGmail")
    let visibilityYahoo = Expression<String>("visibilityYahoo")
    let visibilityOutlook = Expression<String>("visibilityOutlook")
    let visibilityNotes = Expression<String>("visibilityNotes")
    let visibilityGallery = Expression<String>("visibilityGallery")
    let customTab1Name = Expression<String?>("customTab1Name")
    let customTab2Name = Expression<String?>("customTab2Name")
    let customTab3Name = Expression<String?>("customTab3Name")
    let customTab1Url = Expression<String?>("customTab1Url")
    let customTab2Url = Expression<String>("customTab2Url")
    let customTab3Url = Expression<String>("customTab3Url")

    let noteID = Expression<Int>("noteID")
    let contactID = Expression<String>("contactID")
    let noteContent = Expression<String>("noteContent")
    let noteDate = Expression<String>("noteDate")

    init(){
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        print("path1: " + path)
        
        do{
            db = try Connection("\(path)/anymessage.sqlite3")
            
            try db!.run(ContactInfo.create(temporary: false, ifNotExists: true, withoutRowid: false, block: {
                t in
           
                t.column(id)
                t.column(fbUserName)
                t.column(twitterUserName)
                t.column(instagramUserName)
                t.column(gmailAddress)
                t.column(yahooAddress)
                t.column(outlookAddress)
                t.column(visibilityFbUsername)
                t.column(visibilityTwitterUsername)
                t.column(visibilityInstagramUsername)
                t.column(visibilityGmail)
                t.column(visibilityYahoo)
                t.column(visibilityOutlook)
                t.column(visibilityNotes)
                t.column(visibilityGallery)
                t.column(customTab1Name)
                t.column(customTab2Name)
                t.column(customTab3Name)
                t.column(customTab1Url)
                t.column(customTab2Url)
                t.column(customTab3Url)

            }))
            
            try db!.run(tblNotes.create(temporary: false, ifNotExists: true, withoutRowid: false, block: {
                t in

                t.column(noteID, primaryKey: .autoincrement)
                t.column(contactID)
                t.column(noteContent)
                t.column(noteDate)
                
            }))
        }catch{
            print("Error \(error)")
        }
        
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("anymessage.sqlite3")
        
        //opening the database
        if sqlite3_open(fileURL.path, &db2) != SQLITE_OK {
            print("error opening database")
        }
    }

    func getUserNames(contactId:String) -> UsernamesItem? {
      

        do {
            
            for contact in try db!.prepare("SELECT * FROM ContactInfo WHERE id LIKE '"+contactId+"'") {

                let username: UsernamesItem = UsernamesItem(id: contact[0] as! String, fbUsername: contact[1] as? String, twitterUsername: contact[2] as? String, instagramUsername: contact[3] as? String, gmailUsername: contact[4] as? String, visibilityFbUsername: contact[7] as! String, visibilityTwitterUsername:contact[8] as! String, visibilityInstagramUsername: contact[9] as! String, visibilityGmailUsername: contact[10] as! String, visibilityNotes: contact[13] as! String, customTab1Name: contact[15] as? String, customTab2Name: contact[16] as? String, customTab3Name: contact[17] as? String, customTab1Url: contact[18] as? String, customTab2Url: contact[19] as? String, customTab3Url: contact[20] as? String)
                return username
            }
        } catch {
            print("Select failed database")
            return nil

        }
        
        return nil
    }
    
    
    

    func addUserNames(contactId:String, fbUsername:String?, twitterUserName:String?, instagramUserName:String?, gmailUserName:String?, visibilityFbUsername:String, visibilityTwitterUsername:String, visibilityInstagramUsername:String, visibilityGmailUsername:String, visibilityNotes:String, customTab1Name:String?, customTab2Name:String?, customTab3Name:String?,  customTab1Url:String?, customTab2Url:String?, customTab3Url:String?) {
        do{
            try db?.run(ContactInfo.insert(self.id <- contactId, self.fbUserName <- fbUsername, self.twitterUserName <- twitterUserName, self.instagramUserName <- instagramUserName, self.gmailAddress <- gmailUserName, self.yahooAddress <- "", self.outlookAddress <- "", self.visibilityFbUsername <- visibilityFbUsername, self.visibilityTwitterUsername <- visibilityTwitterUsername, self.visibilityInstagramUsername <- visibilityInstagramUsername, self.visibilityGmail <- visibilityGmailUsername, self.visibilityYahoo <- "1", self.visibilityOutlook <- "1", self.visibilityNotes <- visibilityNotes,self.visibilityGallery <- "1", self.customTab1Name <- customTab1Name ?? "", self.customTab2Name <- customTab2Name ?? "", self.customTab3Name <- customTab3Name ?? "", self.customTab1Url <- customTab1Url ?? "", self.customTab2Url <- customTab2Url ?? "", self.customTab3Url <- customTab3Url ?? ""))
    }catch{
    print("Error \(error)")
    }
}
    
    func updateUserNames(contactId:String, fbUsername:String?, twitterUserName:String?, instagramUserName:String?, gmailUserName:String?, visibilityFbUsername:String, visibilityTwitterUsername:String, visibilityInstagramUsername:String, visibilityGmailUsername:String, visibilityNotes:String, customTab1Name:String?, customTab2Name:String?, customTab3Name:String?,  customTab1Url:String?, customTab2Url:String?, customTab3Url:String?) {
        do{
            
            let usrUpt = ContactInfo.filter(id == contactId)
            try db?.run(usrUpt.update(self.fbUserName <- fbUsername, self.twitterUserName <- twitterUserName, self.instagramUserName <- instagramUserName, self.gmailAddress <- gmailUserName, self.yahooAddress <- "", self.outlookAddress <- "", self.visibilityFbUsername <- visibilityFbUsername, self.visibilityTwitterUsername <- visibilityTwitterUsername, self.visibilityInstagramUsername <- visibilityInstagramUsername, self.visibilityGmail <- visibilityGmailUsername, self.visibilityYahoo <- "1", self.visibilityOutlook <- "1", self.visibilityNotes <- visibilityNotes,self.visibilityGallery <- "1", self.customTab1Name <- customTab1Name ?? "", self.customTab2Name <- customTab2Name ?? "", self.customTab3Name <- customTab3Name ?? "", self.customTab1Url <- customTab1Url ?? "", self.customTab2Url <- customTab2Url ?? "", self.customTab3Url <- customTab3Url ?? ""))

            
        }catch{
            print("Error \(error)")
        }
    }
    
    func deleteUserNames(contactId:String) {
        
        do{
            let usrDel = ContactInfo.filter(id == contactId)
            try db?.run(usrDel.delete())

        }catch{
            print("Error \(error)")
        }
    }
    
    func getNotes(contactId:String) -> [NoteItem]? {
        
        var notesArray = [NoteItem]()

        let queryString = "SELECT * FROM Notes WHERE contactID = '"+contactId+"'"
        
        //statement pointer
        var stmt:OpaquePointer?
        
        //preparing the query
        if sqlite3_prepare(db2, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db2)!)
            print("error preparing insert: \(errmsg)")
            return nil
        }
        
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let id = sqlite3_column_int(stmt, 0)
            let contactID = String(cString: sqlite3_column_text(stmt, 1))
            let content = String(cString: sqlite3_column_text(stmt, 2))
            let date = String(cString: sqlite3_column_text(stmt, 3))

            
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date2 = df.date(from: date)
            
            
            let note: NoteItem = NoteItem(noteID:  Int(id), contactID: String(describing: contactID), noteContent: String(describing: content), noteDate: date2!)
            
            notesArray.append(note)
        }
        
      
        return notesArray
    }
    
    func getAllNotes() -> [NoteItem]? {
        
        var notesArray = [NoteItem]()
        
        let queryString = "SELECT * FROM Notes"
        
        //statement pointer
        var stmt:OpaquePointer?
        
        //preparing the query
        if sqlite3_prepare(db2, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db2)!)
            print("error preparing insert: \(errmsg)")
            return nil
        }
        
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let id = sqlite3_column_int(stmt, 0)
            let contactID = String(cString: sqlite3_column_text(stmt, 1))
            let content = String(cString: sqlite3_column_text(stmt, 2))
            let date = String(cString: sqlite3_column_text(stmt, 3))
            
            
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date2 = df.date(from: date)
            
            
            let note: NoteItem = NoteItem(noteID:  Int(id), contactID: String(describing: contactID), noteContent: String(describing: content), noteDate: date2!)
            
            notesArray.append(note)
        }
        
        
        return notesArray
    }
    
    func addNote(contactID:String, noteContent:String?, noteDate:String) {
        do{
            try db?.run(tblNotes.insert(self.contactID <- contactID, self.noteContent <- noteContent ?? "", self.noteDate <- noteDate))
        }catch{
            print("Error \(error)")
        }
    }
    
    func updateNote(ID: Int, noteContent:String?, noteDate:String) {
        do{
            
            let noteUpt = tblNotes.filter(ID == noteID)
            try db?.run(noteUpt.update(self.noteContent <- noteContent ?? "", self.noteDate <- noteDate))
            
            
        }catch{
            print("Error \(error)")
        }
    }
    
    func deleteNote(ID:Int) {
        
        do{
            let noteUpt = tblNotes.filter(ID == noteID)
            try db?.run(noteUpt.delete())
            
        }catch{
            print("Error \(error)")
        }
    }
}
