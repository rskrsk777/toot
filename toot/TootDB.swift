//
//  toodDB.swift
//  toot

import Realm
import RealmSwift

class TootDB: Object {
    @objc dynamic var toot: String = ""
}
