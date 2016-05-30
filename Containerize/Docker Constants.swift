//
//  Docker Constants.swift
//  Containerize
//
//  Created by Roshan Ravi on 5/25/16.
//  Copyright © 2016 Roshan Ravi. All rights reserved.
//

import Foundation

extension DockerAPIClient {
    struct Constants {
        static let Protocol = "http"
    }
    
    struct ServerPaths {
        static let Containers = "containers/json?all=1&size=1"
        static let Volumes = "volumes"
        static let Images = "images/json?all=0"
        static let Info = "info"
    }
    
    struct ContainerInfo {
        static let Names = "Names"
        static let Id = "Id"
        static let Image = "Image"
        static let State = "State"
    }
    
    struct ImageInfo {
        static let Name = "RepoTags"
    }
    
    struct VolumeInfo {
        static let Name = "Name"
        static let Mountpoint = "Mountpoint"
    }
    
    struct ServerInfo {
        static let Name = "Name"
        static let ServerVersion = "ServerVersion"
        static let NCPU = "NCPU"
        static let MemTotal = "MemTotal"
        static let OperatingSystem = "OperatingSystem"
        static let DockerRootDir = "DockerRootDir"
    }
    
    struct JSONKeys {
        static let Volumes = "Volumes"
    }
}