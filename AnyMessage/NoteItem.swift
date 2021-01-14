//
//  NoteItem.swift
//  AnyMessage
//
//  Created by Haydar Kardesler on 13.07.2019.
//  Copyright © 2019 HH&HS Apps. All rights reserved.
//

import UIKit

class NoteItem {
    var noteID: Int
    var contactID: String
    var noteContent: String
    var noteDate: Date
    
    init(noteID: Int, contactID: String, noteContent: String, noteDate: Date) {
        self.noteID = noteID
        self.contactID = contactID
        self.noteContent = noteContent
        self.noteDate = noteDate
 
    }

}
