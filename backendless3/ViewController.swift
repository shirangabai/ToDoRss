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
      
      //registerUserAsync()
      //loginUserAsync()
      //logoutUserAsync()
      validUserTokenAsync()
   }
   
   
   @IBAction func onClickSegment(_ sender: UISegmentedControl) {
      txtConfirmInput.isHidden = !txtConfirmInput.isHidden
      txtNameInput.text = ""
      txtPassInput.text = ""
      txtConfirmInput.text = ""
   }
   
   
   @IBAction func onClickOk(_ sender: UIButton) {
      let email = txtNameInput.text!.trim()
      let pass = txtPassInput.text!
      let confirm = txtConfirmInput.text!
      
      if email.isEmpty || pass.isEmpty {
         return
      }
      
      if segment.selectedSegmentIndex == 1 {
         loginUserAsync(email: email, pass: pass)
      }else {
         if confirm == pass {
            if U.isValidEmail(testStr: email) {
               registerUserAsync(email: email, pass: pass)
            }else {
               print("Invalid email")
            }
         }
      }
      
      
   }
   
   func registerUserAsync(email: String , pass: String) {
      let user = BackendlessUser()
      user.email = email as NSString
      user.password = pass as NSString
      
      backendless.userService.registering(user, response: { (registeredUser : BackendlessUser?) -> () in
         //print("User has been registered (ASYNC): \(registeredUser)")
         print("success")
         self.loginUserAsync(email: email, pass: pass)
         //self.toSecondViewController()
      },error: { ( fault : Fault?) -> () in
         print("\n\nServer reported an error: \(fault!)")
      })
   }
   
   func loginUserAsync(email: String , pass: String) {
      backendless.userService.login(email, password: pass , response: { ( user : BackendlessUser?) -> () in
         print("User logged: \(user!.email!)")
         self.toSecondViewController()
      },error: { ( fault : Fault?) -> () in
         print("Server reported an error: \(fault!)")
      })
   }
   
   func validUserTokenAsync() {
      backendless.userService.isValidUserToken({ (result : NSNumber?) -> () in
            print("isValidUserToken: \(result!==1)")
         self.toSecondViewController()
            
      },error: { (fault : Fault?) -> () in
            print("Server reported an error: \(fault!)")
      })
   }
   
   func logoutUserAsync() {
      backendless.userService.logout({( user : Any?) -> () in
            print("User logged out.")
      },
         error: { ( fault : Fault?) -> () in
            print("Server reported an error: \(fault!)")
      })
   }
   
   
   func toSecondViewController() {
      let next=storyboard!.instantiateViewController(withIdentifier: "id_second_view_controller");
      (next as! SecondController).setBackendless(backendless: backendless)
      show(next, sender: self);
   }
}

