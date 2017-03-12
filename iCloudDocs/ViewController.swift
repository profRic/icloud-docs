//
//  ViewController.swift
//  iCloudDocs
//
//  Copyright © 2017 telfordventures. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    
    var document: MyDocument?
    var documentURL: URL?
    var iCloudURL: URL?
    var metaDataQuery: NSMetadataQuery?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let filemgr = FileManager.default
        if let tempiCloudURL = filemgr.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents") {
            
            iCloudURL = tempiCloudURL.appendingPathComponent("SampleDoc.txt")
            // now you have to find a file in the iCloud container by doing a metaDataQuery
            print(iCloudURL as Any)
            metaDataQuery = NSMetadataQuery()
            metaDataQuery?.predicate = NSPredicate(format: "%K like 'SampleDoc.txt'", NSMetadataItemFSNameKey)
            metaDataQuery?.searchScopes = [NSMetadataQueryUbiquitousDocumentsScope]
            
            NotificationCenter.default.addObserver(self, selector: #selector(ViewController.metadataQueryDidFinishGathering(_:)), name: NSNotification.Name.NSMetadataQueryDidFinishGathering, object: metaDataQuery)
            metaDataQuery!.start()
        } else {
            print("error opening file - probably forgot to log into iCloud")
        }
    }
    
    func metadataQueryDidFinishGathering(_ notification: Notification) -> Void
    {
        let query: NSMetadataQuery = notification.object as! NSMetadataQuery
        
        query.disableUpdates()
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.NSMetadataQueryDidFinishGathering, object: query)
        query.stop()
        let results = query.results
        
        if query.resultCount == 1 {
            let resultURL =
                (results[0] as AnyObject).value(forAttribute: NSMetadataItemURLKey) as! URL
            
            document = MyDocument(fileURL: resultURL)
            
            document?.open(completionHandler: {(success: Bool) -> Void in
                if success {
                    print("iCloud file open OK")
                    self.textField.text = self.document?.userText
                    self.iCloudURL = resultURL
                } else {
                    print("iCloud file open failed")
                }
            })
        } else {
            document = MyDocument(fileURL: iCloudURL!)
            
            document?.save(to: iCloudURL!, for: .forCreating, completionHandler: {(success: Bool) -> Void in
                if success {
                    print("iCloud create OK")
                } else {
                    print("iCloud file open failed")
                }
            })
        }
    }
    
    
    @IBAction func saveDocument(_ sender: AnyObject) {
        if document != nil {
            document!.userText = textField.text
            document?.save(to: iCloudURL!, for: .forOverwriting, completionHandler: {(success: Bool) -> Void in
                if success {
                    print("Save overwrite OK")
                } else {
                    print("Save overwrite failed")
                }
            })
        } else {
            print("document does not exist - error in creating")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

class MyDocument: UIDocument {
    
    var userText: String? = "This is just some sample text to show a document write to iCloud Drive."
    
    override func contents(forType typeName: String) throws -> Any {
        if let content = userText {
            let length = content.lengthOfBytes(using: String.Encoding.utf8)
            return Data(bytes: UnsafePointer<UInt8>(content), count: length)
        }
        else {
            return Data()
        }
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        if let userContent = contents as? Data {
            userText = NSString(bytes: (contents as AnyObject).bytes, length: userContent.count, encoding: String.Encoding.utf8.rawValue) as? String
        }
    }
    
}


