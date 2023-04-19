//
//  AppDelegate.swift
//  EventPlanner
//
//  Created by  on 2023-04-02.
//

import UIKit
import SQLite3

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    //-------------Jinling-------------------------
    var eventDatabaseName: String? = "eventdb.sql"
    var eventDatabasePath: String?
    var events : [Event] = []

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let documentPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        
        let documentEventDir = documentPaths[0]
        eventDatabasePath = documentEventDir.appending("/" + eventDatabaseName!)
        readEventDataFromDatabase()
        checkAndCreateEventDatabase()
        
        return true
    }
    
    func readEventDataFromDatabase(){
        events.removeAll()
        
        var db : OpaquePointer? = nil
        
        if sqlite3_open(self.eventDatabasePath, &db) == SQLITE_OK {
            
            print("Successfully opened connection to database at \(self.eventDatabasePath)")
            
            var queryStatement : OpaquePointer? = nil
            var queryStatementString : String = "Select * from events"
          
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK{
                
                while sqlite3_step(queryStatement) == SQLITE_ROW {
                    let id : Int = Int(sqlite3_column_int(queryStatement, 0))
                    let ctitle = sqlite3_column_text(queryStatement, 1)
                    let cdateTime = sqlite3_column_text(queryStatement, 2)
                    let ceventType = sqlite3_column_text(queryStatement, 3)
                    let chost = sqlite3_column_text(queryStatement, 4)
                    let clocationName = sqlite3_column_text(queryStatement, 5)
                    let caddress = sqlite3_column_text(queryStatement, 6)
                    let ccity = sqlite3_column_text(queryStatement, 7)
                    let cprovince = sqlite3_column_text(queryStatement, 8)
                    let cpostalCode = sqlite3_column_text(queryStatement, 9)
                    let cphoneNumber = sqlite3_column_text(queryStatement, 10)
                    
                    let title = String(cString : ctitle!)
                    let dateTimeString = String(cString: cdateTime!)
                    let eventType = String(cString: ceventType!)
                    let host = String(cString: chost!)
                    let locationName = String(cString: clocationName!)
                    let address = String(cString: caddress!)
                    let city = String(cString: ccity!)
                    let province = String(cString: cprovince!)
                    let postalCode = String(cString: cpostalCode!)
                    let phoneNumber = String(cString: cphoneNumber!)
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                    let dateTime = dateFormatter.date(from: dateTimeString)
                    
                    let event : Event = Event.init()
                    event.initWithData(id: id, title: title, dateTime: dateTime, eventType: eventType, host: host, locationName: locationName, address: title, city: city, province: province, postalCode: postalCode, phoneNumber: phoneNumber)
                    // add the new Data object to the people array
                    events.append(event)
                    
                    print("Query result")
                    print("\(id) | \(title) | \(dateTime) | \(eventType) | \(host) |\(locationName) | \(address) | \(city) | \(province) | \(postalCode) | \(phoneNumber)")
                    
                }
                sqlite3_finalize(queryStatement)
                
            }
            else{
                print("Select statement could not be prepared")
            }
            sqlite3_close(db)
            
        }
        else {
            print("Unable to open database")
        }
    }
    
    func insertIntoEventDatabase(event : Event) -> Bool {
        
        var db : OpaquePointer? = nil
        var returnCode : Bool = true
        
        // open connection of database
        if sqlite3_open(self.eventDatabasePath, &db) == SQLITE_OK {
            
            var insertStatement :OpaquePointer? = nil
            // set the ID column to NULL means let it auto increment
            // ? means placeholder
            var insertStatementString : String = "insert into events values(NULL, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
            
            if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
                // convert string to NSString
                let titleStr = event.title! as NSString
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"

                let dateTimeString = dateFormatter.string(from: event.dateTime!)
                let dateTimeStr = dateTimeString as NSString
                let eventTypeStr = event.eventType! as NSString
                let hostStr = event.host! as NSString
                let locationNameStr = event.locationName! as NSString
                let addressStr = event.address! as NSString
                let cityStr = event.city! as NSString
                let provinceStr = event.province! as NSString
                let postalCodeStr = event.postalCode! as NSString
                let phoneNumberStr = event.phoneNumber! as NSString
                
                // replace the ? in the insertStatementString
                // convert NSString to CString using .utf8String
                sqlite3_bind_text(insertStatement, 1, titleStr.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 2, dateTimeStr.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 3, eventTypeStr.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 4, hostStr.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 5, locationNameStr.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 6, addressStr.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 7, cityStr.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 8, provinceStr.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 9, postalCodeStr.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 10, phoneNumberStr.utf8String, -1, nil)
                
                if sqlite3_step(insertStatement) == SQLITE_DONE {
                    let rowID = sqlite3_last_insert_rowid(db)
                    print("Successfully inserted row \(rowID)")
                }
                else {
                    print("Could not insert row")
                    returnCode = false
                }
                sqlite3_finalize(insertStatement)
            }
            else{
                print("insert statement could not be prepared")
                returnCode = false
            }
            sqlite3_close(db)
        }
        else{
            print("Unable to open database")
            returnCode = false
        }
        
        return returnCode
    }
    
    
    func checkAndCreateEventDatabase(){
        
        var success = false
        let fileManager = FileManager.default
        
        success = fileManager.fileExists(atPath: eventDatabasePath!)
        
        if success {
            return
        }
        
        let databasePathFromApp = Bundle.main.resourcePath?.appending("/" + eventDatabasePath!)
        
        try? fileManager.copyItem(atPath: databasePathFromApp!, toPath: eventDatabasePath!)
        
        return
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

