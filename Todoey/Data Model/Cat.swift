//
//  Cat.swift
//  Todoey
//
//  Created by Ryan David Forsyth on 2019-01-13.
//  Copyright © 2019 Ryan F. All rights reserved.
//

import Foundation
import RealmSwift

class Cat: Object {
    
    @objc dynamic var name : String = ""
    
    let tasks = List<Task>()
    
    
}
