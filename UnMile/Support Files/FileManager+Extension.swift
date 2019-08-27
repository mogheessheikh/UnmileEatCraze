//
//  FileManager+Extension.swift
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//

import Foundation
import UIKit
extension FileManager {
    
    public static let documentsPath: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    
    public static let documentsURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    public static var tempFileURL: URL {
        let fileName = NSUUID().uuidString
        let temp = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        return temp
    }
    
    static public func getFilePath(fileName:String) -> URL {
        return documentsURL.appendingPathComponent(fileName)
    }
    
    public static var docsFileURL: URL {
        let fileName = NSUUID().uuidString
        let temp = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        return temp
    }
    
    
    //It will create new directory or return already created directory path
    static public func getDirctoryPath(directoryName:String, parentDirectory:String!) -> String {
        
        let fileManager = FileManager.default
        // var documentsPath1 = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        var directoryURL = documentsURL
        if(parentDirectory != nil){
            _ = self.getDirctoryPath(directoryName: parentDirectory, parentDirectory: nil) //create parent directory first
            directoryURL = documentsURL.appendingPathComponent(parentDirectory)
        }
        
        let logsPath = directoryURL.appendingPathComponent(directoryName)
        //print(logsPath)
        if !fileManager.fileExists(atPath: (logsPath.path)) {
            do {
                
                try FileManager.default.createDirectory(atPath: logsPath.path, withIntermediateDirectories: true, attributes: nil)
            } catch let error as NSError {
                NSLog("Unable to create directory \(error.debugDescription)")
            }
        }
        return (logsPath.absoluteString)
        
    }
    
    //It will create new directory or return already created directory path
    static public func getDirctoryURL(directoryName:String, parentDirectory:String!) -> URL {
        
        let fileManager = FileManager.default
        // var documentsPath1 = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        var directoryURL = documentsURL
        if(parentDirectory != nil){
            _ = self.getDirctoryPath(directoryName: parentDirectory, parentDirectory: nil) //create parent directory first
            directoryURL = documentsURL.appendingPathComponent(parentDirectory)
        }
        
        let logsPath = directoryURL.appendingPathComponent(directoryName)
        //print(logsPath)
        if !fileManager.fileExists(atPath: (logsPath.path)) {
            do {
                
                try FileManager.default.createDirectory(atPath: logsPath.path, withIntermediateDirectories: true, attributes: nil)
            } catch let error as NSError {
                NSLog("Unable to create directory \(error.debugDescription)")
            }
        }
        return logsPath
        
    }
    
    func moveItemFromURL(urlPath:URL, toURL: URL) {
        do {
            try FileManager.default.moveItem(atPath: urlPath.path, toPath:toURL.path)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func copyItemFromURL(urlPath:URL, toURL: URL) {
        do {
            try FileManager.default.copyItem(atPath: urlPath.path, toPath:toURL.path)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    
    
    
    
    
    
    func removeAnItemAtURL(urlPath:URL) {
        do {
            try FileManager.default.removeItem(at: urlPath)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func pathToURl(filePath: String) -> URL {
        return URL(fileURLWithPath: filePath)
        
    }
    func getFileURLsAt(url: URL, ext : String!) -> [URL]{
        
        do {
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [])
            //print(directoryContents)
            
            // if you want to filter the directory contents you can do like this:
            if(ext != nil){
                let mp3Files = directoryContents.filter{ $0.pathExtension == "mp3" }
                print("mp3 urls:",mp3Files)
                let mp3FileNames = mp3Files.map{ $0.deletingPathExtension().lastPathComponent }
                print("mp3 list:", mp3FileNames)
                return mp3Files
            }
            
            return directoryContents
            
        } catch {
            print(error.localizedDescription)
        }
        
        
        return []
    }
    func getFileURLsAt(path: String, ext : String!) -> [URL]{
        
        let directoryUrl =  URL.init(string: path)
        
        do {
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try FileManager.default.contentsOfDirectory(at: directoryUrl!, includingPropertiesForKeys: nil, options: [])
            //print(directoryContents)
            
            if(ext != nil){
                //filter the directory contents
                let mp3Files = directoryContents.filter{ $0.pathExtension == "mp3" }
                print("mp3 urls:",mp3Files)
                let mp3FileNames = mp3Files.map{ $0.deletingPathExtension().lastPathComponent }
                print("mp3 list:", mp3FileNames)
                return mp3Files
            }
            
            return directoryContents
        } catch {
            print(error.localizedDescription)
            //error return empty
            return []
        }
    }
    
    func getImageFromURL(path: URL) -> UIImage! {
        if(FileManager.default.fileExists(atPath: path.path)){
            return UIImage(contentsOfFile: path.path)!
        }
        return nil
    }
    
    
}
extension String {
    
    var lastPathComponent: String {
        return (self as NSString).lastPathComponent
    }
    var pathExtension: String {
        return (self as NSString).pathExtension
    }
    var stringByDeletingLastPathComponent: String {
        return (self as NSString).deletingLastPathComponent
    }
    var stringByDeletingPathExtension: String {
        return (self as NSString).deletingPathExtension
    }
    var pathComponents: [String] {
        return (self as NSString).pathComponents
    }
    func stringByAppendingPathComponent(path: String) -> String {
        let nsSt = self as NSString
        return nsSt.appendingPathComponent(path)
    }
    func stringByAppendingPathExtension(ext: String) -> String? {
        let nsSt = self as NSString
        return nsSt.appendingPathExtension(ext)
    }
}
extension UIResponder {
    var parentViewController: UIViewController? {
        return (self.next as? UIViewController) ?? self.next?.parentViewController
    }
}
