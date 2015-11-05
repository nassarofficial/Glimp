<!DOCTYPE html>
<html>
<head>
<?
$id=$_GET["id"];


function fetch($result)
{    
    $array = array();

    if($result instanceof mysqli_stmt)
    {
        $result->store_result();

        $variables = array();
        $data = array();
        $meta = $result->result_metadata();

        while($field = $meta->fetch_field())
            $variables[] = &$data[$field->name]; // pass by reference

        call_user_func_array(array($result, 'bind_result'), $variables);

        $i=0;
        while($result->fetch())
        {
            $array[$i] = array();
            foreach($data as $k=>$v)
                $array[$i][$k] = $v;
            $i++;

            // don't know why, but when I tried $array[] = $data, I got the same one result in all rows
        }
    }
    elseif($result instanceof mysqli_result)
    {
        while($row = $result->fetch_assoc())
            $array[] = $row;
    }

    return $array;
}



$rows = array();

$server = 'localhost';
$user = 'root';
$pass = 'E663%156Z>z9d{$Ql395%2uH761oX9dP';
$dbase = 'glimp';

$mysqli = new mysqli($server, $user, $pass, $dbase);

$prename = "id";

$rows = array();

if ($stmt = $mysqli->prepare("SELECT * from glimps where id =".$id)) {



     /* bind parameters for markers */

     /* execute query */
     $stmt -> execute();

     $rows = fetch($stmt);
     $vidplace = $rows[0]['filename'];
?>
    <meta charset='utf-8' />
    <title>Glimp</title>
    <meta name='viewport' content='initial-scale=1,maximum-scale=1,user-scalable=no' />
        <link href="dist/css/vendor/bootstrap.min.css" rel="stylesheet">
    <link href="dist/css/flat-ui.css" rel="stylesheet">

    <style>
        body { margin:0; padding:0; }
        #map { position:absolute; top:0; bottom:0; width:100%; }
    </style>
</head>
<body>

    <div class="navbar navbar-default navbar-fixed-top" role="navigation">
      <div class="container">
        <div class="navbar-header">
          <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
            <span class="sr-only">Toggle navigation</span>
          </button>
          <a class="navbar-brand" href="#">Glimp</a>
        </div>
        <div class="navbar-collapse collapse">
          <ul class="nav navbar-nav">
            <li class="active"><a href="index.php">Home</a></li>
            <li><a href="#Terms" data-toggle="modal" data-target=".bs-example-modal-lg">Terms</a></li>
            <li><a href="#Privacy" data-toggle="modal" data-target=".bs-example-modal2-lg">Privacy</a></li>
           <li><a href="#Contact" data-toggle="modal" data-target=".bs-example-modal3-lg">Contact</a></li>

          </ul>
        </div><!--/.nav-collapse -->
      </div>
    </div>
<?
echo '<video width="100%" height="300px" class="video-js" preload="auto" poster="thumbnail/'. $rows[0]['filename'].'.png" data-setup="{}">
            <source src="'. $vidplace.'" type="video/mp4">
          </video>
        ';
}
else{
echo '{"not available"}';



}


/* close connection */
$mysqli -> close();

?><!-- /video -->
    <div class="modal fade bs-example-modal3-lg" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
       <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="gridSystemModalLabel">Contact</h4>
      </div>
            <div class="modal-body">
              <div class="row">
         		 <div class="col-md-5">
                 Your feedback is highly appreciaited. Glimp App team will be happy to hear what you have to say about us.</br> 
                <strong>Email</strong></br> Info@glimpnow.com </div>
                <div class="col-md-5">        
                    <form>
                    <div class="form-group">
                    <label for="recipient-name" class="control-label">Recipient:</label>
                    <input type="text" class="form-control" id="recipient-name">
                      </div>
                      <div class="form-group">
                    <label for="message-text" class="control-label">Message:</label>
                    <textarea class="form-control" id="message-text"></textarea>
                  </div>
                    </form>
			</div>
                </div>
                </div>

      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        <button type="button" class="btn btn-primary">Send message</button>
      </div>

    </div>
  </div>
