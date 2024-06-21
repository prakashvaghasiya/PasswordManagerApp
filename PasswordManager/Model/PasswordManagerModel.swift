//
//  PasswordManagerModel.swift
//  PasswordManager
//
//  Created by Prakash on 21/06/24.
//

import Foundation
import CoreData

class PasswordManagerModel: NSObject, ObservableObject {
    
    @Published var todos: [PasswordManage] = [PasswordManage]()
    
    // Add the Core Data container with the model name
    let container: NSPersistentContainer = NSPersistentContainer(name: "PasswordManage")
    
    // Default init method. Load the Core Data container
    override init() {
        super.init()
        container.loadPersistentStores { _, _ in }
    }
}
