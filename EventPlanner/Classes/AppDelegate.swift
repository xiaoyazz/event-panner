import UIKit
import SQLite3

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var UdatabaseName : String? = "Users.db"
    var UdatabasePath : String?
    var people : [User] = []

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let documentPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDir = documentPaths[0]
        UdatabasePath = documentsDir.appending("/" + UdatabaseName!)
        PdatabasePath = documentsDir.appending("/" + PdatabaseName!)
        checkAndCreateUserDatabase()
        checkAndCreateProfileDatabase()
        readDataFromUserDatabase()
        readDataFromProfileDatabase()
        return true
    }

    func checkAndCreateUserDatabase() {
        var success = false
        let fileManager = FileManager.default
           
        success = fileManager.fileExists(atPath: UdatabaseName!)
       
        if success {
            return
        }
        
        let databasePathFromApp = Bundle.main.resourcePath?.appending("/" + UdatabaseName!)

        try? fileManager.copyItem(atPath: databasePathFromApp!, toPath: UdatabasePath!)
       
        return;
    }
    
    func readDataFromUserDatabase() {
        people.removeAll()
           
        var db: OpaquePointer? = nil
               
        if sqlite3_open(self.UdatabasePath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(self.UdatabasePath)")
                   
            var queryStatement: OpaquePointer? = nil
            var queryStatementString : String = "select * from user"
                
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
                       
                while( sqlite3_step(queryStatement) == SQLITE_ROW ) {
                    
                    let id: Int = Int(sqlite3_column_int(queryStatement, 0))
                    let cname = sqlite3_column_text(queryStatement, 1)
                    let cemail = sqlite3_column_text(queryStatement, 2)
                    let cpassword = sqlite3_column_text(queryStatement, 3)
                           
                    let name = String(cString: cname!)
                    let email = String(cString: cemail!)
                    let password = String(cString: cpassword!)
                        
                    let user : User = User.init()
                    user.initWithData(theRow: id, theName: name, theEmail: email, thePassword: password)
                    people.append(user)
                }

            sqlite3_finalize(queryStatement)
            } else {
                print("SELECT statement could not be prepared")
            }
                   
        sqlite3_close(db);

        } else {
            print("Unable to open database.")
        }
           
    }
    
    func insertIntoUserDatabase(person : User) -> Bool {
        var db: OpaquePointer? = nil
        var returnCode : Bool = true
               
        if sqlite3_open(self.UdatabasePath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(self.UdatabasePath)")
                   
            var insertStatement: OpaquePointer? = nil
            var insertStatementString : String = "insert into user values(NULL, ?, ?, ?)"
                   
            if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
                    
                let nameStr = person.name! as NSString
                let emailStr = person.email! as NSString
                let passwordStr = person.password! as NSString
                       
                sqlite3_bind_text(insertStatement, 1, nameStr.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 2, emailStr.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 3, passwordStr.utf8String, -1, nil)
                       
                if sqlite3_step(insertStatement) == SQLITE_DONE {
                    let rowID = sqlite3_last_insert_rowid(db)
                    print("Successfully inserted row. \(rowID)")
                } else {
                    print("Could not insert row.")
                    returnCode = false
                }
                    
                sqlite3_finalize(insertStatement)
                    
            } else {
                print("INSERT statement could not be prepared.")
                let errorMsg = String(cString: sqlite3_errmsg(db))
                print(errorMsg)
                returnCode = false
            }
                   
            sqlite3_close(db);
                   
        } else {
            print("Unable to open database.")
            returnCode = false
        }
        return returnCode
            
    }

    func userExists(userEmail: String, userPassword: String) -> Bool {
        readDataFromUserDatabase()
        if let index = people.firstIndex(where: { $0.email == userEmail && $0.password == userPassword }) {
            return true
        } else {
            return false
        }
    }
    func signOut() {
        setCurrentEmail(sentEmail: nil)
    }
    
    //-------------------MOEEZ-----------------
    var PdatabaseName : String? = "Profile.db"
    var PdatabasePath : String?
    var profiles : [Profile] = []
    var currentUserEmail : String?
    
    func setCurrentEmail(sentEmail: String?){
        currentUserEmail = sentEmail
    }
    func checkAndCreateProfileDatabase() {
        var success = false
        let fileManager = FileManager.default
           
        success = fileManager.fileExists(atPath: PdatabaseName!)
       
        if success {
            return
        }
        
        let databasePathFromApp = Bundle.main.resourcePath?.appending("/" + PdatabaseName!)

        try? fileManager.copyItem(atPath: databasePathFromApp!, toPath: PdatabasePath!)
       
        return;
    }
    
    func readDataFromProfileDatabase() {
        profiles.removeAll()
           
        var db: OpaquePointer? = nil
               
        if sqlite3_open(self.PdatabasePath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(self.PdatabasePath)")
                   
            var queryStatement: OpaquePointer? = nil
            var queryStatementString : String = "select * from profile"
                
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
                       
                while( sqlite3_step(queryStatement) == SQLITE_ROW ) {
                    
                   let id: Int = Int(sqlite3_column_int(queryStatement, 0))
                    let cPic = sqlite3_column_text(queryStatement, 1)
                    let cName = sqlite3_column_text(queryStatement, 2)
                    let cEmail = sqlite3_column_text(queryStatement, 3)
                    let cBio = sqlite3_column_text(queryStatement, 4)
                    
                    
                    let pic = String(cString: cPic!)
                    let name = String(cString: cName!)
                    let email = String(cString: cEmail!)
                    let bio = String(cString: cBio!)
                    
                    let profile : Profile = Profile.init()
                    profile.initWithData(id: id, pic: pic,name: name,email: email,bio: bio)
                    profiles.append(profile)
                }

            sqlite3_finalize(queryStatement)
            } else {
                print("SELECT statement could not be prepared")
            }
                   
        sqlite3_close(db);

        } else {
            print("Unable to open database.")
        }
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


