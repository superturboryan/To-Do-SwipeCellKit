//
//  Task.swift
//  Todoey
//
//  Created by Ryan David Forsyth on 2019-01-08.
//  Copyright © 2019 Ryan F. All rights reserved.
//

import Foundation

class Task : Codable {
    
    var title = ""
    var done = false
    
    init(title : String){
        
        self.title = title
    }
    
}