</div>

    
<div class="modal fade bs-example-modal-lg" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
       <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="gridSystemModalLabel">Terms</h4>
      </div>
            <div class="modal-body">
              <div class="row">
          <div class="col-md-12">

<b>Basic Terms</b>
<p style="font-size:12px">
<li>You mst be at least 13 years to use the service.</li>
<li>You may not post nude, discriminatory, pornographic material or sexually suggestive videos through Glimp.</li>
<li>You are responsible for any activity that occurs through your account and you agree you will not sell, transfer, license or assign your account, followers, username, or any account rights. With the exception of people or businesses that are expressly authorized to create accounts on behalf of their employers or clients, Glimp prohibits and strictly forbids and you agree that you will not create any account for any other user except for yourself.  Accordingly, you are your own representative of the content generated on your own account. You agree that you provide the most updated and accurate information about yourself through your account on Glimp.</li>
<li>You are responsible for your own password’s security and agree that you will not abuse other user’s information and passwords.</li>
<li>You may not use the Service for any illegal or unauthorized purpose.</li>
<li>You are solely responsible for your conduct and any data, video clips, links and other content or materials (collectively, "Content") that you submit, post or display on or via the Service.</li>
<li>You are not allowed to change, imitate or modify any other mobile application or website to imply that it is associated with Glimp.</li>
<li>You must not abuse the service by spamming Glimp users with unnecessary content or irrelevant comments for any commercial or harassing purposes.</li>
<li>You must not use domain names or web URLs in your username without prior written consent from Glimp.</li>
<li>You must not attempt any data hacking or misusage through any viruses, codes of unwanted and malfunctioning nature. You are not allowed to change the way Glimp should look for Glimp users.</li>
<li>Glimp authorized platform is the only mean for creating valid accounts. Accordingly, you must not attempt or use any unauthorized platforms for registering on Glimp.</li>
<li>You must not violate or attempt to violate any of these terms of use and you must not prohibit another Glimp users their rights in enjoying Glimp’s service. </li>
<b>
</br>
Violation of these Terms of Use will result in termination of your Glimp account. You understand and agree that Glimp cannot and will not be responsible for the Content posted on the Service and you use the Service at your own risk. If you violate the letter or spirit of these Terms of Use, or otherwise create risk or possible legal exposure for Instagram, we can stop providing all or part of the Service to you.</b></p>
 </br>
<b>General Conditions</b>
 
<li>We reserve the right to modify or terminate the Glimp service for any reason, without notice at any time.</li>
<li>We reserve the right to modify or alter the Terms of Use at any time and we will notify through your chosen preference. You will know what are the changes and you will be asked to agree on them.</li>
<li>We reserve the right to permit and prohibit the Glimp service to anyone for any reason.</li>
<li>We reserve the right to force penalty to any user that violates the Terms of Use, trademark or annoy other users.</li>
<li>In case of abusing the service in unlawful purposes or presenting threatening or misleading content, we reserve the right to remove the username and the linked content.</li>
<li>We reserve the right to reclaim usernames on behalf of businesses or individuals that hold legal claim or trademark on those usernames.</li>

</br></br>
<b>
Proprietary Rights in Content on Glimp</b>
 </br>
