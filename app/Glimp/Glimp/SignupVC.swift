//
//  SignupVC.swift
//  SwiftLoginScreen
//
//  Created by Dipin Krishna on 31/07/14.
//  Copyright (c) 2014 Dipin Krishna. All rights reserved.
//
import MediaPlayer
import UIKit
func isValidEmail(testStr : String) -> Bool {
    print("validate calendar: \(testStr)")
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    
    if emailTest.evaluateWithObject(testStr) {
        return true
    }
    return false
}

class SignupVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var txtUsername : UITextField!
    @IBOutlet var txtPassword : UITextField!
    @IBOutlet var txtConfirmPassword : UITextField!
    @IBOutlet var txtEmail : UITextField!
    @IBOutlet var txtPhonenumber : UITextField!
    
    
    @IBOutlet var privacypolicy: UIButton!
    
    @IBOutlet var termsofuse: UIButton!
    @IBAction func privacypolicy(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "http://www.glimpnow.com/#!privacy/c3hw")!)
        
    }
    
    @IBAction func termsofuse(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "http://www.glimpnow.com/#!terms/c23bu")!)
        
    }

    
    var moviePlayer: MPMoviePlayerController!
    var nouser = ["69","666","1cup","2girls","2girls1cup","4r5e","5h1t","abortion","ahole","aids","anal","anal sex","analsex","angrydragon","angrydragons","angrypenguin","angrypenguins","angrypirate","angrypirates","anus","apeshit","ar5e","arrse","arse","arsehole","artard","askhole","ass","ass 2 ass","ass hole","ass kisser","ass licker","ass lover","ass man","ass master","ass pirate","ass rapage","ass rape","ass raper","ass to ass","ass wipe","assbag","assbandit","assbanger","assberger","assburger","assclown","asscock","asses","assface","assfuck","assfucker","assfukker","asshat","asshead","asshole","asshopper","assjacker","asslicker","assmunch","asswhole","asswipe","aunt flo","b000bs","b00bs","b17ch","b1tch","bag","ballbag","ballsack","bampot","bang","bastard","basterd","bastich","bean count","beaner","beastial","beastiality","beat it","beat off","beaver","beavers","beeyotch","betch","beyotch","bfe","bi sexual","bi sexuals","biatch","bigmuffpi","biotch","bisexual","bisexuality","bisexuals","bitch","bitched","bitches","bitchin","bitching","bizatch","blackie","blackies","block","bloody hell","blow","blow job","blow wad","blowjob","boff","boffing","boffs","boink","boinking","boinks","boiolas","bollick","bollock","bondage","boner","boners","bong","boob","boobies","boobs","booty","boy2boy","boy4boy","boyforboy","boyonboy","boys2boys","boys4boys","boysforboys","boysonboys","boytoboy","brothel","brothels","brotherfucker","buceta","bugger","bugger ","buggered","buggery","bukake","bullshit","bumblefuck","bumfuck","bung","bunghole","bush","bushpig","but","but plug","butplug","butsecks","butsekks","butseks","butsex","butt","buttfuck","buttfucka","buttfucker","butthole","buttmuch","buttmunch","buttplug","buttsecks","buttsekks","buttseks","buttsex","buttweed","c0ck","c0cksucker","cabron","camel toe","camel toes","cameltoe","canabis","cannabis","carpet muncher","castrate","castrates","castration","cawk","chank","cheesedick","chick2chick","chick4chick","chickforchick","chickonchick","chicks2chicks","chicks4chicks","chicksforchicks","chicksonchicks","chickstochicks","chicktochick","chinc","chink","chinks","choad","choads","chode","cipa","circlejerk","circlejerks","cl1t","cleavelandsteemer","cleveland","clevelandsteamer","clevelandsteemer","clit","clitoris","clitoris     ","clits","clusterfuck","cock","cock block","cock suck","cockblock","cockface","cockfucker","cockfucklutated","cockhead","cockmaster","cockmunch","cockmuncher","cockpenis","cockring","cocks","cocksuck","cocksucker","cocksuka","cocksukka","cok","cokmuncher","coksucka","comestain","condom","condoms","coochie","coon","coons","cooter","copulated","copulates","copulating","copulation","corn","corn_hole","cornhole","cornholes","cr4p","crap","crapping","craps","cream","creampie","crotch","crotches","cum","cumming","cums","cumshot","cumstain","cumtart","cunnilingus","cunt","cuntbag","cunthole","cuntilingis","cuntilingus","cunts","cuntulingis","cuntulingus","d1ck","dabitch","dago","dammit","damn","damned","dance","darkie","darkies","darky","deep","deepthroat","defecate","defecates","defecating","defecation","deggo","diaf","diarea","diarhea","diarrhea","dick","dickhead","dickhole","dickring","dicks","dicksucker","dicksuckers","dicksucking","dicksucks","dickwad","dickweed","dickwod","dik","dike","dikes","dildo","dildoe","dildoes","dildos","dilligaf","dingleberry","dipshit","dirsa","dlck","dog","doggin","doggystyle","dogshit","domination","dominatrix","donkey","donkeyribber","dook","doosh","dork","dorks","douche","douchebag","douchebags","douchejob","douchejobs","douches","douchewaffle","duche","dumass","dumb","dumb fuck","dumbass","dumbfuc","dumbfuck","dumbshit","dumdfuk","dumfuck","dumshit","dyke","dykes","ead","eat me","ejaculat","ejaculate","ejaculated","ejaculates","ejaculation","ejakulat","ejakulate","enema","enemas","enima","enimas","epeen","epenis","erect","erection","erekshun","erotic","eroticism","f0x0r","f0xx0r","fack","facker","facking","fag","fagbag","faggit","faggitt","faggot","faggots","faghag","fags","fagtard","fannyflaps","fannyfucker","fart","farting","farts","fatass","fck","fcker","fckers","fcking","fcks","fcuk","fcuker","fcuking","feck","fecker","felch","felched","felcher","felches","felching","fellate","fellatio","feltch","feltched","feltcher","feltches","feltching","fetish","fetishes","finger","fingering","fisting","flog","flogging","flogs","fook","fooker","foreskin","forked","fornicate","fornicates","fornicating","fornication","frigging","frottage","fubar","fuck","fucka","fuckas","fuckass","fucked","fuckedup","fucker","fuckers","fuckface","fuckfaces","fuckhead","fuckhole","fuckhouse","fuckin","fucking","fuckingshitmotherfucker","fucknugget","fucks","fucktard","fuckwad","fuckwhit","fuckwit","fuckyou","fucndork","fudgepacker","fudgepacking","fugly","fuk","fuken","fuker","fukker","fukkin","fukwhit","fukwit","fuq","fuqed","fuqing","fuqs","fux","fux0r","fuxx0r","gang bang","gangbang","gangbanger","gangbangers","gangbanging","gangbangs","ganja","gay","gaydar","gays","gaytard","gaywad","genital","genitalia","genitals","gerbiling","ghey","girl2girl","girl4girl","girlforgirl","girlongirl","girls2girls","girls4girls","girlsforgirls","girlsongirls","girlstogirls","girltogirl","gloryhole","goatse","gobshit","gobshite","gobtheknob","goddam","goddammit","goddamn","goddamned","goddamnit","gooch","gook","gooks","groe","gspot","gtfo","gubb","gummer","guppy","guy2guy","guy4guy","guyforguy","guyonguy","guys2guys","guys4guys","guysforguys","guysonguys","guystoguys","guytoguy","gyfs","hair pie","hairpie","hairpies","hairy bush","hand","handjob","harbl","hard on","hardon","hardons","hell","hentai","heroin","herpes","herps","hick","hiv","ho","hoare","hoe","hoebag","hoer","hoes","hole","homo","homos","homosexual","homosexuality","homosexuals","honkee","honkey","honkie","honkies","honky","hoochie","hooker","hookers","hore","horney","hornie","horny","horseshit","hosebeast","hot","hotcarl","hotkarl","hummer","hump","humping","humps","hymen","i like ass","i love ass","i love tit","i love tits","iluvsnatch","incest","ip freely","itard","jack","jack off","jackass","jackingoff","jackoff","jap","japs","jerk off","jerkoff","jesusfreak","jewbag","jewboy","jiga","jigaboo","jigga","jiggaboo","jis","jism","jiz","jizm","jizz","job","junglebunny","jysm","kawk","khunt","kike","kikes","kinky","kkk","klit","knob","knobjocky","knobjokey","knockers","kooch","koolie","koolielicker","koolies","kootch","kukluxklan","kunt","kyke","l3itch","labia","lap","lapdance","lelo","lemonparty","lesbian","lesbians","lesbifriends","lesbo","lesbos","leyed","lez","lezzie","lichercunt","lick ass","lick myass","lick tit","lickbeaver","lickcarpet","lickdick","lickherass","lickherpie","lickmy ass","lickpussy","like ass","like tit","limpdick","lingerie","llello","lleyed","loltard","love ass","love juice","love tit","lovehole","lsd","lucifer","lumpkin","m0f0","m0fo","m45terbate","ma5terb8","ma5terbate","mack","mammaries","man2man","man4man","mandingo","manforman","mangina","manonman","mantoman","marijuana","masochism","masochist","master","masterb8","masterbat3","masterbate","masterbates","masterbating","masterbation","masterbations","masturbate","masturbates","masturbating","masturbation","meatcurtain","men2men","men4men","menformen","menonmen","mentomen","milf","minge","mistress","mof0","mofo","motha","motherfuck","motherfucka","motherfuckas","motherfucked","motherfucker","motherfuckers","motherfucking","motherfuckka","muff","muff diver","muffdiver","muffdiving","munch","mung","mutha","muther","muzza","my ass","n1gga","n1gger","naked","nambla","nards","nazi","nazies","nazis","necrophile","necrophiles","necrophilia","necrophiliac","negro","neonazi","nice ass","nig","nigg3r","nigg4h","nigga","niggah","niggas","niggaz","nigger","niggers","nigglet","niglet","nippies","nipple","nips","nobhead","nobjockey","nobjocky","nobjokey","nookey","nookie","noshit","nude","nudes","nudity","numbnuts","nut bag","nut lick","nut lover","nut sack","nut suck","nutnyamouth","nutnyomouth","nuts","nutsack","nutstains","nymph","nympho","nymphomania","nymphomaniac","nymphomaniacs","nymphos","oral","orgasm","orgasmic","orgasms","orgi","orgiastic","orgies","orgy","paedophile","panooch","panties","panty","patootie","pecker","peckerhead","peckers","pedophile","pedophiles","pedophilia","peepshow","peepshows","pen15","penii","penis","penises","penisfucker","perve","perversion","pervert","perverted","perverts","phat","phile","philes","philia","phuck","phucker","phuckers","phucking","phucks","phuk","phuker","phukers","phuking","phuks","phuq","phuqer","phuqers","phuqing","phuqs","pie","pigfucker","pimpis","piss","pissant","pissed","pisser","pisses","pissfart","pissflaps","pissing","pocket","poke","poon","poon eater","poon tang","poonani","poonanny","poonany","poonj","poonjab","poonjabie","poonjaby","poontang","poop","poopchute","poot","porchmonkey","porking","porks","porn","porno","prick","pricks","prostitot","pube","pubes","pubic","pud","pudd","puds","punani","punanni","punanny","punta","puntang","pusse","pussi","pussies","pussy","puta","puto","qeef","qfmft","qq more","quafe","quap","quatch","queef","queefe","queefed","queefing","queer","queerbait","queermo","queers","queev","quefe","queif","quief","quif","quiff","quim","quim nuts","qweef","racial","racism","racist","racists","rape","raped","raper","raping","rapist","redtide","reefer","renob","retard","ricockulous","rim job","rimjaw","rimjob","rimjobs","rimming","roofie","rtard","rtfm","rubbers","rump","rumpranger","rumprider","rumps","rustytrombone","sadism","sadist","sadomasochism","sand nigger","sandnigga","sandniggas","sandnigger","sandniggers","sapphic","sappho","sapphos","satan","scatological","scheiss","scheisse","schlong","schlonging","schlongs","schtup","schtupp","schtupping","schtups","screw","screw me","screw this","screw you","screwed","screwer","screwing","screws","screwyou","scroat","scrog","scrote","scrotum","secks","sekks","seks","semen","sex","sexed","sexking","sexkitten","sexmachine","sexqueen","sexual","sexuality","sexy","sexybitch","sexybitches","sh1t","shag","shagger","shaggin","shagging","shart","shemale","shit","shitdick","shite","shited","shitey","shitface","shitfaced","shitfuck","shithead","shitlist","shits","shitt","shitted","shitter","shittiest","shitting","shitts","shitty","shiznits","shotacon","shotakon","shyte","sickass","sixtynine","sixtynining","skank","skeet","sketell","sko","skrew","skrewing","skrews","slant eye","slanteyes","slattern","slave","slaves","slopehead","slopeheads","slut","slutbag","slutpuppy","sluts","slutty","slutwhore","smegma","smut","snatch","snatches","soddom","sodom","sodomist","sodomists","sodomize","sodomized","sodomizing","sodomy","sonnofabitch","sonnovabitch","sonnuvabitch","sonofabitch","spank","spanked","spanking","spanks","spearchucker","spearchuckers","sperm","spermicidal","spermjuice","sphincter","spic","spick","spicks","spics","spik","spiks","spooge","stank ho","stankpuss","steamer","stfu","stiffie","stiffy","stud","studs","submissive","submissives","suck","suck ass","sucks ass","swinger","swingers","t1tt1e5","t1tties","take a dump","takeadump","tar baby","tarbaby","tard","teabaggin","teabagging","teen2teen","teen4teen","teenforteen","teenonteen","teens2teens","teens4teens","teensforteens","teensonteens","teenstoteens","teentoteen","teets","teez","testes","testical","testicals","testicle","testicles","threesome","throat","thundercunt","tiddie","tiddy","tit","titandass","titbabe","titball","titfuck","tits","titsandass","titt","tittie","tittie5","tittiefucker","titties","titts","titty","tittyfuck","tittywank","titwank","toke","toss salad","tramp","tramps","tranny","transexual","transexuals","transvestite","transvestites","tubgirl","turd","tw4t","twat","twathead","twatlips","twats","twatty","twunt","twunter","ufia","umfriend","underwear","up yours","upyours","upyourz","urinate","urinated","urinates","urinating","urination","urine","vaffanculo","vag","vagina","vaginal","vaginas","vaginer","vagitarian","vagoo","vagy","vajayjay","viagra","vibrator","virgin","virginity","virgins","voyeur","voyeurism","voyeurs","vulva","w00se","wackedoff","wackoff","wad blower","wad lover","wad sucker","wadblower","wadlover","wadsucker","waffle","wang","wank","wanker","wanky","wetback","wetbacks","wetdream","wetdreams","whackedoff","whackoff","whigger","whip","whipped","whipping","whips","whiz","whoe","whore","whored","whorehouse","whores","whoring","wigger","willies","wog","wogged","woggy","wogs","woman2woman","woman4woman","womanforwoman","womanonwoman","womantowoman","women2women","women4women","womenforwomen","womenonwomen","womentowomen","woof","wop","xx","xxx","yank","yayo","yeat","yeet","yeyo","yiff","yiffy","yola","yols","yoni","youaregay","yourgay","zipperhead","zipperheads","zorch","admin","glimp","moderator","password","username"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtUsername.delegate = self;
        self.txtPassword.delegate = self;
        self.txtConfirmPassword.delegate = self;
        self.txtEmail.delegate = self;
        self.txtPhonenumber.delegate = self;

        // Do any additional setup after loading the view.
    }
    

    func textFieldDidBeginEditing(textField: UITextField) {    //delegate method
        if (textField == self.txtUsername) {
            self.txtUsername.text = "";
        }
        else if (textField == self.txtPassword){
            self.txtPassword.text = "";
        }
        else if (textField == self.txtConfirmPassword){
            self.txtConfirmPassword.text = "";
        }

        else if (textField == self.txtEmail){
            self.txtEmail.text = "";
        }

        else if (textField == self.txtPhonenumber){
            self.txtPhonenumber.text = "";
        }
    }

    
    func loopVideo() {
        self.moviePlayer.play()
    }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    func isNumeric(a: String) -> Bool {
        if (Int(a) != nil) {
            return true
        } else {
            return false
        }
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    

    
//    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
//        self.view.endEditing(true);
//    }
    
    
 //   override func textFieldDidBeginEditing:(UITextField *); textField {
    
//    if (textField == self.numberToAdd) {
//    self.numberToAdd1.text = @"";
//    }
//    }


    override func viewWillAppear(animated: Bool) {
        let videoURL: NSURL = NSBundle.mainBundle().URLForResource("video", withExtension: "mov")!
        //var fileURL = NSURL.fileURLWithPath("http://localhost/test/xx.mp4")
        
        // Create and configure the movie player.
        self.moviePlayer = MPMoviePlayerController(contentURL: videoURL)
        
        self.moviePlayer.controlStyle = MPMovieControlStyle.None
        self.moviePlayer.scalingMode = MPMovieScalingMode.AspectFill
        
        self.moviePlayer.view.frame = self.view.frame
        self.view .insertSubview(self.moviePlayer.view, atIndex: 0)
        
        self.moviePlayer.play()
        
        // Loop video.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loopVideo", name: MPMoviePlayerPlaybackDidFinishNotification, object: self.moviePlayer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /*
    // #pragma mark - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func gotoLogin(sender : UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

    @IBAction func signupTapped(sender : UIButton) {
        let username:NSString = txtUsername.text! as NSString
        let password:NSString = txtPassword.text! as NSString
        let confirm_password:NSString = txtConfirmPassword.text! as NSString
        let email:NSString = txtEmail.text! as NSString
        let phonenumber:NSString = txtPhonenumber.text! as NSString
        let counter = password.length    // returns 5 (Int)
        let veri = username as String
        let verifier = veri.characters.count
        
        if ( username.isEqualToString("") || password.isEqualToString("") || email.isEqualToString("") || phonenumber.isEqualToString("")) {
            
            let alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign Up Failed!"
            alertView.message = "Please enter Username and Password"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
            
            
        } else if ( !password.isEqual(confirm_password)) {
            
            let alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign Up Failed!"
            alertView.message = "Passwords doesn't Match"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        } else if (( nouser.indexOf((username as String))) != nil) {
            
            let alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign Up Failed!"
            alertView.message = "Username not allowed"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        } else if ( counter < 5){
            let alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign Up Failed!"
            alertView.message = "Username should be more than 5 characters"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()

        } else if ( verifier <= 6){
            let alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign Up Failed!"
            alertView.message = "Passwords should be more than or equal to 6 characters"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        }
        else if ( isNumeric(phonenumber as String) == false ){
            let alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign Up Failed!"
            alertView.message = "Phone Number is not a digit"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        }
        else if ( isValidEmail(email as String) == false ){
            let alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign Up Failed!"
            alertView.message = "Not a valid email"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        }

        else {
            let secid = "yMPxQSTXpUC7gB8uK4h9v9fUeYNsPjnPzw4dcR3y"
            let post:NSString = "username=\(username)&password=\(password)&c_password=\(confirm_password)&email=\(email)&phonenumber=\(phonenumber)&secid=\(secid)"
            
            NSLog("PostData: %@",post);
            
            let url:NSURL = NSURL(string: "http://glimpglobe.com/v2/jsonsignup.php")!
            
            let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
            
            let postLength:NSString = String( postData.length )
            
            let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.HTTPBody = postData
            request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            
            var reponseError: NSError?
            var response: NSURLResponse?
            
            var urlData: NSData?
            do {
                urlData = try NSURLConnection.sendSynchronousRequest(request, returningResponse:&response)
            } catch let error as NSError {
                reponseError = error
                urlData = nil
            }
            
            if ( urlData != nil ) {
                let res = response as! NSHTTPURLResponse!;
                
                NSLog("Response code: %ld", res.statusCode);
                
                if (res.statusCode >= 200 && res.statusCode < 300)
                {
                    let responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
                    
                    NSLog("Response ==> %@", responseData);
                    
                    
                    let jsonData:NSDictionary = (try! NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers )) as! NSDictionary
                    
                    
                    let success:NSInteger = jsonData.valueForKey("success") as! NSInteger
                    
                    //[jsonData[@"success"] integerValue];
                    
                    NSLog("Success: %ld", success);
                    
                    if(success == 1)
                    {
                        let alertView:UIAlertView = UIAlertView()
                        alertView.title = "Registered!"
                        alertView.message = "Sign up was successful, Login Now!"
                        alertView.delegate = self
                        alertView.addButtonWithTitle("OK")
                        alertView.show()

                        
                        NSLog("Sign Up SUCCESS");
                        self.dismissViewControllerAnimated(true, completion: nil)
                    } else {
                        var error_msg:NSString
                        
                        if jsonData["error_message"] as? NSString != nil {
                            error_msg = jsonData["error_message"] as! NSString
                        } else {
                            error_msg = "Unknown Error"
                        }
                        let alertView:UIAlertView = UIAlertView()
                        alertView.title = "Sign Up Failed!"
                        alertView.message = error_msg as String
                        alertView.delegate = self
                        alertView.addButtonWithTitle("OK")
                        alertView.show()
                        
                    }
                    
                } else {
                    let alertView:UIAlertView = UIAlertView()
                    alertView.title = "Sign Up Failed!"
                    alertView.message = "Connection Failed"
                    alertView.delegate = self
                    alertView.addButtonWithTitle("OK")
                    alertView.show()
                }
            }  else {
                let alertView:UIAlertView = UIAlertView()
                alertView.title = "Sign in Failed!"
                alertView.message = "Connection Failure"
                if let error = reponseError {
                    alertView.message = (error.localizedDescription)
                }
                alertView.delegate = self
                alertView.addButtonWithTitle("OK")
                alertView.show()
            }
        }
        
    }
    

}
