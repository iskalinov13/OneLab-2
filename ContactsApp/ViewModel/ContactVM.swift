//
//  ContactVM.swift
//  ContactsApp
//
//  Created by Farukh Iskalinov on 7.07.20.
//  Copyright © 2020 Farukh Iskalinov. All rights reserved.
//

import Foundation
class ContactVM {
    var selectedIndex: Int?
    var sectionKeys: [String] = []
    var contacts: [[Contact]] = []
    var filteredContacts: [Contact] = []
    var updateTableContent: (() -> Void)?
    
    func getContactAt(section: Int, row: Int) -> Contact {
        return contacts[section][row]
    }
    
    func addContact(_ contactObject: Contact) {
        //получить первую букву казалось сложным не знаю есть ли легкий способ типо string.uppercased().charAt(0)
        let key = "\(contactObject.name.uppercased()[contactObject.name.uppercased().startIndex])" // first char of the name
        if sectionKeys.contains(key) {
            let index = sectionKeys.firstIndex(of: key)!
            contacts[index].append(contactObject)
            
        } else {
            sectionKeys.append(key)
            contacts.append([contactObject])
        }
        updateTableContent?()
    }
    func showSortedContacts(){
        if contacts.count > 1 {
            sectionKeys = sectionKeys.sorted()
            contacts = contacts.sorted(by: { $0[0] < $1[0]})
            for i in 0..<contacts.count {
                contacts[i] = contacts[i].sorted(by: {$0 < $1})
            }
        }
        updateTableContent?()
    }
    
    func searchContact(name: String) {
        guard name != "" else {
            return
        }
        let key = "\(name[name.startIndex])".uppercased()
        if let index = sectionKeys.firstIndex(of: key) {
            selectedIndex = index
            filteredContacts = contacts[index]
            filteredContacts = filteredContacts.filter { $0.name.uppercased().contains(name.uppercased()) }
        } else {
            selectedIndex = nil
            filteredContacts.removeAll()
        }
        updateTableContent?()
    }
    
    func getSectionTitle() -> String {
        if let index = selectedIndex {
            return sectionKeys[index]
        }
        return "Not found"
    }
    
    func removeContactAt(section: Int, row: Int) {
        contacts[section].remove(at: row)
        if contacts[section].count == 0 {
            contacts.remove(at: section)
            sectionKeys.remove(at: section)
        }
        updateTableContent?()
    }
    
    func contains(_ contact: Contact) -> Bool {
        var flag = false
        contacts.forEach { arr in
            if arr.contains(contact) {
                flag = true
            }
        }
        return flag
    }
    private func indexOf(_ contact: Contact) -> (Int, Int)? {
        for i in 0..<contacts.count {
            for j in 0..<contacts[i].count {
                if contacts[i][j].id == contact.id {
                    return (i,j)
                }
            }
        }
        return nil
    }
    func updateContact(_ contactObject: Contact) {
        if let index = indexOf(contactObject) {
            let oldKey = sectionKeys[index.0]
            let key = "\(contactObject.name.uppercased()[contactObject.name.uppercased().startIndex])"
            if oldKey == key {
                contacts[index.0][index.1] = contactObject
            } else {
                if contacts[index.0].count == 1 {
                    contacts.remove(at: index.0)
                    sectionKeys.remove(at: index.0)
                    addContact(contactObject)
                } else {
                    contacts[index.0].remove(at: index.1)
                    addContact(contactObject)
                }
            }
        }
        updateTableContent?()
        
    }
}
