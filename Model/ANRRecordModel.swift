//
//  ANRModel.swift
//  Pods
//
//  Created by zixun on 16/12/30.
//
//

import Foundation
import RealmSwift
import Realm

final class ANRRecordModel: Object {
    
    open var threshold: Double!
    dynamic open var mainThreadBacktrace:String?
    dynamic open var allThreadBacktrace:String?
    
    init(threshold:Double,mainThreadBacktrace:String?,allThreadBacktrace:String?) {
        super.init()
        self.threshold = threshold
        self.mainThreadBacktrace = mainThreadBacktrace
        self.allThreadBacktrace = allThreadBacktrace
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

extension ANRRecordModel : RecordORMProtocol{
    static var type: RecordType {
        return RecordType.anr
    }
    private func mainThreadBacktraceString() -> NSAttributedString {
        let result = NSMutableAttributedString(attributedString: self.contentString(with: "MainThread Backtrace", content: self.mainThreadBacktrace, newline: true))
        let  range = result.string.NS.range(of: self.mainThreadBacktrace!)
        if range.location != NSNotFound {
            let att = [NSFontAttributeName:UIFont(name: "Courier", size: 6)!,
                       NSForegroundColorAttributeName:UIColor.white] as [String : Any]
            result.setAttributes(att, range: range)
            
        }
        return result
        
    }
    
    private func allThreadBacktraceString() -> NSAttributedString {
        let result = NSMutableAttributedString(attributedString: self.contentString(with: "AllThread Backtrace", content: self.allThreadBacktrace, newline: true))
        let  range = result.string.NS.range(of: self.allThreadBacktrace!)
        if range.location != NSNotFound {
            let att = [NSFontAttributeName:UIFont(name: "Courier", size: 6)!,
                       NSForegroundColorAttributeName:UIColor.white] as [String : Any]
            result.setAttributes(att, range: range)
            
        }
        return result
        
    }

    
    func attributeString() -> NSAttributedString {
        
        let result = NSMutableAttributedString()
        result.append(self.headerString())
        result.append(self.mainThreadBacktraceString())
        
        if self.showAll {
            result.append(self.allThreadBacktraceString())
        }else {
            result.append(self.contentString(with: "Click cell to show all", content: "...", newline: false, color: UIColor.cyan))
        }
        
        
        return result
    }
    
    private func headerString() -> NSAttributedString {
        let content = "main thread not response with threshold:\(self.threshold!)"
        return self.headerString(with: "ANR", content: content, color: UIColor(hex: 0xFF0000))
    }
}
