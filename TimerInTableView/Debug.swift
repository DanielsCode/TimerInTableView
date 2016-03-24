//
//  Debug.swift
//  TimerInTableView
//
//  Created by Daniel on 24.03.16.
//  Copyright © 2016 myknack. All rights reserved.
//

import Foundation

class Debug {
    
    class func logFunction(file:String = __FILE__, function:String = __FUNCTION__, line:Int = __LINE__){
        print("")
        print(" ▶ Running: \(((file as NSString).lastPathComponent as NSString)):\(function) (line:\(line))")
    }
    
}