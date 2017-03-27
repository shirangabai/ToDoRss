import UIKit


class ViewController: UIViewController {
   let APP_ID = "B19F31E5-6539-005B-FF2C-A24E74012400"
   let SECRET_KEY = "E63B06A5-4F78-FEE6-FF1E-A470A97C5000"
   let VERSION_NUM = "v1"
   
   @IBOutlet weak var txtNameInput: UITextField!
   @IBOutlet weak var txtPassInput: UITextField!
   @IBOutlet weak var txtConfirmInput: UITextField!
   @IBOutlet weak var segment: UISegmentedControl!
   
   let  backendless = Backendless.sharedInstance()!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      backendless.userService.setStayLoggedIn( true )
      backendless.initApp(APP_ID, secret:SECRET_KEY, version:VERSION_NUM)
      
      validUserTokenAsync()
   }
   
   @IBAction func onClickSegment(_ sender: UISegmentedControl) {
      txtConfirmInput.isHidden = !txtConfirmInput.isHidden
      txtNameInput.text = ""
      txtPassInput.text = ""
      txtConfirmInput.text = ""
   }
   
   //Click OK after filling out the registration or login with data
   @IBAction func onClickOk(_ sender: UIButton) {
      let email = txtNameInput.text!.trim()
      let pass = txtPassInput.text!
      let confirm = txtConfirmInput.text!
      
      if email.isEmpty || pass.isEmpty {
         U.createDialogOk(title: "Alert", msg: "All fields are required", mySelf: self)
         return
      }
      
      //login state
      if segment.selectedSegmentIndex == 1 {
         loginUserAsync(email: email, pass: pass)
      //register state
      }else {
         if confirm == pass {
            if U.isValidEmail(testStr: email) {
               registerUserAsync(email: email, pass: pass)
            }else {
               U.createDialogOk(title: "Alert", msg: "Invalid email", mySelf: self)
            }
         }else {
            U.createDialogOk(title: "Alert", msg: "Password and verification do not match", mySelf: self)
         }
      }
   }
   
   func registerUserAsync(email: String , pass: String) {
      let user = BackendlessUser()
      user.email = email as NSString
      user.password = pass as NSString
      
      backendless.userService.registering(user, response: { (registeredUser : BackendlessUser?) -> () in
         self.loginUserAsync(email: email, pass: pass)
      },error: { ( fault : Fault?) -> () in
         U.createDialogOk(title: "Alert", msg: "Server reported an error", mySelf: self)
      })
   }
   
   func loginUserAsync(email: String , pass: String) {
      backendless.userService.login(email, password: pass , response: { ( user : BackendlessUser?) -> () in
         self.toSecondViewController()
      },error: { ( fault : Fault?) -> () in
         U.createDialogOk(title: "Alert", msg: "At least one of the inputs is incorrect", mySelf: self)
      })
   }
   
   //check valid token for auto login
   func validUserTokenAsync() {
      backendless.userService.isValidUserToken({ (result : NSNumber?) -> () in
         self.toSecondViewController()
      },error: { (fault : Fault?) -> () in
         U.createDialogOk(title: "Alert", msg: "Server reported an error", mySelf: self)
      })
   }
   
   func logoutUserAsync() {
      backendless.userService.logout({( user : Any?) -> () in
         print("User logged out.")
      },error: { ( fault : Fault?) -> () in
         U.createDialogOk(title: "Alert", msg: "Server reported an error", mySelf: self)
      })
   }
   
      
   func toSecondViewController() {
      let next=storyboard!.instantiateViewController(withIdentifier: "id_second_view_controller");
      (next as! SecondController).setBackendless(backendless: backendless)
      show(next, sender: self);
   }
}

