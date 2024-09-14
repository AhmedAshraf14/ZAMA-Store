//
//  SceneDelegate.swift
//  ZAMAStore
//
//  Created by Ahmed Ashraf on 02/09/2024.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        let us = UserDefaults.standard
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        let flag = us.bool(forKey: "flag")
        let storyboard = UIStoryboard(name: flag ? "Main" : "Main3", bundle: nil)
        if(flag){
            let email = us.string(forKey: "email")
            let password = us.string(forKey: "password")
            
            isValidAccount(email: email!, password: password!)
        }
        let initialViewController = storyboard.instantiateInitialViewController()
        window.rootViewController = initialViewController
        self.window = window
        window.makeKeyAndVisible()
    }
    
    private func isValidAccount(email: String, password: String){
        NetworkService().getData(path: "customers/search", parameters: ["query":"email:\(email)"], model: CustomersResponse.self) { result, error in
            if let result = result{
                Auth.auth().signIn(withEmail: result.customers[0].email, password: password) {authresult, error in
                    if let _ = error{
                        //self?.noResult("email or password is Incorrect")
                    }else {
                        MyAccount.shared.currentUser = result.customers[0]
                        if result.customers[0].tags != ""{
                            self.getDraftlist(draftID: result.customers[0].tags!)
                        }
                        if(result.customers[0].note != nil && result.customers[0].note != ""){
                            self.getDraftlist(draftID: result.customers[0].note!,isCartList:true)
                        }
                    }
                }
            }else {
                //self?.noResult("Try again please")
            }
        }
    }
    
    private func getDraftlist(draftID:String,isCartList:Bool = false){
        NetworkService().getDraftOrders(path: "draft_orders/\(draftID)", parameters: [:]) { result, error in
            if let result = result {
                self.settingDraftlist(data: result,draftList: isCartList ? MyDraftlist.cartListShared : MyDraftlist.wishListShared)
            }else {
                print(error!.localizedDescription)
            }
        }
    }
    
    private func settingDraftlist(data:Data,draftList:MyDraftlist){
        do{
            if let dataString = String(data: data, encoding: .utf8){
                if let jsonData = dataString.data(using: .utf8) {
                    
                    let jsonObject = try! JSONSerialization.jsonObject(with: jsonData, options: [])
                    
                    let fixedJsonData = try! JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
                    
                    if let jsonString = String (data: fixedJsonData, encoding: .utf8) {
                        let ourJson = jsonString.data(using: .utf8)
                        let draft = try! JSONDecoder().decode(DraftOrderResponseModel.self, from: ourJson!)
                        draftList.currentDraftlist = draft.draftOrder
                    }
                }
            }
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
}