<li>Glimp does NOT claim ANY ownership rights in the text, photos, video, sounds, works of authorship, applications, or any other materials (collectively, "Content") that you post on or through the Glimp Services. By displaying or publishing ("posting") any Content on or through the Glimp Services, you hereby grant to Glimp a non-exclusive, fully paid and royalty-free, worldwide, limited license to use, modify, delete from, add to, publicly perform, publicly display, reproduce and translate such Content, including without limitation distributing part or all of the Site in any media formats through any media channels, except Content not shared publicly ("private") will not be distributed outside the Glimp Services.</li>
<li>Some of the Glimp Services are supported by advertising revenue and may display advertisements and promotions, and you hereby agree that Glimp may place such advertising and promotions on the Glimp Services or on, about, or in conjunction with your Content. The manner, mode and extent of such advertising and promotions are subject to change without specific notice to you.</li>
<li>You represent and warrant that: (i) you fully own the material posted under your username on or through Glimp ,(ii) the content you use, share, or post on or through Glimp abide by the privacy rights, Terms of Use, intellectual property or other usernames’ rights (iii) the posting of your Content on the Site does not result in a breach of contract between you and a third party. You agree to pay for all royalties, fees, and any other monies owing any person by reason of Content you post on or through the Glimp Services. </li>
<li>The Glimp Services contain Content of Users and other Glimp licensors. Except as provided within this Agreement, you may not copy, modify, translate, publish, broadcast, transmit, distribute, perform, display, or sell any Content appearing on or through the Glimp Services.</li>
<li>Glimp performs technical functions necessary to offer the Instagram Services, including but not limited to transcoding and/or reformatting Content to allow its use throughout the Instagram Services.</li>
</br>
 <b>
Glimp is normally available 24/7/365 for all users according to the application’s vision and mission. However, there might short times when scheduled events such as maintenance, server transformation, system upgrade and technical failures that will result for delaying the service and these are out of Glimp’s control. Glimp has the right to delete any material that violates this agreement as well as for any other reason knowing that Glimp archives all videos for future reference and the archive cannot be accessed except with court order. Accordingly, Glimp is not a backup cloud or storage place for your content. </b>
</div>
    </div>  </div>
    </div><!-- /.modal-content -->
  </div><!-- /.modal-dialog -->
</div>



<div class="modal fade bs-example-modal2-lg" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
       <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="gridSystemModalLabel">Terms</h4>
      </div>
            <div class="modal-body">
              <div class="row">
          <div class="col-md-12">

<strong>Last updated: November 1st, 2014 </strong> 
</br>
This page informs you of our policies regarding the collection, use and disclosure of Personal Information when you use our Service.
We will not use or share your information with anyone except as described in this Privacy Policy.
We use your Personal Information for providing and improving the Service. By using the Service, you agree to the collection and use of information in accordance with this policy. Unless otherwise defined in this Privacy Policy, terms used in this Privacy Policy have the same meanings as in our Terms and Conditions.
 </br>

<strong>Information Collection And Use </strong></br>
 While using our Service, we may ask you to provide us with certain personally identifiable information that can be used to contact or identify you. Personally identifiable information may include, but is not limited to, your email address, name, phone number, other information ("Personal Information").
 </br>

<strong>Log Data </strong></br>
 We collect information that your browser sends whenever you visit our Service ("Log Data"). This Log Data may include information such as your computer's Internet Protocol ("IP") address, browser type, browser version, the pages of our Service that you visit, the time and date of your visit, the time spent on those pages and other statistics.
 
When you access the Service by or through a mobile device, we may collect certain information automatically, including, but not limited to, the type of mobile device you use, your mobile devices unique device ID, the IP address of your mobile device, your mobile operating system, the type of mobile Internet browser you use and other statistics.
 </br>

<strong>Location information </strong></br>
 We may use and store information about your location, if you give us permission to do so. We use this information to provide features of our Service, to improve and customize our Service. You can enable or disable location services when you use our Service at anytime, through your mobile device settings.
 </br>

<strong>Cookies</strong></br>
 Cookies are files with small amount of data, which may include an anonymous unique identifier. Cookies are sent to your browser from a web site and stored on your computer's hard drive.
We use "cookies" to collect information. You can instruct your browser to refuse all cookies or to indicate when a cookie is being sent. However, if you do not accept cookies, you may not be able to use some portions of our Service.
 
 </br>

