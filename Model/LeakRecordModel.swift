//
//  LeakRecordModel.swift
//  Pods
//
//  Created by zixun on 17/1/12.
//
//

import Foundation
import Realm
import RealmSwift

final class LeakRecordModel: Object {
    
    dynamic open var clazz: String!
    
    dynamic open var address: String!
    
    init(obj:NSObject) {
        super.init()
        self.clazz = NSStringFromClass(obj.classForCoder)
        self.address = String(format:"%p", obj)
    }
    
    init(clazz:String, address: String) {
        super.init()
        self.clazz = clazz
        self.address = address
    }
    
    
    required init() {
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm:realm,schema:schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value:value,schema:schema)
    }
}

extension LeakRecordModel : RecordORMProtocol {
    static var type: RecordType {
        return RecordType.leak
    }
    func attributeString() -> NSAttributedString {
        
        let result = NSMutableAttributedString()
        
        result.append(self.headerString())
        return result
    }
    
    private func headerString() -> NSAttributedString {
        return self.headerString(with: "Leak", content: "[\(self.clazz): \(self.address)]", color: UIColor(hex: 0xB754C4))
    }
}
