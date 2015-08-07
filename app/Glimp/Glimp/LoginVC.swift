//
//  LoginVC.swift
//  SwiftLoginScreen
//
//  Created by Dipin Krishna on 31/07/14.
//  Copyright (c) 2014 Dipin Krishna. All rights reserved.

import UIKit
import MediaPlayer
import Alamofire
import FBSDKCoreKit
import FBSDKLoginKit

class LoginVC: UIViewController, UITextFieldDelegate {
    var moviePlayer: MPMoviePlayerController!
    
    @IBOutlet weak var te: UIView!
    @IBOutlet weak var gplus: UIView!
    var fbusername: String = ""
    var fbid: String = ""
    
    @IBOutlet var loginBut: UIButton!
    @IBOutlet var txtUsername : UITextField!
    @IBOutlet var txtPassword : UITextField!
    var facebookProperty = FBSDKProfile()
    let kClientId = "166564040526-3g8glqoub2fp2f52vkr2ugcgj2dn8pgt.apps.googleusercontent.com"
    var signInButton : GPPSignInButton!
    func hideKeyboard() {
        view.endEditing(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector("hideKeyboard"))
        tapGesture.cancelsTouchesInView = true
        view.addGestureRecognizer(tapGesture)

        ////////////////
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            println("Already have access token")
            // self.performSegueWithIdentifier("showHomePage", sender: self.navigationController)
        } else {
        }
        
        var loginButton = FBSDKLoginButton()
        loginButton.frame = CGRectOffset(loginButton.frame, (self.view.center.x), (self.loginBut.center.y + 60))
        //loginButton.center = self.view.center

//        loginButton.center = self.te.center
        loginButton.delegate = self
        self.view.addSubview(loginButton)

//        signInButton = GPPSignInButton()
        // MARK: Google login Process
//        var signIn = GPPSignIn.sharedInstance()
//        signIn.shouldFetchGooglePlusUser = true
//        signIn.shouldFetchGoogleUserEmail = true;  // Uncomment to get the user's email
//        
//        // You previously set kClientId in the "Initialize the Google+ client" step
//        signIn.clientID = kClientId
//        
//        // Uncomment one of these two statements for the scope you chose in the previous step
//        //signIn.scopes = [ kGTLAuthScopePlusLogin ];  // "https://www.googleapis.com/auth/plus.login" scope
//        signIn.scopes = [ "profile" ]            // "profile" scope
//        
//        // Optional: declare signIn.actions, see "app activities"
//        signInButton.center = self.gplus.center
//        
//        signIn.delegate = self;
        
//        self.view.addSubview(signInButton)
        
        
        /////////////
        self.txtUsername.delegate = self;
        self.txtPassword.delegate = self;
        
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
    
