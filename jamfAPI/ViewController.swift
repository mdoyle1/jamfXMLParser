//
//  ViewController.swift
//  jamfAPI
//
//  Created by Doyle, Mark(Information Technology Services) on 12/18/18.
//  Copyright © 2018 Doyle, Mark(Information Technology Services). All rights reserved.
//

import Cocoa

class ViewController: NSViewController, XMLParserDelegate {

    private var buildings: [Buildings]?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     fetchData()
    }
    
    
    // Calls the feed parser class in the XMLParser.swift
    private func fetchData(){
        let feedParser = FeedParser()
        feedParser.parseFeed(url: "ENTER JAMF URL /JSSResource/buildings") {
            (buildings) in self.buildings = buildings
            print(buildings)
        }
    }

    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


        

}





