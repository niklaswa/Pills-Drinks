//
//  ItemInterfaceController.swift
//  WatchExtension Extension
//
//  Created by Niklas on 23.04.18.
//  Copyright © 2018 Niklas. All rights reserved.
//

import UIKit
import WatchKit
import Foundation
import WatchConnectivity

class ItemInterfaceController: WKInterfaceController, WCSessionDelegate {

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }

    @IBOutlet var itemTable: WKInterfaceTable!
    
    var data = ["Fanta","Cola","Sprite"]
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
            
            session.sendMessage(
                ["request" : "items"],
                replyHandler: { (response) in
                    print(response)
                    //data.append()
                },
                errorHandler: { (error) in
                    print("Error sending message: %@", error)
                }
            )
        }
        
        
    }
    
    
    func tableRefresh(){
        itemTable.setNumberOfRows(data.count, withRowType: "row")
        for item in data {
            let row = itemTable.insertRows(at: data.index(of: item)!, withRowType: nil)
            row.myLabel.setText(item)
        }
    }
    

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
}