    func loopVideo() {
        self.moviePlayer.play()
    }
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue)
    }
    
    
    
    
    func fbregister(){
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                println("Error: \(error)")
            }
            else
            {
                println("fetched user: \(result)")
                let userEmail : NSString = result.valueForKey("email") as! NSString
                println("User Email is: \(userEmail)")
                let id : NSString = result.valueForKey("id") as! NSString
                
                var post:NSString = "name=\(self.fbusername)&email=\(userEmail)&id=\(id)"
                
                self.fbid = id as String
                
                NSLog("PostData: %@",post);
                
                var url:NSURL = NSURL(string:"http://ec2-54-148-130-55.us-west-2.compute.amazonaws.com/fblogin.php")!
                
                var postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
                
                var postLength:NSString = String( postData.length )
                
                var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
                request.HTTPMethod = "POST"
                request.HTTPBody = postData
                request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                request.setValue("application/json", forHTTPHeaderField: "Accept")
                
                
                var reponseError: NSError?
                var response: NSURLResponse?
                
                var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&reponseError)
                if ( urlData != nil ) {
                    let res = response as! NSHTTPURLResponse!;
                    
                    NSLog("Response code: %ld", res.statusCode);
                    
                    if (res.statusCode >= 200 && res.statusCode < 300)
                    {
                        var responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
                        
                        NSLog("Response ==> %@", responseData);
                        
                        
                        if(responseData == "{\"registered\"}")
                        {
                            self.fbregisteruser()
                            
                        }
                        else if (responseData == "{\"success\"}") {
                            var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()

                            prefs.setObject(self.fbusername, forKey: "USERNAME")
                            prefs.setInteger(1, forKey: "ISLOGGEDIN")
                            prefs.setInteger(1, forKey: "FACEBOOK")

                            self.dismissViewControllerAnimated(true, completion: nil)
                            
                        }
                    } else {
                        var alertView:UIAlertView = UIAlertView()
                        alertView.title = "Sign in Failed!"
                        alertView.message = "Connection Failure"
                        if let error = reponseError {
                            alertView.message = (error.localizedDescription)
                        }
                        alertView.delegate = self
                        alertView.addButtonWithTitle("OK")
                        alertView.show()
                    }
                }}
            
        })
    }
    
    
    
    func fbregisteruser(){
        var inputTextField: UITextField?
        
        //Create the AlertController
        let actionSheetController: UIAlertController = UIAlertController(title: "Username", message: "Please Enter a username:", preferredStyle: .Alert)
        
        
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            //Do some stuff
        }
        actionSheetController.addAction(cancelAction)
        //Create and an option action
        let nextAction: UIAlertAction = UIAlertAction(title: "Register", style: .Default) { action -> Void in
            NSLog("Login SUCCESS");
            var userName = (actionSheetController.textFields?[0] as! UITextField).text
            var nouser = ["69","666","1cup","2girls","2girls1cup","4r5e","5h1t","abortion","ahole","aids","anal","anal sex","analsex","angrypenguin","angrypenguins","angrypirate","angrypirates","anus","apeshit","ar5e","arrse","arse","arsehole","artard","askhole","ass","ass 2 ass","ass hole","ass kisser","ass licker","ass lover","ass man","ass master","ass pirate","ass rapage","ass rape","ass raper","ass to ass","ass wipe","assbag","assbandit","assbanger","assberger","assburger","assclown","asscock","asses","assface","assfuck","assfucker","assfukker","asshat","asshead","asshole","asshopper","assjacker","asslicker","assmunch","asswhole","asswipe","aunt flo","b000bs","b00bs","b17ch","b1tch","bag","ballbag","ballsack","bampot","bang","bastard","basterd","bastich","bean count","beaner","beastial","beastiality","beat it","beat off","beaver","beavers","beeyotch","betch","beyotch","bfe","bi sexual","bi sexuals","biatch","bigmuffpi","biotch","bisexual","bisexuality","bisexuals","bitch","bitched","bitches","bitchin","bitching","bizatch","blackie","blackies","block","bloody hell","blow","blow job","blow wad","blowjob","boff","boffing","boffs","boink","boinking","boinks","boiolas","bollick","bollock","bondage","boner","boners","bong","boob","boobies","boobs","booty","boy2boy","boy4boy","boyforboy","boyonboy","boys2boys","boys4boys","boysforboys","boysonboys","boytoboy","brothel","brothels","brotherfucker","buceta","bugger","bugger ","buggered","buggery","bukake","bullshit","bumblefuck","bumfuck","bung","bunghole","bush","bushpig","but","but plug","butplug","butsecks","butsekks","butseks","butsex","butt","buttfuck","buttfucka","buttfucker","butthole","buttmuch","buttmunch","buttplug","buttsecks","buttsekks","buttseks","buttsex","buttweed","c0ck","c0cksucker","cabron","camel toe","camel toes","cameltoe","canabis","cannabis","carpet muncher","castrate","castrates","castration","cawk","chank","cheesedick","chick2chick","chick4chick","chickforchick","chickonchick","chicks2chicks","chicks4chicks","chicksforchicks","chicksonchicks","chickstochicks","chicktochick","chinc","chink","chinks","choad","choads","chode","cipa","circlejerk","circlejerks","cl1t","cleavelandsteemer","cleveland","clevelandsteamer","clevelandsteemer","clit","clitoris","clitoris     ","clits","clusterfuck","cock","cock block","cock suck","cockblock","cockface","cockfucker","cockfucklutated","cockhead","cockmaster","cockmunch","cockmuncher","cockpenis","cockring","cocks","cocksuck","cocksucker","cocksuka","cocksukka","cok","cokmuncher","coksucka","comestain","condom","condoms","coochie","coon","coons","cooter","copulated","copulates","copulating","copulation","corn","corn_hole","cornhole","cornholes","cr4p","crap","crapping","craps","cream","creampie","crotch","crotches","cum","cumming","cums","cumshot","cumstain","cumtart","cunnilingus","cunt","cuntbag","cunthole","cuntilingis","cuntilingus","cunts","cuntulingis","cuntulingus","d1ck","dabitch","dago","dammit","damn","damned","dance","darkie","darkies","darky","deep","deepthroat","defecate","defecates","defecating","defecation","deggo","diaf","diarea","diarhea","diarrhea","dick","dickhead","dickhole","dickring","dicks","dicksucker","dicksuckers","dicksucking","dicksucks","dickwad","dickweed","dickwod","dik","dike","dikes","dildo","dildoe","dildoes","dildos","dilligaf","dingleberry","dipshit","dirsa","dlck","dog","doggin","doggystyle","dogshit","domination","dominatrix","donkey","donkeyribber","dook","doosh","dork","dorks","douche","douchebag","douchebags","douchejob","douchejobs","douches","douchewaffle","duche","dumass","dumb","dumb fuck","dumbass","dumbfuc","dumbfuck","dumbshit","dumdfuk","dumfuck","dumshit","dyke","dykes","ead","eat me","ejaculat","ejaculate","ejaculated","ejaculates","ejaculation","ejakulat","ejakulate","enema","enemas","enima","enimas","epeen","epenis","erect","erection","erekshun","erotic","eroticism","f0x0r","f0xx0r","fack","facker","facking","fag","fagbag","faggit","faggitt","faggot","faggots","faghag","fags","fagtard","fannyflaps","fannyfucker","fart","farting","farts","fatass","fck","fcker","fckers","fcking","fcks","fcuk","fcuker","fcuking","feck","fecker","felch","felched","felcher","felches","felching","fellate","fellatio","feltch","feltched","feltcher","feltches","feltching","fetish","fetishes","finger","fingering","fisting","flog","flogging","flogs","fook","fooker","foreskin","forked","fornicate","fornicates","fornicating","fornication","frigging","frottage","fubar","fuck","fucka","fuckas","fuckass","fucked","fuckedup","fucker","fuckers","fuckface","fuckfaces","fuckhead","fuckhole","fuckhouse","fuckin","fucking","fuckingshitmotherfucker","fucknugget","fucks","fucktard","fuckwad","fuckwhit","fuckwit","fuckyou","fucndork","fudgepacker","fudgepacking","fugly","fuk","fuken","fuker","fukker","fukkin","fukwhit","fukwit","fuq","fuqed","fuqing","fuqs","fux","fux0r","fuxx0r","gang bang","gangbang","gangbanger","gangbangers","gangbanging","gangbangs","ganja","gay","gaydar","gays","gaytard","gaywad","genital","genitalia","genitals","gerbiling","ghey","girl2girl","girl4girl","girlforgirl","girlongirl","girls2girls","girls4girls","girlsforgirls","girlsongirls","girlstogirls","girltogirl","gloryhole","goatse","gobshit","gobshite","gobtheknob","goddam","goddammit","goddamn","goddamned","goddamnit","gooch","gook","gooks","groe","gspot","gtfo","gubb","gummer","guppy","guy2guy","guy4guy","guyforguy","guyonguy","guys2guys","guys4guys","guysforguys","guysonguys","guystoguys","guytoguy","gyfs","hair pie","hairpie","hairpies","hairy bush","hand","handjob","harbl","hard on","hardon","hardons","hell","hentai","heroin","herpes","herps","hick","hiv","ho","hoare","hoe","hoebag","hoer","hoes","hole","homo","homos","homosexual","homosexuality","homosexuals","honkee","honkey","honkie","honkies","honky","hoochie","hooker","hookers","hore","horney","hornie","horny","horseshit","hosebeast","hot","hotcarl","hotkarl","hummer","hump","humping","humps","hymen","i like ass","i love ass","i love tit","i love tits","iluvsnatch","incest","ip freely","itard","jack","jack off","jackass","jackingoff","jackoff","jap","japs","jerk off","jerkoff","jesusfreak","jewbag","jewboy","jiga","jigaboo","jigga","jiggaboo","jis","jism","jiz","jizm","jizz","job","junglebunny","jysm","kawk","khunt","kike","kikes","kinky","kkk","klit","knob","knobjocky","knobjokey","knockers","kooch","koolie","koolielicker","koolies","kootch","kukluxklan","kunt","kyke","l3itch","labia","lap","lapdance","lelo","lemonparty","lesbian","lesbians","lesbifriends","lesbo","lesbos","leyed","lez","lezzie","lichercunt","lick ass","lick myass","lick tit","lickbeaver","lickcarpet","lickdick","lickherass","lickherpie","lickmy ass","lickpussy","like ass","like tit","limpdick","lingerie","llello","lleyed","loltard","love ass","love juice","love tit","lovehole","lsd","lucifer","lumpkin","m0f0","m0fo","m45terbate","ma5terb8","ma5terbate","mack","mammaries","man2man","man4man","mandingo","manforman","mangina","manonman","mantoman","marijuana","masochism","masochist","master","masterb8","masterbat3","masterbate","masterbates","masterbating","masterbation","masterbations","masturbate","masturbates","masturbating","masturbation","meatcurtain","men2men","men4men","menformen","menonmen","mentomen","milf","minge","mistress","mof0","mofo","motha","motherfuck","motherfucka","motherfuckas","motherfucked","motherfucker","motherfuckers","motherfucking","motherfuckka","muff","muff diver","muffdiver","muffdiving","munch","mung","mutha","muther","muzza","my ass","n1gga","n1gger","naked","nambla","nards","nazi","nazies","nazis","necrophile","necrophiles","necrophilia","necrophiliac","negro","neonazi","nice ass","nig","nigg3r","nigg4h","nigga","niggah","niggas","niggaz","nigger","niggers","nigglet","niglet","nippies","nipple","nips","nobhead","nobjockey","nobjocky","nobjokey","nookey","nookie","noshit","nude","nudes","nudity","numbnuts","nut bag","nut lick","nut lover","nut sack","nut suck","nutnyamouth","nutnyomouth","nuts","nutsack","nutstains","nymph","nympho","nymphomania","nymphomaniac","nymphomaniacs","nymphos","oral","orgasm","orgasmic","orgasms","orgi","orgiastic","orgies","orgy","paedophile","panooch","panties","panty","patootie","pecker","peckerhead","peckers","pedophile","pedophiles","pedophilia","peepshow","peepshows","pen15","penii","penis","penises","penisfucker","perve","perversion","pervert","perverted","perverts","phat","phile","philes","philia","phuck","phucker","phuckers","phucking","phucks","phuk","phuker","phukers","phuking","phuks","phuq","phuqer","phuqers","phuqing","phuqs","pie","pigfucker","pimpis","piss","pissant","pissed","pisser","pisses","pissfart","pissflaps","pissing","pocket","poke","poon","poon eater","poon tang","poonani","poonanny","poonany","poonj","poonjab","poonjabie","poonjaby","poontang","poop","poopchute","poot","porchmonkey","porking","porks","porn","porno","prick","pricks","prostitot","pube","pubes","pubic","pud","pudd","puds","punani","punanni","punanny","punta","puntang","pusse","pussi","pussies","pussy","puta","puto","qeef","qfmft","qq more","quafe","quap","quatch","queef","queefe","queefed","queefing","queer","queerbait","queermo","queers","queev","quefe","queif","quief","quif","quiff","quim","quim nuts","qweef","racial","racism","racist","racists","rape","raped","raper","raping","rapist","redtide","reefer","renob","retard","ricockulous","rim job","rimjaw","rimjob","rimjobs","rimming","roofie","rtard","rtfm","rubbers","rump","rumpranger","rumprider","rumps","rustytrombone","sadism","sadist","sadomasochism","sand nigger","sandnigga","sandniggas","sandnigger","sandniggers","sapphic","sappho","sapphos","satan","scatological","scheiss","scheisse","schlong","schlonging","schlongs","schtup","schtupp","schtupping","schtups","screw","screw me","screw this","screw you","screwed","screwer","screwing","screws","screwyou","scroat","scrog","scrote","scrotum","secks","sekks","seks","semen","sex","sexed","sexking","sexkitten","sexmachine","sexqueen","sexual","sexuality","sexy","sexybitch","sexybitches","sh1t","shag","shagger","shaggin","shagging","shart","shemale","shit","shitdick","shite","shited","shitey","shitface","shitfaced","shitfuck","shithead","shitlist","shits","shitt","shitted","shitter","shittiest","shitting","shitts","shitty","shiznits","shotacon","shotakon","shyte","sickass","sixtynine","sixtynining","skank","skeet","sketell","sko","skrew","skrewing","skrews","slant eye","slanteyes","slattern","slave","slaves","slopehead","slopeheads","slut","slutbag","slutpuppy","sluts","slutty","slutwhore","smegma","smut","snatch","snatches","soddom","sodom","sodomist","sodomists","sodomize","sodomized","sodomizing","sodomy","sonnofabitch","sonnovabitch","sonnuvabitch","sonofabitch","spank","spanked","spanking","spanks","spearchucker","spearchuckers","sperm","spermicidal","spermjuice","sphincter","spic","spick","spicks","spics","spik","spiks","spooge","stank ho","stankpuss","steamer","stfu","stiffie","stiffy","stud","studs","submissive","submissives","suck","suck ass","sucks ass","swinger","swingers","t1tt1e5","t1tties","take a dump","takeadump","tar baby","tarbaby","tard","teabaggin","teabagging","teen2teen","teen4teen","teenforteen","teenonteen","teens2teens","teens4teens","teensforteens","teensonteens","teenstoteens","teentoteen","teets","teez","testes","testical","testicals","testicle","testicles","threesome","throat","thundercunt","tiddie","tiddy","tit","titandass","titbabe","titball","titfuck","tits","titsandass","titt","tittie","tittie5","tittiefucker","titties","titts","titty","tittyfuck","tittywank","titwank","toke","toss salad","tramp","tramps","tranny","transexual","transexuals","transvestite","transvestites","tubgirl","turd","tw4t","twat","twathead","twatlips","twats","twatty","twunt","twunter","ufia","umfriend","underwear","up yours","upyours","upyourz","urinate","urinated","urinates","urinating","urination","urine","vaffanculo","vag","vagina","vaginal","vaginas","vaginer","vagitarian","vagoo","vagy","vajayjay","viagra","vibrator","virgin","virginity","virgins","voyeur","voyeurism","voyeurs","vulva","w00se","wackedoff","wackoff","wad blower","wad lover","wad sucker","wadblower","wadlover","wadsucker","waffle","wang","wank","wanker","wanky","wetback","wetbacks","wetdream","wetdreams","whackedoff","whackoff","whigger","whip","whipped","whipping","whips","whiz","whoe","whore","whored","whorehouse","whores","whoring","wigger","willies","wog","wogged","woggy","wogs","woman2woman","woman4woman","womanforwoman","womanonwoman","womantowoman","women2women","women4women","womenforwomen","womenonwomen","womentowomen","woof","wop","xx","xxx","yank","yayo","yeat","yeet","yeyo","yiff","yiffy","yola","yols","yoni","youaregay","yourgay","zipperhead","zipperheads","zorch","admin","glimp","moderator","password","username"]

            self.fbusername = userName
            
            println("user:" + userName)
            var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
            prefs.setObject(userName, forKey: "USERNAME")
            prefs.setInteger(1, forKey: "ISLOGGEDIN")
            prefs.setInteger(1, forKey: "FACEBOOK")
            
            prefs.synchronize()
            
            let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let deviceToken = String(delegate.deviceToken)
            println("here u go:")
            println(deviceToken)
            
            let verifier = count(userName)
            
            if ( userName == "") {
                
                var alertView:UIAlertView = UIAlertView()
                alertView.title = "Sign Up Failed!"
                alertView.message = "Please enter Username and Password"
                alertView.delegate = self
                alertView.addButtonWithTitle("OK")
                alertView.show()
                self.fbregisteruser()

            }
            else if (( find(nouser, userName as String)) != nil) {
                
                var alertView:UIAlertView = UIAlertView()
                alertView.title = "Sign Up Failed!"
                alertView.message = "Username not allowed"
                alertView.delegate = self
                alertView.addButtonWithTitle("OK")
                alertView.show()
                self.fbregisteruser()

                
            } else if ( verifier < 4){
                var alertView:UIAlertView = UIAlertView()
                alertView.title = "Sign Up Failed!"
                alertView.message = "Username must be 5 or more characters"
                alertView.delegate = self
                alertView.addButtonWithTitle("OK")
                alertView.show()
                self.fbregisteruser()

            } else {
                Alamofire.request(.POST, "http://ec2-54-148-130-55.us-west-2.compute.amazonaws.com/fbuser.php", parameters: ["username": userName, "fbid": self.fbid])
                    
                    .responseString { (request, response, JSON, error) in
                        if JSON == "{\"exists\"}"{
                            println()
                            var alertView:UIAlertView = UIAlertView()
                            alertView.title = "Username Exists"
                            alertView.message = "Username Exists try someething else."
                            alertView.delegate = self
                            alertView.addButtonWithTitle("OK")
                            alertView.show()
                            self.fbregisteruser()
                        } else if JSON == "{\"registered\"}" {
                            
                            var alertView:UIAlertView = UIAlertView()
                            alertView.title = "Registered"
                            alertView.message = "Successfully Registered!"
                            alertView.delegate = self
                            alertView.addButtonWithTitle("OK")
                            alertView.show()
                            
                            
                            
                            
                            println("---------")
                            
                            self.dismissViewControllerAnimated(true, completion: nil)
                            
                        }
                        else {
                            var alertView:UIAlertView = UIAlertView()
                            alertView.title = "Error"
                            alertView.message = "An error has occured, please try again later."
                            alertView.delegate = self
                            alertView.addButtonWithTitle("OK")
                            alertView.show()
                            
                        }
                        
                        
                }
                

            }
            
        }
        actionSheetController.addAction(nextAction)
        //Add a text field
        actionSheetController.addTextFieldWithConfigurationHandler { textField -> Void in
            
            inputTextField = textField
            
        }
        
        //Present the AlertController
        self.presentViewController(actionSheetController, animated: true, completion: nil)

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
    
    @IBAction func signinTapped(sender : UIButton) {
        var username:NSString = txtUsername.text
        var password:NSString = txtPassword.text
        var userid:NSString

        if ( username.isEqualToString("") || password.isEqualToString("") ) {
            
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign in Failed!"
            alertView.message = "Please enter Username and Password"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        } else {
            let progressHUD = ProgressHUD(text: "Signing In...")
            self.view.addSubview(progressHUD)

            var post:NSString = "username=\(username)&password=\(password)"
            
            NSLog("PostData: %@",post);
            
            var url:NSURL = NSURL(string:"http://ec2-54-148-130-55.us-west-2.compute.amazonaws.com/jsonlogin2.php")!
            
            var postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
            
            var postLength:NSString = String( postData.length )
            
            var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.HTTPBody = postData
            request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            
            var reponseError: NSError?
            var response: NSURLResponse?
            
            var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&reponseError)
            
            if ( urlData != nil ) {
                let res = response as! NSHTTPURLResponse!;
                
                NSLog("Response code: %ld", res.statusCode);
                
                if (res.statusCode >= 200 && res.statusCode < 300)
                {
                    var responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
                    
                    NSLog("Response ==> %@", responseData);
                    
                    var error: NSError?
                    
                    let jsonData:NSDictionary = NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers , error: &error) as! NSDictionary
                    
                    
                    let success:NSInteger = jsonData.valueForKey("success") as! NSInteger
                    
                    //[jsonData[@"success"] integerValue];
                    
                    NSLog("Success: %ld", success);
                    
                    if(success == 1)
                    {
                        NSLog("Login SUCCESS");
                        
                        var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                        prefs.setObject(username, forKey: "USERNAME")
                        prefs.setInteger(1, forKey: "ISLOGGEDIN")
                        prefs.synchronize()
                        
                        //let deviceToken = "a2222222a"
                        println(username)
                        
                        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
                        let deviceToken = String(delegate.deviceToken)
                        
                        
                        Alamofire.request(.GET, "http://ec2-54-148-130-55.us-west-2.compute.amazonaws.com/beta/devicetokenizer.php", parameters: ["username": username,"devicetoken": deviceToken,  "OS": "iOS"])
                            
                            .response { (request, response, data, error) in
                                println(request)
                                println(response)
                                println(error)
                        }
                        progressHUD.removeFromSuperview()

                        self.dismissViewControllerAnimated(true, completion: nil)
                        
                    } else {
                        var error_msg:NSString
                        
                        if jsonData["error_message"] as? NSString != nil {
                            error_msg = jsonData["error_message"] as! NSString
                        } else {
                            error_msg = "Unknown Error"
                        }
                        var alertView:UIAlertView = UIAlertView()
                        alertView.title = "Sign in Failed!"
                        alertView.message = error_msg as String
                        alertView.delegate = self
                        alertView.addButtonWithTitle("OK")
                        alertView.show()
                        progressHUD.removeFromSuperview()

                    }
                    
                } else {
                    var alertView:UIAlertView = UIAlertView()
                    alertView.title = "Sign in Failed!"
                    alertView.message = "Connection Failed"
                    alertView.delegate = self
                    alertView.addButtonWithTitle("OK")
                    alertView.show()
                    progressHUD.removeFromSuperview()

                }
            } else {
                var alertView:UIAlertView = UIAlertView()
                alertView.title = "Sign in Failed!"
                alertView.message = "Connection Failure"
                if let error = reponseError {
                    alertView.message = (error.localizedDescription)
                }
                alertView.delegate = self
                alertView.addButtonWithTitle("OK")
                alertView.show()
                progressHUD.removeFromSuperview()

            }
        }
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {    //delegate method
        if (textField == self.txtUsername) {
            self.txtUsername.text = "";
        }
        else if (textField == self.txtPassword){
            
            self.txtPassword.text = "";
            
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func showHomeView() {
        self.performSegueWithIdentifier("showHomePage", sender: self.navigationController)
    }
    
    
}
extension LoginVC : FBSDKLoginButtonDelegate {
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        println(result)
        if result.token != nil {
            self.fbregister()
            
            
            
            //self.dismissViewControllerAnimated(true, completion: nil)
        } else {
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        println("logged out")
    }
}

extension LoginVC : GPPSignInDelegate {
    func finishedWithAuth(auth: GTMOAuth2Authentication!, error: NSError!) {
        println("Received error %@ and auth object %@",error, auth)
    }
}

