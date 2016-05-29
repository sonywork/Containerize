//
//  Docker Client.swift
//  Containerize
//
//  Created by Roshan Ravi on 5/25/16.
//  Copyright © 2016 Roshan Ravi. All rights reserved.
//

import Foundation
import CoreData

class DockerClient: NSObject {
    private let client = DockerAPIClient()
    private var addr: String = ""
    
    internal var info: Info? = nil
    internal var containers: [Container]? = []
    internal var images: [Image]? = []
    internal var volumes: [Volume]? = []
}

extension DockerClient {
    static func sharedInstance() -> DockerClient {
        struct Singleton {
            static var sharedInstance = DockerClient()
        }
        return Singleton.sharedInstance
    }
}

extension DockerClient {
    func config(address: String, handler: (conf: NSNumber?, error: NSError?) -> Void){
        self.addr = address
        
        self.reloadData({ (conf, error) in
            handler(conf: conf, error: error)
        })
    }
    // Return all data and call handler on every response.
    func reloadData(handler: (conf: NSNumber?, error: NSError?) -> Void){
        DockerAPIClient.sharedInstance().getInfo(self.addr) { (result, error) in
            if(error == nil){
                CoreDataStack.sharedInstance().managedObjectContext.performBlock {
                    self.clearEntities("Info")
                    self.info = nil
                    
                    let entityDescription = NSEntityDescription.entityForName("Info", inManagedObjectContext: CoreDataStack.sharedInstance().managedObjectContext)
                    self.info = NSManagedObject(entity: entityDescription!, insertIntoManagedObjectContext: CoreDataStack.sharedInstance().managedObjectContext) as? Info
                    
                    self.info!.setValue(result?[DockerAPIClient.ServerInfo.Name] as? String, forKey: "name")
                    self.info!.setValue(result?[DockerAPIClient.ServerInfo.OperatingSystem] as? String, forKey: "os")
                    self.info!.setValue(result?[DockerAPIClient.ServerInfo.MemTotal] as? NSNumber, forKey: "memTotal")
                    self.info!.setValue(result?[DockerAPIClient.ServerInfo.NCPU] as? NSNumber, forKey: "nCPU")
                    self.info!.setValue(result?[DockerAPIClient.ServerInfo.DockerRootDir] as? String, forKey: "root")
                    self.info!.setValue(result?[DockerAPIClient.ServerInfo.ServerVersion] as? String, forKey: "version")
                    
                    CoreDataStack.sharedInstance().saveContext()
                    
                    handler(conf: 1, error: nil)
                }
            } else {
                handler(conf: nil, error: error)
            }
        }
        DockerAPIClient.sharedInstance().getContainers(self.addr) { (result, error) in
            if(error == nil){
                CoreDataStack.sharedInstance().managedObjectContext.performBlock {
                    self.clearEntities("Container")
                    self.containers = []
                    
                    let entityDescription = NSEntityDescription.entityForName("Container", inManagedObjectContext: CoreDataStack.sharedInstance().managedObjectContext)
                    if(result != nil && !(result is NSNull)){
                        for container in result as! NSArray{
                            let cont = NSManagedObject(entity: entityDescription!, insertIntoManagedObjectContext: CoreDataStack.sharedInstance().managedObjectContext) as? Container
                            
                            cont?.setValue(container[DockerAPIClient.ContainerInfo.Names]??[0], forKey: "name")
                            cont?.setValue(container[DockerAPIClient.ContainerInfo.Id]!, forKey: "id")
                            cont?.setValue(container[DockerAPIClient.ContainerInfo.Image]!, forKey: "image")
                            cont?.setValue(container[DockerAPIClient.ContainerInfo.State]!, forKey: "state")
                            
                            CoreDataStack.sharedInstance().saveContext()
                            
                            self.containers?.append(cont!)
                        }
                        handler(conf: nil, error: nil)
                    }
                }
            } else {
                handler(conf: nil, error: error)
            }
        }
        DockerAPIClient.sharedInstance().getImages(self.addr) { (result, error) in
            if(error == nil){
                CoreDataStack.sharedInstance().managedObjectContext.performBlock {
                    self.clearEntities("Image")
                    self.images = []
                    
                    let entityDescription = NSEntityDescription.entityForName("Image", inManagedObjectContext: CoreDataStack.sharedInstance().managedObjectContext)
                    if(result != nil && !(result is NSNull)){
                        for image in result as! NSArray{
                            let img = NSManagedObject(entity: entityDescription!, insertIntoManagedObjectContext: CoreDataStack.sharedInstance().managedObjectContext) as? Image
                            
                            img?.setValue(image[DockerAPIClient.ImageInfo.Name]!![0], forKey: "name")
                            
                            CoreDataStack.sharedInstance().saveContext()
                            
                            self.images?.append(img!)
                        }
                        handler(conf: nil, error: nil)
                    }
                }
            } else {
                handler(conf: nil, error: error)
            }
        }
        DockerAPIClient.sharedInstance().getVolumes(self.addr) { (result, error) in
            if(error == nil){
                CoreDataStack.sharedInstance().managedObjectContext.performBlock {
                    self.clearEntities("Volume")
                    self.volumes = []
                    
                    let entityDescription = NSEntityDescription.entityForName("Volume", inManagedObjectContext: CoreDataStack.sharedInstance().managedObjectContext)
                    if(result != nil && !(result is NSNull)){
                        for volume in result as! NSArray{
                            let vol = NSManagedObject(entity: entityDescription!, insertIntoManagedObjectContext: CoreDataStack.sharedInstance().managedObjectContext) as? Volume
                            
                            vol?.setValue(volume[DockerAPIClient.VolumeInfo.Name]!, forKey: "name")
                            
                            CoreDataStack.sharedInstance().saveContext()
                            
                            self.volumes?.append(vol!)
                        }
                        handler(conf: nil, error: nil)
                    }
                }
            } else {
                handler(conf: nil, error: error)
            }
        }
    }
    
