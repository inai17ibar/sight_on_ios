//
//  User.swift
//  SightOnMock
//
//  Created by inatani soichiro on 2017/08/12.
//  Copyright © 2017年 inai17ibar. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
    dynamic var id: Int = 0
    dynamic var user_name: String = ""
    dynamic var email: String = ""
    dynamic var password: String = ""
    dynamic var status: String = ""
    
    // プライマリーキーの設定
    override static func primaryKey() -> String? {
        return "id"
    }
}
