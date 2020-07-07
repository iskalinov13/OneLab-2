//
//  PersonInfo.swift
//  ContactsApp
//
//  Created by Farukh Iskalinov on 3.07.20.
//  Copyright © 2020 Farukh Iskalinov. All rights reserved.
//

import Foundation
struct Contact: Comparable, Equatable {
    let id: String
    let name: String
    let surname: String
    let phone: String
     
    static func ==(lhs: Contact, rhs: Contact) -> Bool {
        print("i am contains")
        return lhs.phone.lowercased() == rhs.phone.lowercased()
    }
    
    static func <(lhs: Contact, rhs: Contact) -> Bool {
        return lhs.name.lowercased() < rhs.name.lowercased()
    }
}


