//
//  ContactItem.swift
//  Message Core
//
//  Created by Haydar Kardeşler on 7.09.2018.
//  Copyright © 2018 Haydar Kardeşler. All rights reserved.
//

import UIKit

class ContactItem: NSObject, NSCoding {
    var id: String
    var firstName: String
    var middleName: String
    var familyName: String
    var phoneNumber: String
    var img: Data?
    var isFavorite: String

    
    init(id: String, firstName: String, middleName: String, familyName: String, phoneNumber: String, isFavorite: String, img: Data?) {
        self.id = id
        self.firstName = firstName
        self.middleName = middleName
        self.familyName = familyName
        self.phoneNumber = phoneNumber
        self.img = img
        self.isFavorite = isFavorite

    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObject(forKey: "id") as! String
        let firstName = aDecoder.decodeObject(forKey: "firstName") as! String
        let middleName = aDecoder.decodeObject(forKey: "middleName") as! String
        let familyName = aDecoder.decodeObject(forKey: "familyName") as! String
        let phoneNumber = aDecoder.decodeObject(forKey: "phoneNumber") as! String
        let isFavorite = aDecoder.decodeObject(forKey: "isFavorite") as! String
        let img = aDecoder.decodeObject(forKey: "img") as! Data?

        self.init(id: id, firstName: firstName, middleName: middleName, familyName: familyName, phoneNumber: phoneNumber, isFavorite: isFavorite, img: img)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(firstName, forKey: "firstName")
        aCoder.encode(middleName, forKey: "middleName")
        aCoder.encode(familyName, forKey: "familyName")
        aCoder.encode(phoneNumber, forKey: "phoneNumber")
        aCoder.encode(img, forKey: "img")
        aCoder.encode(isFavorite, forKey: "isFavorite")

    }
}
