//
//  PasswordManage+CoreDataProperties.swift
//  PasswordManager
//
//  Created by Prakash on 21/06/24.
//
//

import Foundation
import CoreData


extension PasswordManage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PasswordManage> {
        return NSFetchRequest<PasswordManage>(entityName: "PasswordManage")
    }
    @NSManaged public var id: String?
    @NSManaged public var accountType: String?
    @NSManaged public var userId: String?
    @NSManaged public var userPsw: String?    
    @NSManaged public var symetricKey: Data?    

}

extension PasswordManage : Identifiable {

}
