//
//  AppDelegate.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 01/13/2017.
//  Copyright (c) 2017 Sebastian Mamczak. All rights reserved.
//

import UIKit
import IndigoOmtIosLibrary

import SwiftyJSON
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        // setup ui
        UIDesignHelper.updateUI(application, window: window)

        // load state
        let au = AuthUtil.default
        au.loadState()

        // auth util is authorized and we have user info
        if au.isAuthorized, let userInfo = au.getUserInfo() {

            // username for future gateway
            //let username = userInfo.preferredUsername
            let username = Constants.tempUsername

            // init future gateway object
            let fgu = FutureGatewayUtil.default
            fgu.initializeFutureGateway(username: username, provider: au.getAccessTokenProvider())
            
            
            let fg = fgu.getFutureGateway()!
            
            
            print(" ")
            print(au.getAccessTokenProvider()!.getAccessToken())
            print(" ")
            
            
            //let c: URL = URL(string: "")!
            
            /*
            
            Alamofire
                .upload(multipartFormData: { multipartFormData in
                multipartFormData.appendBodyPart(fileURL: imagePathUrl!, name: "photo")
                multipartFormData.appendBodyPart(fileURL: videoPathUrl!, name: "video")
            },
                                    with: , encodingCompletion: { (<#SessionManager.MultipartFormDataEncodingResult#>) in
                                        <#code#>
                }))
 
            */
            
            /*
            fg.taskApi.deleteTask(with: "245", { (response: FGApiResponse<FGMessageObject>) in
                print(response)
            })*/
            
            /*
            fg.taskCollectionApi.listAllTasks({ (response: FGApiResponse<FGTaskCollection>) in
                print(response)
            })
            */
            
            /*
            
            
            
            
            
            fg.taskCollectionApi.listAllTasks({ (response: FGApiResponse<FGTaskCollection>) in
                
                //print(response.value?.tasks)
                
                
                
                let f = "256"
                let str = response.value?.tasks.filter { $0.id == f }.first?.links.filter { $0.rel == "input" }.first?.href ?? ""
                
                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let fileURL = documentsURL.appendingPathComponent("z.txt")
                print(documentsURL)
                
                
                let task = response.value?.tasks.filter { $0.id == f }.first
                
                print(task)
                
                //return;
                
                let apiLink = task!.links.filter { $0.rel == "input" }.first!
                
                
                print(task?.inputFiles.map { $0.name! + " " + $0.status!.rawValue })
                
                print(task!.status)
                
                
                /*
                fg.fileApi.download(task!.inputFiles[0], to: fileURL, { (f:FGApiResponse<FGEmptyObject>) in
                    print(f)
                })*/
                
                
                
                fg.fileApi.upload(task!.inputFiles[0] , to: apiLink, from: fileURL, { (response: FGApiResponse<FGEmptyObject>) in
                    
                    print("---->")
                    
                    print(response)
                    
                })
                
                
                
            })
            
 
    
            
            */
                        
            
            
            
            /*
            fgu.getFutureGateway()?.taskCollectionApi.listAllTasks({ re in
                print(re.value?.tasks)
            })
            
            return true;
            */
            
            /*
            fgu.getFutureGateway()?.taskApi.deleteTask(with: "233", { (re:FGApiResponse<FGEmptyObject>) in
                
                print(re)
                
            })
            */
            
            
            
            
            
            
            
            
            
            let task = FGTask()
            //task.id = "240"
            task.application = "2"
            task.taskDescription = "My task description"
            
            
            //task.user = "test"
            
            /*
            task.arguments = [
                "arg0",
                "arg1"
            ]
            */
            
            let inputFile1 = FGInputFile()
            inputFile1.name = "sayhello.sh"
            let inputFile2 = FGInputFile()
            inputFile2.name = "sayhello.txt"
            task.inputFiles = [inputFile1, inputFile2]
            /*
            id
            status
            date
            links
            username
            intrastructure task = nil
            output files
            */
            
            /*
            fgu.getFutureGateway()?.taskCollectionApi.createTask(task) { (re:FGApiResponse<FGTask>) in
                print(re)
                print(re.value?.id)
                
                let task = re.value!
                
                
                
                
                /*
                
                fgu.getFutureGateway()?.taskApi.deleteTask(with: task.id!, { (cc:FGApiResponse<FGMessageObject>) in
                    
                    print(cc)
                })*/
            }
            */
            
            
            // show login view as first view if not authorized
            self.window?.rootViewController = UIHelper.loadViewController("LoginNavigationController")
        }

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: - OAuth

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        AuthUtil.default.resumeAuthorizationFlow(url)
        return true
    }

}
