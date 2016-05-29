//
//  Docker API Client.swift
//  Containerize
//
//  Created by Roshan Ravi on 5/25/16.
//  Copyright © 2016 Roshan Ravi. All rights reserved.
//

import Foundation

class DockerAPIClient: JSON_Client {
    var session = NSURLSession.sharedSession()
    
    static func sharedInstance() -> DockerAPIClient {
        struct Singleton {
            static var sharedInstance = DockerAPIClient()
        }
        return Singleton.sharedInstance
    }
}

extension DockerAPIClient {
    func getContainers(addr: String, completionHandler: (result: AnyObject?, error: NSError?) -> Void){
        let URL = "\(DockerAPIClient.Constants.Protocol)://\(addr)/\(DockerAPIClient.ServerPaths.Containers)"
        
        let request = NSMutableURLRequest(URL: NSURL(string: URL)!)
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                completionHandler(result: [[:]], error: error)
            } else {
                self.convertDataWithCompletionHandler(data!, completionHandlerForConvertData: { (result, error) in
                    completionHandler(result: result, error: error)
                })
            }
        }
        
        task.resume()
    }

    func getImages(addr: String, completionHandler: (result: AnyObject?, error: NSError?) -> Void){
        let URL = "\(DockerAPIClient.Constants.Protocol)://\(addr)/\(DockerAPIClient.ServerPaths.Images)"
        
        let request = NSMutableURLRequest(URL: NSURL(string: URL)!)
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                completionHandler(result: [[:]], error: error)
            } else {
                self.convertDataWithCompletionHandler(data!, completionHandlerForConvertData: { (result, error) in
                    completionHandler(result: result, error: error)
                })
            }
        }
        
        task.resume()
    }

    func getVolumes(addr: String, completionHandler: (result: AnyObject?, error: NSError?) -> Void){
        let URL = "\(DockerAPIClient.Constants.Protocol)://\(addr)/\(DockerAPIClient.ServerPaths.Volumes)"
        
        let request = NSMutableURLRequest(URL: NSURL(string: URL)!)
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                completionHandler(result: [[:]], error: error)
            } else {
                self.convertDataWithCompletionHandler(data!, completionHandlerForConvertData: { (result, error) in
                    completionHandler(result: result[DockerAPIClient.JSONKeys.Volumes], error: error)
                })
            }
        }
        
        task.resume()
    }
    
    func getInfo(addr: String, completionHandler: (result: AnyObject?, error: NSError?) -> Void){
        let URL = "\(DockerAPIClient.Constants.Protocol)://\(addr)/\(DockerAPIClient.ServerPaths.Info)"
        
        let request = NSMutableURLRequest(URL: NSURL(string: URL)!)
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                completionHandler(result: [:], error: error)
            } else {
                self.convertDataWithCompletionHandler(data!, completionHandlerForConvertData: { (result, error) in
                    completionHandler(result: result, error: error)
                })
            }
        }
        
        task.resume()
    }
}