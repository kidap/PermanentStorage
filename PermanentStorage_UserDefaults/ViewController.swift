//
//  ViewController.swift
//  PermanentStorage_UserDefaults
//
//  Created by Karlo Pagtakhan on 01/11/2016.
//  Copyright © 2016 AccessIT. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        //Save using NSUserDefaults
        saveInNSUserDefaults()
        
        //Retrieve the saved data using NSUserDefaults
        getFromUserDefaults()
        
        
        //Save - Core Data
        //insertDataToCoreData()
        
        
        //Delete - Core Data
        //deleteDataInCoreData()
        
        //Retrieve - CoreData
        getDataFromCoreData()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveInNSUserDefaults(){
        let savedArray = [1,3,5,7,11]
        
        NSUserDefaults.standardUserDefaults().setObject("Karlo", forKey: "NameString")
        NSUserDefaults.standardUserDefaults().setObject(savedArray, forKey: "NumberArray")

    
    }
    
    func getFromUserDefaults(){
        //Retrieve saved string
        let username = NSUserDefaults.standardUserDefaults().objectForKey("NameString")
        print("Username saved in NSUserDefault: \(username!)")
        
        //Retrieve saved array, downcast to NSArray
        let retrievedArray = NSUserDefaults.standardUserDefaults().objectForKey("NumberArray") as! NSArray
        
        for number in retrievedArray {
            print(number)
        }
    }
    
    func insertDataToCoreData(){
        
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.managedObjectContext
        
        
        let newUser = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: context)
        
        newUser.setValue("SCooper", forKey: "userName")
        newUser.setValue("Sheldon", forKey: "firstName")
        
        do{
            try context.save()
            print("Save \(newUser.valueForKey("userName")!)")
        } catch{
            print("Context cannot be saved")
        }
    
    }
    
    func getDataFromCoreData(){
        
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.managedObjectContext
        
        // Request from Context
        let request = NSFetchRequest(entityName: "User")
        request.returnsObjectsAsFaults = false
        
        //Execute Fetch request
        do {
            let results = try context.executeFetchRequest(request)
            
            if results.count > 0{
                for result in results as! [NSManagedObject]{
                    print("Username: \(result.valueForKey("userName")!)")
                    print("First Name: \(result.valueForKey("firstName")!)")
                }
                
            } else {
                print("No users saved.")
            }
        } catch {
        
        }
        
    }
    
    func deleteDataInCoreData(){
        
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.managedObjectContext
        
        //Filter data in context
        let request = NSFetchRequest(entityName: "User")
        request.predicate = NSPredicate(format: "userName = %@", "SCooper")
        request.returnsObjectsAsFaults = false
        
        //Execute Fetch request
        do{
            let results = try context.executeFetchRequest(request)

                for result in results as! [NSManagedObject]{
                    
                    //Get Username
                    var userName = ""
                    userName = result.valueForKey("userName") as! String
                    
                    //Delet object from context
                    context.deleteObject(result)
                    
                    //Commmit save
                    do{
                        try context.save()
                        print("Deleted \(userName)")
                    } catch{
                        print("Context cannot be saved")
                    }
                }
            
        } catch {
        
        }
        
    }
    


}

