//
//  CommandModel.swift
//  Pods
//
//  Created by zixun on 17/1/7.
//
//

import Foundation
import RealmSwift
import Realm

final class CommandRecordModel: Object {
    dynamic open var command: String!
    dynamic open var actionResult: String!
    
    init(command:String,actionResult:String) {
        super.init()
        self.command = command
        self.actionResult = actionResult
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

extension CommandRecordModel : RecordORMProtocol {
    static var type: RecordType {
        return RecordType.command
    }
    
    
    private func headerString() -> NSAttributedString {
        return self.headerString(with: "Command", content: self.command, color: UIColor(hex: 0xB754C4))
    }
    
    private func actionString() -> NSAttributedString {
        return NSAttributedString(string: self.actionResult, attributes: self.attributes())
    }
    
    func attributeString() -> NSAttributedString {
        
        let result = NSMutableAttributedString()
        
        result.append(self.headerString())
        result.append(self.actionString())
        return result
    }
}
