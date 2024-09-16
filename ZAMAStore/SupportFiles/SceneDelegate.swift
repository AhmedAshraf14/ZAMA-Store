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
    
    private func isValidAccount(email: String, password: String) {
        let parameters = ["query": "email:\(email)"]
        
        NetworkService().getData(path: "customers/search", parameters: parameters, model: CustomersResponse.self) { result, error in
            guard let result = result else {
                print("Error fetching customer: \(error!.localizedDescription)")
                return
            }
            
            let customer = result.customers.first
            let isGoogle = UserDefaults.standard.bool(forKey: "isGoogle")
            
            if isGoogle {
                self.handleGoogleLogin(for: customer)
            } else {
                self.handleEmailLogin(for: customer, password: password)
            }
        }
    }

    private func handleGoogleLogin(for customer: Customer?) {
        guard let customer = customer else {
            print("No customer found")
            return
        }
        
        MyAccount.shared.currentUser = customer
        
        if let tags = customer.tags, !tags.isEmpty {
            getDraftlist(draftID: tags)
        }
        
        if let note = customer.note, !note.isEmpty {
            getDraftlist(draftID: note, isCartList: true)
        }
    }

    private func handleEmailLogin(for customer: Customer?, password: String) {
        guard let customer = customer else {
            print("No customer found")
            return
        }
        
        Auth.auth().signIn(withEmail: customer.email, password: password) { authResult, error in
            if let error = error {
                print("Email or password is incorrect: \(error.localizedDescription)")
                return
            }
            
            MyAccount.shared.currentUser = customer
            
            if let tags = customer.tags, !tags.isEmpty {
                self.getDraftlist(draftID: tags)
            }
            
            if let note = customer.note, !note.isEmpty {
                self.getDraftlist(draftID: note, isCartList: true)
            }
        }
    }

    private func getDraftlist(draftID: String, isCartList: Bool = false) {
        let path = "draft_orders/\(draftID)"
        
        NetworkService().getDraftOrders(path: path, parameters: [:]) { result, error in
            guard let data = result else {
                print("Error fetching draft list: \(error!.localizedDescription)")
                return
            }
            
            let draftList = isCartList ? MyDraftlist.cartListShared : MyDraftlist.wishListShared
            self.settingDraftlist(data: data, draftList: draftList)
        }
    }

    private func settingDraftlist(data: Data, draftList: MyDraftlist) {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            let fixedJsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
            
            let draftOrder = try JSONDecoder().decode(DraftOrderResponseModel.self, from: fixedJsonData)
            draftList.currentDraftlist = draftOrder.draftOrder
        } catch {
            print("Error decoding draft list: \(error.localizedDescription)")
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

