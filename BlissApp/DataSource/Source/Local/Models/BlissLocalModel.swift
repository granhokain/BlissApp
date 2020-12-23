//
//  BlissLocalModel.swift
//  BlissApp
//
//  Created by Rafael Martins on 22/12/20.
//

import Foundation
import RealmSwift

class BlissLocalModel: Object  {
    @objc dynamic var name = String()
    @objc dynamic var link = String()
}
