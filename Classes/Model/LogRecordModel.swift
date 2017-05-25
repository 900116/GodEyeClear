//
//  LogRecordModel.swift
//  Pods
//
//  Created by zixun on 16/12/28.
//
//

import Foundation
import Log4G
import RealmSwift
import Realm

enum LogRecordModelType:String {
    case asl = "ASL"
    case log = "LOG"
    case warning = "WARNING"
    case error = "ERROR"

    
    func color() -> UIColor {
        switch self {
        case .asl:
            return UIColor(hex: 0x94C76F)
        case .log:
            return UIColor(hex: 0x94C76F)
        case .warning:
            return UIColor(hex: 0xFEC42E)
        case .error:
            return UIColor(hex: 0xDF1921)
        }
    }
}


final class LogRecordModel: Object {
    dynamic open var type: String = "ASL"
    /// date for Time stamp
    dynamic open var date: String?
    
    /// thread which log the message
    dynamic open var thread: String?
    
    /// filename with extension
    dynamic open var file: String?
    
    /// number of line in source code file
    dynamic open var line: String?
    
    /// name of the function which log the message
    dynamic open var function: String?
    
    /// message be logged
    dynamic open var message: String?
    
    init(model:LogModel) {
        super.init()
        self.type = self.type(of: model.type).rawValue
        self.date = model.date.string(with: "yyyy-MM-dd HH:mm:ss")
        self.thread = model.thread.threadName
        self.file = model.file
        self.line = "\(model.line)"
        self.function = model.function
        self.message = model.message
    }
    
    init(type:LogRecordModelType,
         message:String,
         date:String? = nil,
         thread:String? = nil,
         file: String? = nil,
         line: Int? = nil,
         function: String? = nil) {
        super.init()
        self.type = type.rawValue
        self.message = message
        self.date = date
        self.thread = thread
        self.file = file
        self.line = "\(String(describing: line))"
        self.function = function
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
    
    private func type(of log4gType:Log4gType) -> LogRecordModelType {
        switch log4gType {
        case .log:
            return LogRecordModelType.log
        case .warning:
            return LogRecordModelType.warning
        case .error:
            return LogRecordModelType.error
        }
    }
}

extension LogRecordModel: RecordORMProtocol
{
    func attributeString() -> NSAttributedString {
        
        let result = NSMutableAttributedString()
        
        result.append(self.headerString())
        if let additon = self.additionString() {
            result.append(additon)
        }
        return result
    }
    
    private func headerString() -> NSAttributedString {
        let logType = LogRecordModelType(rawValue: self.type)
        return self.headerString(with:self.type, content: self.message, color:logType!.color())
    }
    
    private func additionString() ->NSAttributedString? {
        if self.type == LogRecordModelType.asl.rawValue {
            return nil
        }
        
        let date = self.date ?? ""
        let thread = self.thread ?? ""
        let file = self.file ?? ""
        let line = self.line ?? "-1"
        let function = self.function ?? ""
        
        let content: String = "[\(file): \(line)](\(function)) \(date) -> \(thread)"
        let result = NSMutableAttributedString(attributedString: self.contentString(with: nil, content: content))
        let  range = result.string.NS.range(of: content)
        if range.location != NSNotFound {
            let att = [NSFontAttributeName:UIFont(name: "Courier", size: 10)!,
                       NSForegroundColorAttributeName:UIColor.white] as [String : Any]
            result.setAttributes(att, range: range)
        }
        return result
        
    }


    static var type: RecordType {
        return RecordType.log
    }
}
