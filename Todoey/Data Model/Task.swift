//
//  Task.swift
//  Todoey
//
//  Created by Ryan David Forsyth on 2019-01-13.
//  Copyright © 2019 Ryan F. All rights reserved.
//

import Foundation
import RealmSwift

class Task: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date = Date()
    
    var parentCat = LinkingObjects(fromType: Cat.self, property: "tasks")
}
