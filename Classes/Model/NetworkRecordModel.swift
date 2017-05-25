//
//  NetworkRecordModel.swift
//  Pods
//
//  Created by zixun on 16/12/29.
//
//

import Foundation
import RealmSwift
import Realm

final class NetworkRecordModel: Object {
    
    /// Request
    dynamic open var requestURLString:String?
    dynamic open var requestCachePolicy:String?
    dynamic open var requestTimeoutInterval:String?
    dynamic open var requestHTTPMethod:String?
    dynamic open var requestAllHTTPHeaderFields:String?
    dynamic open var requestHTTPBody: String?
    
    /// Response
    dynamic open var responseMIMEType: String?
    open var responseExpectedContentLength: Int64 = 0
    dynamic open var responseTextEncodingName: String?
    dynamic open var responseSuggestedFilename:String?
    open var responseStatusCode: Int = 200
    dynamic open var responseAllHeaderFields: String?
    dynamic open var receiveJSONData: String?
    
    
    /// init func, use for the data from NetworkEye
    ///
    /// - Parameters:
    ///   - request: instance of NSURLRequest
    ///   - response: intance of HTTPURLResponse
    ///   - data: response data
    init(request:URLRequest?, response: HTTPURLResponse?, data:Data?) {
        super.init()
        
        //request
        self.initialize(request: request)
       
        //response
        self.initialize(response: response, data: data)
    }
    