    func fetchData(handler: (error: NSError?) -> Void){
        CoreDataStack.sharedInstance().managedObjectContext.performBlock {
            do {
                var fetchRequest = NSFetchRequest()
                fetchRequest.entity = NSEntityDescription.entityForName("Info", inManagedObjectContext: CoreDataStack.sharedInstance().managedObjectContext)
               // self.info = try (CoreDataStack.sharedInstance().managedObjectContext.executeFetchRequest(fetchRequest) as NSArray)[0] as? Info
                
                fetchRequest = NSFetchRequest()
                fetchRequest.entity = NSEntityDescription.entityForName("Container", inManagedObjectContext: CoreDataStack.sharedInstance().managedObjectContext)
                self.containers = try CoreDataStack.sharedInstance().managedObjectContext.executeFetchRequest(fetchRequest) as? [Container]
                
                fetchRequest = NSFetchRequest()
                fetchRequest.entity = NSEntityDescription.entityForName("Image", inManagedObjectContext: CoreDataStack.sharedInstance().managedObjectContext)
                self.images = try CoreDataStack.sharedInstance().managedObjectContext.executeFetchRequest(fetchRequest) as? [Image]
                
                fetchRequest = NSFetchRequest()
                fetchRequest.entity = NSEntityDescription.entityForName("Volume", inManagedObjectContext: CoreDataStack.sharedInstance().managedObjectContext)
                self.volumes = try CoreDataStack.sharedInstance().managedObjectContext.executeFetchRequest(fetchRequest) as? [Volume]
                
                handler(error: nil)
            } catch {
                handler(error: error as NSError)
            }
        }
    }
    
    func clearEntities(entity: String){
        CoreDataStack.sharedInstance().managedObjectContext.performBlock {
            let fetchRequest = NSFetchRequest(entityName: entity)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try CoreDataStack.sharedInstance().managedObjectContext.executeRequest(deleteRequest)
            } catch let error as NSError {
                print(error)
            }
        }
    }
}