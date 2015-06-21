class Getter{
    var UserData: [String: String] = ["Username":"",
        "Profile Pic":"default.png",
        "Followers":"1",
        "Following":"2",
        "Glimps":"3"]

    func ProfileDetails(){
        DataManager.getJson{(Data) -> Void in
            let json = JSON(data: Data)
            self.UserData["Username"] = toString((json[0]["username"]))
            }
    }
}
