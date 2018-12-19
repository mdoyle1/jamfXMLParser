//
//  XMLParser.swift
//  jamfAPI
//
//  Created by Doyle, Mark(Information Technology Services) on 12/19/18.
//  Copyright © 2018 Doyle, Mark(Information Technology Services). All rights reserved.
//

import Foundation

struct Buildings {
    var id: String
    var building: String
    
}

class FeedParser: NSObject, XMLParserDelegate

{
    //Create the empty array called buildings...
    private var buildings: [Buildings] = []
    //Create the currentElement variable...
    private var currentElement = ""
   
    
    //Current ID
    private var currentID: String = "" {
        didSet{
        currentID = currentID.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    //Current Building
    private var currentBuilding: String = "" {
        didSet {
            currentBuilding = currentBuilding.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var parserCompletionadler: (([Buildings]) -> Void)?
    
    //url comes from ViewController fetch data function
    func parseFeed(url: String, completionHandler: (([Buildings]) -> Void)?){
        self.parserCompletionadler = completionHandler
        
        
        let username = "ENTER USER NAME"
        let password = "ENTER PASSWORD"
        
      
        var request = URLRequest(url: URL(string:url)!)
        let config = URLSessionConfiguration.default
        
        //API Authentication
        let userPasswordString = "\(username):\(password)"
        let userPasswordData = userPasswordString.data(using: String.Encoding.utf8)
        let base64EncodedCredential = userPasswordData!.base64EncodedString(options: [])
        let authString = "Basic \(base64EncodedCredential)"
        config.httpAdditionalHeaders = ["Authorization" : authString]
        let urlSession = URLSession(configuration: config)
        request.httpMethod = "GET"
        let task = urlSession.dataTask(with: request as URLRequest) { (data, response, error) in

            guard let data = data else {
                if let error = error {
                    print (error.localizedDescription)
                }
            return
            }
            
            /// parse our xml data
            
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        
    }
        task.resume()
}

    //MARK: - XML Parser Delegate
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if currentElement == "buildings" {
            currentID = ""
            currentBuilding = ""
        }
    }
    
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "id": currentID += string
        case "name": currentBuilding += string
        default: break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "buildings"{
            let inventory = Buildings(id: currentID, building: currentBuilding)
       self.buildings.append(inventory)
        }
        
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        parserCompletionadler?(buildings)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError.localizedDescription)
    }
}
