//
//  Item.swift
//  DreamLister
//
//  Created by Carlos Uy on 8/10/17.
//  Copyright © 2017 Orangebox Technology LLC. All rights reserved.
//

import Foundation
import CoreData

extension Item {
    public override func awakeFromNib() {
        super.awakeFromInsert()
        
        self.created = NSDate()
    }
}
