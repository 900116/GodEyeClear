//
//  CrashRecordModel.swift
//  Pods
//
//  Created by zixun on 16/12/28.
//
//

import Foundation
import CrashEye
import RealmSwift
import Realm

final class CrashRecordModel: Object {
    
    dynamic open var type: String?
    dynamic open var name: String?
    dynamic open var reason: String?
    dynamic open var appinfo: String?
    dynamic open var callStack: String?
    
    init(model:CrashModel) {
        super.init()
        self.type = "\(model.type)"
        self.name = model.name
        self.reason = model.reason
        self.appinfo = model.appinfo
        self.callStack = model.callStack
    }
    
    init(type:CrashModelType, name:String, reason:String, appinfo:String,callStack:String) {
        super.init()
        self.type = "\(type)"
        self.name = name
        self.reason = reason
        self.appinfo = appinfo
        self.callStack = callStack
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

extension CrashRecordModel: RecordORMProtocol{
    static var type: RecordType {
        return RecordType.crash
    }
    func attributeString() -> NSAttributedString {
        
        let result = NSMutableAttributedString()
        
        result.append(self.headerString())
        result.append(self.nameString())
        result.append(self.reasonString())
        result.append(self.appinfoString())
        result.append(self.callStackString())
        return result
    }
    
    private func headerString() -> NSAttributedString {
        let type = self.type == "\(CrashModelType.exception.rawValue)" ? "Exception" : "SIGNAL"
        return self.headerString(with: "CRASH", content: type, color: UIColor(hex: 0xDF1921))
    }
    
    private func nameString() -> NSAttributedString {
        return self.contentString(with: "NAME", content: self.name)
    }
    
    private func reasonString() -> NSAttributedString {
        return self.contentString(with: "REASON", content: self.reason)
    }
    
    private func appinfoString() -> NSAttributedString {
        return self.contentString(with: "APPINFO", content: self.appinfo)
    }
    
    private func callStackString() -> NSAttributedString {
        let result = NSMutableAttributedString(attributedString: self.contentString(with: "CALL STACK", content: self.callStack))
        let  range = result.string.NS.range(of: self.callStack!)
        if range.location != NSNotFound {
            let att = [NSFontAttributeName:UIFont(name: "Courier", size: 6)!,
                       NSForegroundColorAttributeName:UIColor.white] as [String : Any]
            result.setAttributes(att, range: range)
            
        }
        return result
    }

}
