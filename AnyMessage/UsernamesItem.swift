//
//  UsernamesItem.swift
//
//  Created by Haydar Kardeşler on 19/12/2018.
//  Copyright © 2018 Nuri Yigit. All rights reserved.
//


import UIKit


class UsernamesItem {
    let id: String
    var fbUsername: String?
    var twitterUsername: String?
    var instagramUsername: String?
    var gmailUsername: String?
    var visibilityFbUsername: String
    var visibilityTwitterUsername: String
    var visibilityInstagramUsername: String
    var visibilityGmailUsername: String
    var visibilityNotes: String
    var customTab1Name: String?
    var customTab2Name: String?
    var customTab3Name: String?
    var customTab1Url: String?
    var customTab2Url: String?
    var customTab3Url: String?


    init(id: String) {
        self.id = id
        self.fbUsername = ""
        self.twitterUsername = "twitterUsername"
        self.instagramUsername = "instagramUsername"
        self.gmailUsername = "gmailUsername"
        self.visibilityFbUsername = "1"
        self.visibilityTwitterUsername = "1"
        self.visibilityInstagramUsername = "1"
        self.visibilityGmailUsername = "1"
        self.visibilityNotes = "1"
        self.customTab1Name = ""
        self.customTab2Name = ""
        self.customTab3Name = ""
        self.customTab1Url = ""
        self.customTab2Url = ""
        self.customTab3Url = ""

    }
    
  
    init(id: String, fbUsername: String?, twitterUsername: String?, instagramUsername: String?, gmailUsername: String?, visibilityFbUsername: String, visibilityTwitterUsername: String, visibilityInstagramUsername: String,visibilityGmailUsername: String, visibilityNotes: String, customTab1Name: String?, customTab2Name: String?, customTab3Name: String?, customTab1Url: String?, customTab2Url: String?, customTab3Url: String?) {
        self.id = id
        self.fbUsername = fbUsername
        self.twitterUsername = twitterUsername
        self.instagramUsername = instagramUsername
        self.gmailUsername = gmailUsername
        self.visibilityFbUsername = visibilityFbUsername
        self.visibilityTwitterUsername = visibilityTwitterUsername
        self.visibilityInstagramUsername = visibilityInstagramUsername
        self.visibilityGmailUsername = visibilityGmailUsername
        self.visibilityNotes = visibilityNotes
        self.customTab1Name = customTab1Name
        self.customTab2Name = customTab2Name
        self.customTab3Name = customTab3Name
        self.customTab1Url = customTab1Url
        self.customTab2Url = customTab2Url
        self.customTab3Url = customTab3Url

    }
    
}