    init(requestURLString:String?,
         requestCachePolicy:String?,
         requestTimeoutInterval:String?,
         requestHTTPMethod:String?,
         requestAllHTTPHeaderFields:String?,
         requestHTTPBody: String?,
         responseMIMEType: String?,
         responseExpectedContentLength: Int64,
         responseTextEncodingName: String?,
         responseSuggestedFilename:String?,
         responseStatusCode: Int,
         responseAllHeaderFields: String?,
         receiveJSONData: String?) {
        super.init()
        
        self.requestURLString = requestURLString
        self.requestCachePolicy = requestCachePolicy
        self.requestTimeoutInterval = requestTimeoutInterval
        self.requestHTTPMethod = requestHTTPMethod
        self.requestAllHTTPHeaderFields = requestAllHTTPHeaderFields
        self.requestHTTPBody = requestHTTPBody
        self.responseMIMEType = responseMIMEType
        self.responseExpectedContentLength = responseExpectedContentLength
        self.responseTextEncodingName = responseTextEncodingName
        self.responseSuggestedFilename = responseSuggestedFilename
        self.responseStatusCode = responseStatusCode
        self.responseAllHeaderFields = responseAllHeaderFields
        self.receiveJSONData = receiveJSONData
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

extension NetworkRecordModel : RecordORMProtocol {
    static var type: RecordType {
        return RecordType.network
    }
    func attributeString() -> NSAttributedString {
        
        let result = NSMutableAttributedString()
        result.append(self.headerString())
        result.append(self.requestURLStringShow())
        
        if self.showAll {
            result.append(self.requestCachePolicyString())
            result.append(self.requestTimeoutIntervalString())
            result.append(self.requestHTTPMethodString())
            result.append(self.requestAllHTTPHeaderFieldsString())
            result.append(self.requestHTTPBodyString())
            result.append(self.responseMIMETypeString())
            result.append(self.responseExpectedContentLengthString())
            result.append(self.responseTextEncodingNameString())
            result.append(self.responseSuggestedFilenameString())
            result.append(self.responseStatusCodeString())
            result.append(self.responseAllHeaderFieldsString())
            result.append(self.receiveJSONDataString())
        }else {
            result.append(self.contentString(with: "Click cell to show all", content: "...", newline: false, color: UIColor.cyan))
        }
        return result
    }
    
    private func headerString() -> NSAttributedString {
        return self.headerString(with: "NETWORK", color: UIColor(hex: 0xDF1921))
    }
    
    private func requestURLStringShow() -> NSAttributedString {
        return self.contentString(with: "requestURL", content: self.requestURLString)
    }
    
    private func requestCachePolicyString() -> NSAttributedString {
        return self.contentString(with: "requestCachePolicy", content: self.requestCachePolicy)
    }
    
    private func requestTimeoutIntervalString() -> NSAttributedString {
        return self.contentString(with: "requestTimeoutInterval", content: self.requestTimeoutInterval)
    }
    
    private func requestHTTPMethodString() -> NSAttributedString {
        return self.contentString(with: "requestHTTPMethod", content: self.requestHTTPMethod)
    }
    
    private func requestAllHTTPHeaderFieldsString() -> NSAttributedString {
        return self.contentString(with: "requestAllHTTPHeaderFields", content: self.requestAllHTTPHeaderFields)
    }
    
    private func requestHTTPBodyString() -> NSAttributedString {
        return self.contentString(with: "requestHTTPBody", content: self.requestHTTPBody)
    }
    
    private func responseMIMETypeString() -> NSAttributedString {
        return self.contentString(with: "responseMIMEType", content: self.responseMIMEType)
    }
    
    private func responseExpectedContentLengthString() -> NSAttributedString {
        return self.contentString(with: "responseExpectedContentLength", content: "\((self.responseExpectedContentLength ?? 0) / 1024)KB")
    }
    
    private func responseTextEncodingNameString() -> NSAttributedString {
        return self.contentString(with: "responseTextEncodingName", content: self.responseTextEncodingName)
    }
    
    private func responseSuggestedFilenameString() -> NSAttributedString {
        return self.contentString(with: "responseSuggestedFilename", content: self.responseSuggestedFilename)
    }
    
    private func responseStatusCodeString() -> NSAttributedString {
        let status = "\(self.responseStatusCode ?? 200)"
        let str = self.contentString(with: "responseStatusCode", content: status)
        let result = NSMutableAttributedString(attributedString: str)
        let  range = result.string.NS.range(of: status)
        if range.location != NSNotFound {
            let color = status == "200" ? UIColor(hex: 0x1CC221) : UIColor(hex: 0xF5261C)
            result.addAttribute(NSForegroundColorAttributeName, value: color, range: range)
        }
        return result
    }
    
    private func responseAllHeaderFieldsString() -> NSAttributedString {
        let str = self.contentString(with: "responseAllHeaderFields", content: self.responseAllHeaderFields,newline: true)
        let result = NSMutableAttributedString(attributedString: str)
        
        guard let responseAllHeaderFields = self.responseAllHeaderFields else {
            return result
        }
        
        let range = result.string.NS.range(of: responseAllHeaderFields)
        if range.location != NSNotFound {
            result.addAttribute(NSFontAttributeName, value: UIFont.courier(with: 6), range: range)
        }
        return result
    }
    
    private func receiveJSONDataString() -> NSAttributedString {
        guard let transString = self.replaceUnicode(string: self.receiveJSONData) else {
            return NSAttributedString(string: "")
        }
        
        guard let responseMIMEType = self.responseMIMEType else {
            return NSAttributedString(string: "")
        }
        
        var header = "responseJSON"
        if responseMIMEType == "application/xml"
            || responseMIMEType == "text/xml"
            || responseMIMEType == "text/plain"  {
            header = "responseXML"
        }
        
        var result = NSMutableAttributedString(attributedString: self.contentString(with: header, content: transString,newline: true))
        let range = result.string.NS.range(of: transString)
        if range.location != NSNotFound {
            result.addAttribute(NSFontAttributeName, value: UIFont.courier(with: 6), range: range)
        }
        
        return result
    }
    
    private func replaceUnicode(string:String?) -> String? {
        guard let string = string else {
            return nil
        }
        
        var result = string.replacingOccurrences(of: "\\u", with: "\\U").replacingOccurrences(of: "\"", with: "\\\"")
        result = "\"" + result + "\""
        
        
        if let data = result.data(using: String.Encoding.utf8) {
            do {
                result = try PropertyListSerialization.propertyList(from: data, options: PropertyListSerialization.ReadOptions.mutableContainers, format: nil) as! String
                result = result.replacingOccurrences(of: "\\r\\n", with: "\n")
                
                return result
            } catch  {
                return nil
            }
            
            
        }
        
        return nil
    }
}

// MARK: - NetworkRecordModel Private
extension NetworkRecordModel {
    
    /// init the var of request
    ///
    /// - Parameter request: instance of NSURLRequest
    fileprivate func initialize(request:URLRequest?) {
        self.requestURLString = request?.url?.absoluteString
        self.requestCachePolicy = request?.cachePolicy.stringName()
        self.requestTimeoutInterval = request != nil ? String(request!.timeoutInterval) : "nil"
        self.requestHTTPMethod = request?.httpMethod
        
        if let allHTTPHeaderFields = request?.allHTTPHeaderFields {
            allHTTPHeaderFields.forEach({ [unowned self](e:(key: String, value: String)) in
                if self.requestAllHTTPHeaderFields == nil {
                    self.requestAllHTTPHeaderFields = "\(e.key):\(e.value)\n"
                }else {
                    self.requestAllHTTPHeaderFields!.append("\(e.key):\(e.value)\n")
                }
            })
        }
        
        if let bodyData = request?.httpBody {
            self.requestHTTPBody = String(data: bodyData, encoding: String.Encoding.utf8)
        }
    }
    
    /// init the var of response
    ///
    /// - Parameters:
    ///   - response: instance of HTTPURLResponse
    ///   - data: response data
    fileprivate func initialize(response: HTTPURLResponse?, data:Data?) {
        self.responseMIMEType = response?.mimeType
        self.responseExpectedContentLength = response?.expectedContentLength ?? 0
        self.responseTextEncodingName = response?.textEncodingName
        self.responseSuggestedFilename = response?.suggestedFilename
        
        self.responseStatusCode = response?.statusCode ?? 200
        
        response?.allHeaderFields.forEach { [unowned self] (e:(key: AnyHashable, value: Any)) in
            if self.responseAllHeaderFields == nil {
                self.responseAllHeaderFields = "\(e.key) : \(e.value)\n"
            }else {
                self.responseAllHeaderFields!.append("\(e.key) : \(e.value)\n")
            }
        }
        
        guard let data = data else {
            return
        }
        
        if self.responseMIMEType == "application/json" {
            self.receiveJSONData = self.json(from: data)
        }else if self.responseMIMEType == "text/javascript" {
            
            //try to parse json if it is jsonp request
            if var jsonString = String(data: data, encoding: String.Encoding.utf8) {
                //formalize string
                if jsonString.hasSuffix(")") {
                    jsonString = "\(jsonString);"
                }
                
                if jsonString.hasSuffix(");") {
                    var range = jsonString.NS.range(of: "(")
                    if range.location != NSNotFound {
                        range.location += 1
                        range.length = jsonString.NS.length - range.location - 2  // removes parens and trailing semicolon
                        jsonString = jsonString.NS.substring(with: range)
                        let jsondata = jsonString.data(using: String.Encoding.utf8)
                        self.receiveJSONData = self.json(from: jsondata)
                        
                    }
                }
            }
        }else if self.responseMIMEType == "application/xml" ||
            self.responseMIMEType == "text/xml" ||
            self.responseMIMEType == "text/plain" {
            let xmlString = String(data: data, encoding: String.Encoding.utf8)
            self.receiveJSONData = xmlString
        }else {
            self.receiveJSONData = "Untreated MimeType:\(self.responseMIMEType)"
        }
    }
    
    private func json(from data:Data?) -> String? {
        
        guard let data = data else {
            return nil
        }
        
        do {
            var returnValue = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            if ((returnValue as? NSNumber) != nil) {
                return "\(returnValue)"
            }
            let data = try JSONSerialization.data(withJSONObject: returnValue)
            return String(data: data, encoding: .utf8)
        } catch  {
            return nil
        }
    }
}


// MARK: - NSURLRequest.CachePolicy
extension NSURLRequest.CachePolicy {
    
    func stringName() -> String {
        
        switch self {
        case .useProtocolCachePolicy:
            return ".useProtocolCachePolicy"
        case .reloadIgnoringLocalCacheData:
            return ".reloadIgnoringLocalCacheData"
        case .reloadIgnoringLocalAndRemoteCacheData:
            return ".reloadIgnoringLocalAndRemoteCacheData"
        case .returnCacheDataElseLoad:
            return ".returnCacheDataElseLoad"
        case .returnCacheDataDontLoad:
            return ".returnCacheDataDontLoad"
        case .reloadRevalidatingCacheData:
            return ".reloadRevalidatingCacheData"
        }
        
    }
}
