//
//  Model.swift
//  PageTableView
//
//  Created by BruceWu on 2021/9/1.
//

import Foundation
import UIKit

struct Model {
    var list: [List]
}

struct List {
    var title: String
    var info: [Info]
    
}

struct Info {
    var title: String
    
}
