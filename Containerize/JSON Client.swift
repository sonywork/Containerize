//
//  JSON Client.swift
//  Containerize
//
//  Created by Roshan Ravi on 5/25/16.
//  Copyright © 2016 Roshan Ravi. All rights reserved.
//

import Foundation

class JSON_Client {
    func convertDataWithCompletionHandler(data: NSData, completionHandlerForConvertData: (result: AnyObject!, error: NSError?) -> Void) {
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: [])
            completionHandlerForConvertData(result: parsedResult, error: nil)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(result: [:], error: NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
    }
}