//
//  ContentViewModel.swift
//  TargetPrice
//
//  Created by Philip Dunker on 01/06/24.
//

import Firebase
import Combine
import FirebaseDatabase
import FirebaseDatabaseSwift

class ContentViewModel: ObservableObject {
    
    private var service = AuthService.shared // calls hasOpenUserSession
    
    @Published var filterByCateg = "Todos"
    @Published var sortedBy = "variation-decreasing"
    @Published var searchText = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    private var fcmToken = ""
    
    @Published var assets = [Asset]()
    @Published var alarms = [Alarm]()
    
    @Published var loadingAssets = true
    @Published var loadingAlarms = false
    
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    
    @Published var selectedTab = 1
    
    var assetNameMaxWidth: CGFloat = 0
    
    init() {
        setupListeners()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.fcmTokenNotificationReceived(notification:)),
                                               name: Notification.Name.fcmTokenReceived, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.appActivatedNotificationReceived(notification:)),
                                               name: Notification.Name.appActivated, object: nil)
    }
    
    @objc func fcmTokenNotificationReceived(notification: Notification) {
        //print("DEBUG: ContentViewModel.fcmTokenNotificationReceived()")
        if notification.name != Notification.Name.fcmTokenReceived {
            //print("DEBUG: notification.name ignored:", notification.name)
            return
        }
        guard let fcmToken = notification.object as? String else {
            //print("DEBUG: Couldn't convert notification.object to string!")
            return
        }
        self.fcmToken = fcmToken
        print("FCMToken received:", self.fcmToken)
        
        if self.currentUser != nil && self.fcmToken != "" {
            self.updateUserData()
        }
    }
    
    @objc func appActivatedNotificationReceived(notification: Notification) {
        //print("DEBUG: ContentViewModel.appActivatedNotificationReceived()")
        Task {
            await self.fetchAssetsData()
            await self.fetchAlarms()
        }
    }
    
    func setupListeners() {
        
        // USER SESSION
        AuthService.shared.$userSession.sink { [weak self] userSession in
            self?.userSession = userSession
        }
        .store(in: &cancellables)
        
        
        // CURRENT USER
        AuthService.shared.$currentUser.sink { [weak self] user in
            let userExist = user != nil
            //print("DEBUG: currentUser.sink{} userExist ? ", userExist)
            
            guard let contentViewModel = self else {
                //print("DEBUG: no ContentViewModel, returning.")
                return
            }
            
            let currentUser = contentViewModel.currentUser
            if  currentUser != nil && userExist && currentUser!.id == user!.id {
                //print("DEBUG: Same user, returning!")
                return
            }
            
            contentViewModel.currentUser = user
            if userExist {
                contentViewModel.selectedTab = 1
                Task {
                    await contentViewModel.fetchAlarms()
                    if contentViewModel.fcmToken != "" &&
                       AuthService.shared.currentUser?.fcmToken != contentViewModel.fcmToken
                    {
                        contentViewModel.updateUserData()
                    }
                }
            }
        }
        .store(in: &cancellables)
        
        
        DatabaseService.shared.$assets.sink { [weak self] assets in
            if !assets.isEmpty {
                self?.applyCategFilter(assets)
                self?.loadingAssets = false
            }
        }
        .store(in: &cancellables)
        
    }
    
    func sortAssets(_ typeOfSort: String = "") {
        var sortBy: String
        if typeOfSort != "" {
            sortBy = typeOfSort
        } else {
            sortBy = self.sortedBy
        }
        
        if sortBy == "alphabetical" {
            self.assets.sort(by: {$0.name < $1.name })
        } else if sortBy == "unalphabetical" {
            self.assets.sort(by: {$0.name > $1.name })
        } else if sortBy == "variation-decreasing" {
            self.assets.sort(by: {$0.variation > $1.variation })
        } else if sortBy == "variation-increasing" {
            self.assets.sort(by: {$0.variation < $1.variation })
        } else if sortBy == "price-decreasing" {
            self.assets.sort(by: {$0.price > $1.price })
        } else if sortBy == "price-increasing" {
            self.assets.sort(by: {$0.price < $1.price })
        } else if sortBy == "volume-increasing" {
            self.assets.sort(by: {$0.volume < $1.volume })
        } else if sortBy == "volume-decreasing" {
            self.assets.sort(by: {$0.volume > $1.volume })
        }  else if sortBy == "updated-recently" {
            self.assets.sort(by: {$0.updated > $1.updated })
        }  else if sortBy == "updated-oldest" {
            self.assets.sort(by: {$0.updated < $1.updated })
        }
        self.sortedBy = sortBy
    }
    
    func applyCategFilter(_ inAssets: [Asset]? = nil) {
        var assets: [Asset]
        if inAssets != nil {
            assets = inAssets!
        } else {
            assets = DatabaseService.shared.assets
        }
        if self.filterByCateg == "Todos" {
            // does nothing
        }
        else if self.filterByCateg == "Fav." {
            assets = assets.filter({ self.isAssetFav(assetName: $0.name) })
        } else if self.filterByCateg == "Cripto" {
            assets = assets.filter({ $0.sector == Asset.SectorCrypto })
        } else {
            var filter = self.filterByCateg
            if self.filterByCateg == "EUA" {
                filter = "USA"
            }
            assets = assets.filter({ return $0.country == filter })
        }
        
        if searchText != "" {
            assets = assets.filter({
                $0.name.uppercased().contains(searchText.uppercased()) ||
                $0.fullname.uppercased().contains(searchText.uppercased())
            })
        }
        
        self.assetNameMaxWidth = 0
        for asset in assets {
            if asset.nameWidth > self.assetNameMaxWidth {
                self.assetNameMaxWidth = asset.nameWidth
            }
        }

        self.assets = assets
        self.sortAssets()
    }
    
    func isAssetFav(assetName: String) -> Bool {
        return self.currentUser?.assetsNames.contains(assetName) ?? false
    }
    
    @MainActor
    func fetchAssetsData() async {
        self.assets = []
        self.loadingAssets = true
        DatabaseService.shared.fetchAllAssets()
        DatabaseService.shared.fetchAllBonds()
    }
    
    func resetVariables() {
        self.userSession = nil
        self.currentUser = nil
        self.alarms = [Alarm]()
        //self.assets = [Asset]()
    }
    
    @MainActor
    func logout() async {
        AuthService.shared.logout()
        DatabaseService.shared.assets.removeAll()
        self.resetVariables()
    }
    
    @MainActor
    func deleteAccount(_ showAlertCb: @escaping (String) -> ()) async {
        if self.currentUser == nil { return }
        
        AuthService.shared.deleteAccount({ errorMessage in
            if errorMessage == "" {
                try? await UserService.deleteAccount(withUid: self.currentUser!.id)
                self.resetVariables()
            } else {
                showAlertCb(errorMessage)
            }
        })
    }
    
    func updateUserStaredAssets(_ assetName: String) {
        if self.currentUser == nil { return }
        let favorite = self.currentUser!.assetsNames.contains(assetName)
        if favorite {
            self.currentUser!.assetsNames.removeAll(where: { $0 == assetName })
        } else {
            self.currentUser!.assetsNames.append(assetName)
        }
        self.updateUserData()
    }
    
    func updateUserData() {
        //print("DEBUG: ContentViewModel.updateUserData()")
        if self.currentUser == nil {
            //print("DEBUG: self.currentUser == nil !")
            return
        }
        if AuthService.shared.currentUser == nil {
            //print("DEBUG: AuthService.shared.currentUser == nil !")
            return
        }
        if self.fcmToken != "" {
            AuthService.shared.currentUser!.fcmToken = self.fcmToken
        }
        AuthService.shared.currentUser!.assetsNames = self.currentUser!.assetsNames
        Task {
            await AuthService.shared.updateUserData(user: AuthService.shared.currentUser!)
        }
    }
    
    @MainActor
    func fetchAlarms() async {
        self.alarms = []
        if self.currentUser == nil {
            self.loadingAlarms = false
            return
        }
        self.loadingAlarms = true
        let userId = self.currentUser?.id
        self.alarms = await AlarmService.shared.fetchAlarms(userId: userId!)
        self.loadingAlarms = false
    }
    
    func addAlarm(assetName: String, priceTxt: String, sendNotif: Bool, sendEmail: Bool) async {
        guard let asset = self.assets.first(where: { $0.name == assetName }) else { return }
        let alarm = AlarmService.shared.addAlarm(asset: asset, priceTxt: priceTxt, sendNotif: sendNotif, sendEmail: sendEmail)
        guard let alarm = alarm else { return }
        DispatchQueue.main.async {
            self.alarms.append(alarm)
        }
    }
    
    func deleteAlarm(_ alarm: Alarm) {
        AlarmService.shared.deleteAlarm(alarmId: alarm.id)
        var index = 0
        for a in self.alarms {
            if a.id == alarm.id {
                self.alarms.remove(at: index)
                break
            }
            index = index + 1
        }
    }
    
    func getPrevAssetFor(assetName: String) -> String? {
        let index = self.assets.firstIndex { asset in
            asset.name == assetName
        }
        guard let index = index else {
            return nil
        }
        let prevIndex = index - 1
        if prevIndex < 0 {
            return nil
        }
        return self.assets[prevIndex].name
    }
    
    func getNextAssetFor(assetName: String) -> String? {
        let index = self.assets.firstIndex { asset in
            asset.name == assetName
        }
        guard let index = index else {
            return nil
        }
        let nextIndex = index + 1
        if nextIndex == self.assets.count {
            return nil
        }
        return self.assets[nextIndex].name
    }
    
    func cleanRangAlarms() {
        for alarm in self.alarms {
            if alarm.rang {
                AlarmService.shared.deleteAlarm(alarmId: alarm.id)
            }
        }
        self.alarms.removeAll { $0.rang }
    }
}
