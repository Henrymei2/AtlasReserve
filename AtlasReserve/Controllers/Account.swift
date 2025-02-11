//
//  Account.swift
//  AtlasReserve
//
//  Created by Hengyu Mei on 7/2/23.
//

import Foundation
import UIKit
import Kingfisher

class Account:ObservableObject{
    @Published var email:String = "";
    @Published var password:String = "";
    @Published var username:String = "";
    @Published var id:Int = 10031; // TODO: Test
    @Published var loggedIn:Bool = false;
    @Published var isOwner = true; // TODO: Test
    @Published var response:String = "";
    @Published var responses:Dictionary = [
        /* addAccount
         * 1: Cannot register because username or email is already registered
         * 2: Cannot register because of other unhandled issues
         * 3: Successfully registered the account
         */
        "addAccount": 0,
        /* Login
         * 1: Cannot login because cannot find account
         * 2: Cannot login because password is incorrect
         * 3: Cannot login because of other unhandled issues
         * 4: Successfully logged in
         */
        "login": 0,
        // courtFetch 1: fetch completed
        "courtFetch": 0,
        // fieldFetch 1: fetch completed
        "fieldFetch": 0,
        /* reserve
         * 1: Cannot reserve because the some other users including themselves has already reserved this field
         * 2: Cannot reserve because other unhandled issues
         * 3: Successfully made the reservation
         */
        "reserve": 0,
        // fieldAvailableFetch 1: fetch completed
        "fieldAvailableFetch": 0,
        // reservationsByUserIDFetch 1: fetch completed
        "reservationsByUserIDFetch": 0,
        // reservationsByCourtIDFetch 1: fetch completed
        "reservationsByCourtIDFetch": 0,
        /* addField
         * 1: Cannot add because entered information contains error: such as startTime > endTime
         * 2: Cannot add field because other unhandled issues
         * 3: Successfully added the field
         */
        "addField": 0,
        /* modifyField
         * 1: Cannot modify because entered information contains error: such as startTime > endTime
         * 2: Cannot modify field because other unhandled issues
         * 3: Successfully modified all the fields
         * 4: 4 to 4+number of modified fields -> n: Successfully modified n - 3 fields
         */
        "modifyField": 0,
        /* deleteField
         * 2: Cannot delete field because other unhandled issues
         * 3: Successfully deleted the field
         */
        "deleteField": 0,
        /* addCourt
         * 2: Cannot add court because other unhandled issues
         * 3: Successfully added the court
         */
        "addCourt": 0,
        /* modifyCourt
         * 1: Cannot modify court because entered information contains error.
         * 2: Cannot modify court because other unhandled issues
         * 3: Successfully modified the court
         */
        "modifyCourt": 0,
        /* deleteCourt
         * 1: Cannot modify court because entered information contains error.
         * 2: Cannot delete court because other unhandled issues
         * 3: Successfully deleted the court
         */
        "deleteCourt": 0,
        // userByUserIDFetch 1: fetch completed
        "userByUserIDFetch": 0,
        /* cancelReservation
         * 1: Cannot cancel because of handled issues
         * 2: Successfully canceled the reservation
         */
        "cancelReservation": 0,
        // archivedReservationsFetch 1: fetch completed
        "archivedReservationsFetch": 0
        
    ];
    @Published var viewingPage:Int = 1;
    @Published var changedDate: Date = Date(); // This variable is for storing modified date in all date modification views
    @Published var courts: [Court] = [];
    @Published var fields: [Field] = []
    @Published var fieldsManage: [Field] = []; // This variable is only used for editing fields
    @Published var reservations: [Reservation] = []
    @Published var archives: [Archive] = []
    @Published var fetchedUser: User = User(id: 0, username: "", telephone: "");
    @Published var currentDay: Date = DateFormatter.yearMonthDay.date(from: DateFormatter.yearMonthDay.string(from:Date())) ?? Date();
    @Published var PAGES: [Pages] = [
        Pages(id:1,name:"house",desc:"Home"),
        Pages(id:2,name:"sportscourt",desc:"Court"),
        Pages(id:3,name:"calendar",desc:"Calendar"),
        Pages(id:4,name:"person",desc:"Account")
    ]
    func checkLoginStatus(login:Bool) {
        print(UserDefaults.standard.bool(forKey: "loggedIn"))
    }
    func printLanguage(){
        print(Locale.preferredLanguages[0].uppercased())
    }
    func logIn(username:String,password:String) -> Void{
        let usingEmail = NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}").evaluate(with: username)
        