<strong>Service Providers</strong></br>
 We may employ third party companies and individuals to facilitate our Service, to provide the Service on our behalf, to perform Service-related services or to assist us in analyzing how our Service is used.
These third parties have access to your Personal Information only to perform these tasks on our behalf and are obligated not to disclose or use it for any other purpose.
 </br>

<strong>Communications</strong></br>
 We may use your Personal Information to contact you with newsletters, marketing or promotional materials and other information that may be of interest to you. You may opt out of receiving any, or all, of these communications from us by following the unsubscribe link or instructions provided in any email we send.
 </br>

<strong>Compliance With Laws</strong></br>
 We will disclose your Personal Information where required to do so by law or subpoena or if we believe that such action is necessary to comply with the law and the reasonable requests of law enforcement or to protect the security or integrity of our Service.
   </br>

<strong>Business Transaction</strong> </br>
If Glimp is involved in a merger, acquisition or asset sale, your Personal Information may be transferred. We will provide notice before your Personal Information is transferred and becomes subject to a different Privacy Policy.
 </br>

<strong>Security</strong></br>
 The security of your Personal Information is important to us, but remember that no method of transmission over the Internet, or method of electronic storage is 100% secure. While we strive to use commercially acceptable means to protect your Personal Information, we cannot guarantee its absolute security.
 </br>

<strong>International Transfer</strong></br>
 Your information, including Personal Information, may be transferred to — and maintained on — computers located outside of your state, province, country or other governmental jurisdiction where the data protection laws may differ than those from your jurisdiction.
If you are located outside Egypt and choose to provide information to us, please note that we transfer the information, including Personal Information, to Egypt and process it there.
Your consent to this Privacy Policy followed by your submission of such information represents your agreement to that transfer.
 </br>

<strong>Links To Other Sites</strong> </br>
Our Service may contain links to other sites that are not operated by us. If you click on a third party link, you will be directed to that third party's site. We strongly advise you to review the Privacy Policy of every site you visit.
 
We have no control over, and assume no responsibility for the content, privacy policies or practices of any third party sites or services.
 </br>

<strong>Children's Privacy</strong></br>
 Our Service does not address anyone under the age of 13 ("Children").
We do not knowingly collect personally identifiable information from children under 13. If you are a parent or guardian and you are aware that your Children has provided us with Personal Information, please contact us. If we discover that a Children under 13 has provided us with Personal Information, we will delete such information from our servers.
 </br>

<strong>Changes To This Privacy Policy</strong></br>
 We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page.
You are advised to review this Privacy Policy periodically for any changes. Changes to this Privacy Policy are effective when they are posted on this page
If you have any questions about this Privacy Policy, please contact us.
    </div>
  </div>
</div>
<script type="text/javascript">

    // detect if safari mobile
    function isMobileSafari() {
        return navigator.userAgent.match(/(iPod|iPhone|iPad)/) && navigator.userAgent.match(/AppleWebKit/)
    }
    //Launch the element in your app if it's already installed on the phone
    function LaunchApp(vider){
		var url = "glimp://video/";

		var res = url.concat(vider)
      window.open(res,"_self");
	  console.log(res)
    };

    if (isMobileSafari()){
        // To avoid the "protocol not supported" alert, fail must open itunes store to dl the app, add a link to your app on the store
        var appstorefail = "https://itunes.apple.com/eg/app/glimp./id1008395182?mt=8";
        var loadedAt = +new Date;
        setTimeout(
          function(){
            if (+new Date - loadedAt < 2000){
              window.location = appstorefail;
            }
          }
        ,100);
		var urler= '<? echo $id; ?>';
		LaunchApp(urler)

    }

</script>

    <script src="dist/js/vendor/video.js"></script>

    <script src="dist/js/vendor/jquery.min.js"></script>
    <!-- Include all compiled plugins (below), or include individual files as needed -->
    <script src="dist/js/flat-ui.min.js"></script>

</body>
</html>