        let parameters: String = "type=LOGIN&email=\(usingEmail)&username=\(username)&password=\(password)"
        let url = URL(string: "https://atlasreserve.ma/index.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = parameters.data(using:.utf8)
        let group = DispatchGroup()
        group.enter()
        var response = "Error"
        self.responses["login"] = 0
        DispatchQueue.global(qos:.default).async {
            self.getResponse(withRequest: request, withCompletion: {detail in response = detail ?? "404";            group.leave()})

        }
        group.notify(queue: DispatchQueue.main) {
            if response == "\"Not Found\"" {
                self.responses["login"] = 1 //"Username or Email not found"
            } else if response == "\"Wrong\"" {
                self.responses["login"] = 2 //"Username (email) or password is incorrect"
            } else {
                // Success
                if let data = response.data(using: .utf8) {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            for (_, value) in json {
                                guard let each = value as? [String:Any] else {
                                    print("Error")
                                    self.responses["login"] = 3
                                    return
                                }
                                self.id = Int(each["id"] as! String)!
                                UserDefaults.standard.set(self.id, forKey: "id")
                                self.isOwner = each["isOwner"] as! String == "1"
                                UserDefaults.standard.set(self.isOwner, forKey: "isOwner")
                                self.username = each["user"] as! String
                                UserDefaults.standard.set(self.username, forKey: "username")
                            }
                        }
                        
                    } catch {
                        print("Error parsing JSON: \(error)")
                    }
                }
                self.responses["login"] = 4
                self.loggedIn = true
                UserDefaults.standard.set(true, forKey: "loggedIn")
            }
        }
    }
    func addAccount(username:String,password:String,email:String) -> Void {
        let parameters: String = "type=ADDACCOUNT&email=\(email)&username=\(username)&password=\(password)"
        let url = URL(string: "https://atlasreserve.ma/index.php")!
        let group = DispatchGroup()
        group.enter()
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = parameters.data(using:.utf8)
        var response = "None";
        self.responses["addAccount"] = 0
        DispatchQueue.global(qos:.default).async {
            self.getResponse(withRequest: request, withCompletion: {
                    detail in response = detail ?? "None";
                print(response);
                    group.leave()
                }
            )

        }
        group.wait()
        self.responses["addAccount"] = Int(response) ?? 2
    }
    func getResponse(withRequest request:URLRequest, withCompletion completion: @escaping (String?) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            if let data = data {
                let responseString:String = String(data:data, encoding:.utf8) ?? "404"
                completion(responseString)
            }
        }
        task.resume()
    }
    func getImage(withRequest request:URLRequest, withCompletion completion: @escaping (UIImage?) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            if let data = data {
                let responseImage:UIImage = UIImage(data:data) ?? UIImage(systemName: "image")!
                completion(responseImage)
            }
        }
        task.resume()
    }
    func getFieldAvailability(withRequest request:URLRequest, withCompletion completion: @escaping (Int?) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            if let data = data {
                let response:Int = Int(String(data:data, encoding:.utf8) ?? "0") ?? 0
                completion(response)
            }
        }
        task.resume()
    }
    func getCourts(clearImageCache: Bool = true) -> Void {
        let url = URL(string: "https://atlasreserve.ma/index.php")!
        var request = URLRequest(url: url)
        let parameters: String = "type=GETCOURTS"
        request.httpMethod = "POST"
        request.httpBody = parameters.data(using:.utf8)
        let group = DispatchGroup()
        group.enter()
        var response = "Error"
        self.responses["courtFetch"] = 0
        self.courts = []
        DispatchQueue.global(qos:.default).async {
            self.getResponse(withRequest: request, withCompletion: {detail in response = detail ?? "404"; group.leave()})
        }
        group.notify(queue: DispatchQueue.main) {
            if let data = response.data(using: .utf8) {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        for (_, value) in json {
                            guard let each = value as? [String:Any] else {
                                print("Error")
                                return
                            }
                            guard let previewImageUrl = URL(string: "https://atlasreserve.ma/courtPrevImg/" + (each["previewImage"] as! String) ) else {
                                print ("Error")
                                return
                            }
                            if clearImageCache {
                                // Clear cache of previewImage
                                ImageCache.default.removeImage(forKey: previewImageUrl.absoluteString)
                            }
                            self.courts.append(
                                Court(
                                    id: Int(each["id"] as! String) ?? 0,
                                    name: each["name"] as! String,
                                    owner: each["owner"] as! String,
                                    address: each["address"] as! String,
                                    telephone: each["telephone"] as! String,
                                    previewImageURL: previewImageUrl,
                                    ownerID: Int(each["ownerID"] as! String) ?? 0 // Useful for court management
                                )
                            )
                            
                        }
                    }
                    
                } catch {
                    print("Error parsing JSON: \(error)")
                }
            }
            self.responses["courtFetch"] = 1;
        }
    }
    func reserve(fieldID: Int, date: Date, type: Int) {
        self.responses["reserve"] = 0
        let url = URL(string: "https://atlasreserve.ma/index.php")!
        var request = URLRequest(url: url)
        let parameters: String = "type=RESERVE&fieldID=\(fieldID)&date=\(DateFormatter.yearMonthDay.string(from: date))&userID=\(self.id)&t=\(type)"
        request.httpMethod = "POST"
        request.httpBody = parameters.data(using:.utf8)
        let group = DispatchGroup()
        group.enter()
        var response = "404"
        DispatchQueue.global(qos:.default).async {
            self.getResponse(withRequest: request, withCompletion: {detail in response = detail ?? "404"; group.leave()})
        }
        group.notify(queue: DispatchQueue.main) {
            if response != "200" {
                self.responses["reserve"] = 2
            } else {
                self.responses["reserve"] = 3
            }
        }
    }
    
    func reserveCourt(fieldID: Int, date: Date) -> Void {
        let group2 = DispatchGroup() // This group is for fetching the reserve status of the court
        self.responses["reserve"] = 0
        let url = URL(string: "https://atlasreserve.ma/index.php")!
        let dateFormatter = DateFormatter.yearMonthDay
        var availableFieldCount = 0
        var availableFieldRequest = URLRequest(url: url)
        let availableFieldParameters: String = "type=GETFIELDAVAILABILITY&date=\(dateFormatter.string(from:date))&fieldID=\(fieldID)&userID=\(self.id)"
        availableFieldRequest.httpMethod = "POST"
        availableFieldRequest.httpBody = availableFieldParameters.data(using:.utf8)
        group2.enter()
        DispatchQueue.global(qos:.default).async {
            self.getFieldAvailability(withRequest: availableFieldRequest) {
                data in
                availableFieldCount = Int(data ?? 0);
                group2.leave()
            }
        }
        group2.notify(queue: DispatchQueue.main) {
            let available = availableFieldCount > 0
            if !available {
                self.responses["reserve"] = 1
            } else {
                self.reserve(fieldID: fieldID, date: date, type: 1) // 1: user reserved
            }
        }
        
    }
    func getFieldsByCourtID(court : Int) -> Void {
        let url = URL(string: "https://atlasreserve.ma/index.php")!
        var request = URLRequest(url: url)
        let parameters: String = "type=GETFIELDBYCOURTID&court=\(court)"
        request.httpMethod = "POST"
        request.httpBody = parameters.data(using:.utf8)
        var currentDay = Calendar.current.component(.weekday, from: Date()) - 2
        if currentDay < 0 { // Sunday would be -1
            currentDay = 6 // while it should be 6
        }
        let group = DispatchGroup()
        group.enter()
        var response = "Error"
        self.fields = []
        self.fieldsManage = []
        self.responses["fieldFetch"] = 0
        DispatchQueue.global(qos:.default).async {
            self.getResponse(withRequest: request, withCompletion: {detail in response = detail ?? "404"; group.leave()})
        }
        group.notify(queue: DispatchQueue.main) {
            if let data = response.data(using: .utf8) {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        for (_, value) in json {
                            guard let each = value as? [String:Any] else {
                                print("Error")
                                return
                            }
                            
                            let fieldAvailability: [Bool] = [
                                each["mon"] as! String == "1",
                                each["tue"] as! String == "1",
                                each["wed"] as! String == "1",
                                each["thu"] as! String == "1",
                                each["fri"] as! String == "1",
                                each["sat"] as! String == "1",
                                each["sun"] as! String == "1"
                            ]
                            if self.isOwner {
                                // Special Field Format for owner field management
                                self.fieldsManage.append(
                                    Field(
                                        id: Int(each["fieldID"] as! String) ?? 0,
                                        type: Int(each["type"] as! String) ?? 0,
                                        startTime: each["startTime"] as! String,
                                        endTime: each["endTime"] as! String,
                                        availability: 0,
                                        count: Int(each["count"] as! String) ?? 1,
                                        availabilityArray: fieldAvailability,
                                        courtID: Int(each["courtID"] as! String) ?? 0
                                    )
                                )
                            }
                            for i in 0...6  {
                                if fieldAvailability[i] {
                                    self.fields.append(Field(
                                        id: Int(each["fieldID"] as! String) ?? 0,
                                        type: Int(each["type"] as! String) ?? 0,
                                        startTime: each["startTime"] as! String,
                                        endTime: each["endTime"] as! String,
                                        availability: i,
                                        count: Int(each["count"] as! String) ?? 1,
                                        courtID: Int(each["courtID"] as! String) ?? 0
                                    ))
                                }
                            }
                            
                            self.fields.sort{(lhs, rhs) -> Bool in
                                // print("comparing " + String(lhs.availability) + " and " + String(rhs.availability))
                                let dayDiff1 =  lhs.availability < currentDay ? lhs.availability + 7 - currentDay : (lhs.availability - currentDay)
                                let dayDiff2 =  rhs.availability < currentDay ? rhs.availability + 7 - currentDay : (lhs.availability - currentDay)
                                if (dayDiff1 != dayDiff2) {
                                    return dayDiff1 < dayDiff2
                                }
                                if (lhs.type == rhs.type) {
                                    return lhs.startTime < rhs.startTime
                                }
                                return lhs.type < rhs.type
                            }
                        }
                    }
                    
                } catch {
                    print("Error parsing JSON: \(error)")
                }
            }
            if self.isOwner {
                self.fieldsManage.sort { lhs, rhs in
                    if lhs.type == rhs.type {
                        return lhs.startTime < rhs.startTime
                    }
                    return lhs.type < rhs.type
                }
            }
            self.responses["fieldFetch"] = 1
        }
    }
    func getReservationsByUserID(userID: Int) -> Void{
        let url = URL(string: "https://atlasreserve.ma/index.php")!
        var request = URLRequest(url: url)
        let parameters: String = "type=GETRESERVATIONSBYUSERID&userID=\(userID)"
        request.httpMethod = "POST"
        request.httpBody = parameters.data(using:.utf8)
        let group = DispatchGroup()
        group.enter()
        var response = "Error"
        self.reservations = []
        self.responses["reservationsByUserIDFetch"] = 0
        DispatchQueue.global(qos:.default).async {
            self.getResponse(withRequest: request, withCompletion: {detail in response = detail ?? "404"; group.leave()})
        }
        group.notify(queue: DispatchQueue.main) {
            if let data = response.data(using: .utf8) {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        for (_, value) in json {
                            guard let each = value as? [String:Any] else {
                                print("Error")
                                return
                            }
                            self.reservations.append(
                                Reservation(
                                    id: Int(each["resID"] as! String) ?? 0,
                                    field: Int(each["fieldID"] as! String) ?? 0,
                                    date: each["date"] as! String,
                                    courtID: Int(each["courtID"] as! String) ?? 0,
                                    resType: Int(each["type"] as! String) ?? 0,
                                    startTime: each["startTime"] as! String,
                                    endTime: each["endTime"] as! String
                                )
                            )
                            self.reservations.sort{(lhs, rhs) -> Bool in
                                if lhs.date == rhs.date {
                                    return lhs.startTime < rhs.startTime
                                }
                                return lhs.date < rhs.date
                            }
                            
                        }
                    }
                    
                } catch {
                    print("Error parsing JSON: \(error)")
                }
            }
            self.responses["reservationsByUserIDFetch"] = 1;
        }
    }
    func getReservationsByCourtID(courtID: Int) -> Void{
        let url = URL(string: "https://atlasreserve.ma/index.php")!
        var request = URLRequest(url: url)
        let parameters: String = "type=GETRESERVATIONSBYCOURTID&id=\(courtID)"
        request.httpMethod = "POST"
        request.httpBody = parameters.data(using:.utf8)
        let group = DispatchGroup()
        group.enter()
        var response = "Error"
        self.reservations = []
        self.responses["reservationsByCourtIDFetch"] = 0
        DispatchQueue.global(qos:.default).async {
            self.getResponse(withRequest: request, withCompletion: {detail in response = detail ?? "404"; group.leave()})
        }
        group.notify(queue: DispatchQueue.main) {
            if let data = response.data(using: .utf8) {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        for (_, value) in json {
                            guard let each = value as? [String:Any] else {
                                print("Error")
                                return
                            }
                            self.reservations.append(
                                Reservation(
                                    id: Int(each["resID"] as! String) ?? 0,
                                    field: Int(each["fieldID"] as! String) ?? 0,
                                    date: each["date"] as! String,
                                    resType: Int(each["type"] as! String) ?? 0,
                                    startTime: each["startTime"] as! String,
                                    endTime: each["endTime"] as! String,
                                    userID: Int(each["userID"] as! String) ?? 0
                                )
                            )
                            
                            self.reservations.sort{(lhs, rhs) -> Bool in
                                return lhs.startTime < rhs.startTime
                            }
                            
                        }
                    }
                    
                } catch {
                    print("Error parsing JSON: \(error)")
                }
            }
            self.responses["reservationsByCourtIDFetch"] = 1;
        }
    }
    func addField(courtID: Int, type: Int, startTime: Date, endTime: Date, count: Int, availability: [Bool]) -> Void {
        self.responses["addField"] = 0
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        if startTime >= endTime || availability.count != 7 || type > FieldType.maxType {
            self.responses["addField"] = 1 // Error because wrong input
            return
        }
        var parameters: String = "type=ADDFIELD&t=\(type)&startTime=\(timeFormatter.string(from: startTime))&endTime=\(timeFormatter.string(from: endTime))&courtID=\(courtID)&count=\(count)"
        parameters += "&mon=\(availability[0] ? 1 : 0)"
        parameters += "&tue=\(availability[1] ? 1 : 0)"
        parameters += "&wed=\(availability[2] ? 1 : 0)"
        parameters += "&thu=\(availability[3] ? 1 : 0)"
        parameters += "&fri=\(availability[4] ? 1 : 0)"
        parameters += "&sat=\(availability[5] ? 1 : 0)"
        parameters += "&sun=\(availability[6] ? 1 : 0)"
        // print(parameters)
        let url = URL(string: "https://atlasreserve.ma/index.php")!
        let group = DispatchGroup()
        group.enter()
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = parameters.data(using:.utf8)
        var response = "404";
        DispatchQueue.global(qos:.default).async {
            self.getResponse(withRequest: request, withCompletion: {
                    detail in response = detail ?? "404";
                    group.leave()
                }
            )

        }
        group.notify(queue: DispatchQueue.main) {
            if (response == "\"Success\"") {
                self.responses["addField"] = 3
            } else {
                self.responses["addField"] = 2
                print(response)
            }
        }
    }
    func modifyFields(fields: [Field]) -> Void {
        let count = fields.count
        self.responses["modifyField"] = 0
        for i in fields {
            if self.responses["modifyField"] == 1 || self.responses["modifyField"] == 2 {
                break
            }
            modifyField(field: i, count: count)
        }
    }
    func modifyField(field: Field, count: Int) -> Void {
        if self.responses["modifyField"] == 2 || self.responses["modifyField"] == 1 {
            return
        }
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        if field.startTime >= field.endTime || field.availabilityArray.count != 7 || field.type > FieldType.maxType {
            self.responses["addField"] = 1 // Error because wrong input
            return
        }
        var parameters: String = "type=MODIFYFIELD&t=\(field.type)&startTime=\(timeFormatter.string(from:field.startTime))&endTime=\(timeFormatter.string(from: field.endTime))&courtID=\(field.courtID)&count=\(field.count)&id=\(field.id)"
        parameters += "&mon=\(field.availabilityArray[0] ? 1 : 0)"
        parameters += "&tue=\(field.availabilityArray[1] ? 1 : 0)"
        parameters += "&wed=\(field.availabilityArray[2] ? 1 : 0)"
        parameters += "&thu=\(field.availabilityArray[3] ? 1 : 0)"
        parameters += "&fri=\(field.availabilityArray[4] ? 1 : 0)"
        parameters += "&sat=\(field.availabilityArray[5] ? 1 : 0)"
        parameters += "&sun=\(field.availabilityArray[6] ? 1 : 0)"
        // print(parameters)
        let url = URL(string: "https://atlasreserve.ma/index.php")!
        let group = DispatchGroup()
        group.enter()
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = parameters.data(using:.utf8)
        var response = "404";
        DispatchQueue.global(qos:.default).async {
            self.getResponse(withRequest: request, withCompletion: {
                    detail in response = detail ?? "404";
                    group.leave()
                }
            )

        }
        group.notify(queue: DispatchQueue.main) {
            if (response == "\"Success\"") {
                if self.responses["modifyField"] == 0 {
                    self.responses["modifyField"] = count == 1 ? 3 : 4
                } else if self.responses["modifyField"] == 4 + count - 2 {
                    self.responses["modifyField"] = 3
                } else {
                    self.responses["modifyField"]! += 1
                }
            } else {
                self.responses["modifyField"] = 2
                print(response)
            }
        }
    }
    func deleteField(fieldID: Int) -> Void {
        let parameters: String = "type=DELETEFIELD&id=\(fieldID)"
        self.responses["deleteField"] = 0
        // print(parameters)
        let url = URL(string: "https://atlasreserve.ma/index.php")!
        let group = DispatchGroup()
        group.enter()
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = parameters.data(using:.utf8)
        var response = "404";
        DispatchQueue.global(qos:.default).async {
            self.getResponse(withRequest: request, withCompletion: {
                    detail in response = detail ?? "404";
                    group.leave()
                }
            )
        }
        group.notify(queue: DispatchQueue.main) {
            if (response == "\"Success\"") {
                self.responses["deleteField"] = 3
                self.responses["fieldFetch"] = 0
            } else {
                self.responses["deleteField"] = 2
                print(response)
            }
        }
    }
    func addCourt(name: String, owner: String, address: String, number: String, image: UIImage) -> Void {
        self.responses["addCourt"] = 0
        let imageData = image.compress(to: 800)
        
        // let parameters: String = "type=ADDCOURT&name=\(name)&owner=\(owner)&address=\(address)&number=\(number)&image=\(imageData)&id=\(self.id)"
        let url = URL(string: "https://atlasreserve.ma/index.php")!
        let group = DispatchGroup()
        group.enter()
        var request = URLRequest(url: url)
        
        request.setValue("multipart/form-data; boundary=XXX", forHTTPHeaderField: "Content-Type")
        var body = Data()
        let boundary = "XXX"
        let params: [String: Any] = [
            "type": "ADDCOURT",
            "name": name,
            "owner": owner,
            "address": address,
            "number": number,
            "id": "\(self.id)",
            "imageUUID": UUID()
        ]

        for (key, value) in params {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.append("\(value)\r\n")
        }

        // Add image data
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n")
        body.append("Content-Type: image/jpg\r\n\r\n")
        body.append(imageData)
        body.append("\r\n")
        body.append("--\(boundary)--\r\n")

        request.httpMethod = "POST"
        request.httpBody = body
        var response = "404";
        DispatchQueue.global(qos:.default).async {
            self.getResponse(withRequest: request, withCompletion: {
                    detail in response = detail ?? "404";
                    group.leave()
                }
            )

        }
        group.notify(queue: DispatchQueue.main) {
            if (response == "\"Success\"") {
                self.responses["addCourt"] = 3
            } else {
                self.responses["addCourt"] = 2
                print(response)
            }
        }
    }
    func modifyCourt(court: Court, changedImage: Bool) -> Void {
        self.responses["modifyCourt"] = 0
        let imageData = court.previewImage.compress(to: 800)
        
        // let parameters: String = "type=ADDCOURT&name=\(name)&owner=\(owner)&address=\(address)&number=\(number)&image=\(imageData)&id=\(self.id)"
        let url = URL(string: "https://atlasreserve.ma/index.php")!
        let group = DispatchGroup()
        group.enter()
        var request = URLRequest(url: url)
        
        request.setValue("multipart/form-data; boundary=XXX", forHTTPHeaderField: "Content-Type")
        var body = Data()
        let boundary = "XXX"
        let params: [String: Any] = [
            "type": "MODIFYCOURT",
            "name": court.name,
            "owner": court.owner,
            "address": court.address,
            "number": court.telephone,
            "id": court.id,
            "changedImage": changedImage
        ]
        for (key, value) in params {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.append("\(value)\r\n")
        }
        
        if changedImage {
            // Add image data
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n")
            body.append("Content-Type: image/jpg\r\n\r\n")
            body.append(imageData)
            body.append("\r\n")
        }
        body.append("--\(boundary)--\r\n")
        request.httpMethod = "POST"
        request.httpBody = body
        var response = "404";
        DispatchQueue.global(qos:.default).async {
            self.getResponse(withRequest: request, withCompletion: {
                    detail in response = detail ?? "404";
                    group.leave()
                }
            )

        }
        group.notify(queue: DispatchQueue.main) {
            if (response == "\"Success\"") {
                self.responses["modifyCourt"] = 3
                
            } else {
                self.responses["modifyCourt"] = 2
                print(response)
            }
        }
    }
    func deleteCourt(courtID: Int) -> Void {
        self.responses["deleteCourt"] = 0
        let parameters: String = "type=DELETECOURT&id=\(courtID)"
        let url = URL(string: "https://atlasreserve.ma/index.php")!
        let group = DispatchGroup()
        group.enter()
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = parameters.data(using:.utf8)
        var response = "404";
        DispatchQueue.global(qos:.default).async {
            self.getResponse(withRequest: request, withCompletion: {
                    detail in response = detail ?? "404";
                    group.leave()
                }
            )
        }
        group.notify(queue: DispatchQueue.main) {
            if (response == "\"Success\"") {
                self.responses["deleteCourt"] = 3
            } else {
                self.responses["deleteCourt"] = 2
                print(response)
            }
        }
    }
    func getUserByUserID(userID: Int) -> Void{
        let url = URL(string: "https://atlasreserve.ma/index.php")!
        var request = URLRequest(url: url)
        let parameters: String = "type=GETUSERBYUSERID&id=\(userID)"
        request.httpMethod = "POST"
        request.httpBody = parameters.data(using:.utf8)
        let group = DispatchGroup()
        group.enter()
        var response = "Error"
        DispatchQueue.global(qos:.default).async {
            self.getResponse(withRequest: request, withCompletion: {detail in response = detail ?? "404"; group.leave()})
        }
        group.notify(queue: DispatchQueue.main) {
            if let data = response.data(using: .utf8) {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        for (_, value) in json {
                            guard let each = value as? [String:Any] else {
                                print("Error")
                                return
                            }
                            self.fetchedUser = User(
                                    id: Int(each["id"] as! String) ?? 0,
                                    username: each["user"] as! String,
                                    telephone: each["telephone"] as! String
                                )
                        }
                    }
                    
                } catch {
                    print("Error parsing JSON: \(error)")
                }
            }
            self.responses["userByUserIDFetch"] = 1;
        }
    }
    func cancelReservation(resID: Int, courtID: Int, userID: Int, reason: String, by: Int, resType: Int, date: Date, fieldID: Int) -> Void {
        // @param by -> either the court(3) or the user(2)
        let formattedDate = DateFormatter.yearMonthDay.string(from: date)
        self.responses["cancelReservation"] = 0
        let parameters: String = "type=CANCELRESERVATION&userID=\(userID)&courtID=\(courtID)&resID=\(resID)&reason=\(reason)&by=\(by)&date=\(formattedDate)&resType=\(resType)&fieldID=\(fieldID)"
        let url = URL(string: "https://atlasreserve.ma/index.php")!
        let group = DispatchGroup()
        group.enter()
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = parameters.data(using:.utf8)
        var response = "404";
        DispatchQueue.global(qos:.default).async {
            self.getResponse(withRequest: request, withCompletion: {
                    detail in response = detail ?? "404";
                    group.leave()
                }
            )
        }
        group.notify(queue: DispatchQueue.main) {
            if (response == "\"Success\"") {
                self.responses["cancelReservation"] = 2
            } else {
                self.responses["cancelReservation"] = 1
                print(response)
            }
        }
    }
    func getArchivedReservations(isCourtOwner: Bool, id: Int) -> Void {
        let url = URL(string: "https://atlasreserve.ma/index.php")!
        var request = URLRequest(url: url)
        let by = isCourtOwner ? 1 : 0
        let parameters: String = "type=GETARCHIVEDRESERVATIONS&isCourtOwner=\(by)&id=\(id)"
        request.httpMethod = "POST"
        request.httpBody = parameters.data(using:.utf8)
        let group = DispatchGroup()
        group.enter()
        var response = "Error"
        self.archives = []
        self.responses["archivedReservationsFetch"] = 0
        DispatchQueue.global(qos:.default).async {
            self.getResponse(withRequest: request, withCompletion: {detail in response = detail ?? "404"; group.leave()})
        }
        group.notify(queue: DispatchQueue.main) {
            if let data = response.data(using: .utf8) {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        for (_, value) in json {
                            guard let each = value as? [String:Any] else {
                                print("Error")
                                return
                            }
                            self.archives.append(
                                Archive(
                                    resID: Int(each["resID"] as! String) ?? 0,
                                    userID: Int(each["userID"] as! String) ?? 0,
                                    courtID: Int(each["courtID"] as! String) ?? 0,
                                    fieldID: Int(each["fieldID"] as! String) ?? 0,
                                    date: each["date"] as! String,
                                    state: Int(each["state"] as! String) ?? 0,
                                    reason: each["reason"] as! String
                                )
                            )
                            
                            self.archives.sort{(lhs, rhs) -> Bool in
                                return lhs.date > rhs.date
                            }
                            
                        }
                    }
                    
                } catch {
                    print("Error parsing JSON: \(error)")
                }
            }
            self.responses["archivedReservationsFetch"] = 1;
        }
    }
}
extension Data {
    // Source : https://stackoverflow.com/questions/26162616/upload-image-with-parameters-in-swift/26163136#26163136
    /// Append string to Data
    ///
    /// Rather than littering my code with calls to `data(using: .utf8)` to convert `String` values to `Data`, this wraps it in a nice convenient little extension to Data. This defaults to converting using UTF-8.
    ///
    /// - parameter string:       The string to be added to the `Data`.
    
    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            append(data)
        }
    }
}
extension UIImage {
    // Source: https://stackoverflow.com/a/63270234
    func resized(withPercentage percentage: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }

    func compress(to kb: Int, allowedMargin: CGFloat = 0.2) -> Data {
        let bytes = kb * 1024
        var compression: CGFloat = 1.0
        let step: CGFloat = 0.05
        var holderImage = self
        var complete = false
        while(!complete) {
            if let data = holderImage.jpegData(compressionQuality: 1.0) {
                let ratio = data.count / bytes
                if data.count < Int(CGFloat(bytes) * (1 + allowedMargin)) {
                    complete = true
                    return data
                } else {
                    let multiplier:CGFloat = CGFloat((ratio / 5) + 1)
                    compression -= (step * multiplier)
                }
            }
            
            guard let newImage = holderImage.resized(withPercentage: compression) else { break }
            holderImage = newImage
        }
        return Data()
    }
}

