import Foundation

class U {
   static func dateFormat (date: Date)->String{
      let formatter = DateFormatter()
      formatter.dateFormat = "dd.MM.yy HH:mm"
      
      return formatter.string(from: date)
   }
   
   static func isValidEmail(testStr:String) -> Bool {
      let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
      let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
      return emailTest.evaluate(with: testStr)
   }
   
   static func createDialogOk (title:String , msg:String , mySelf:UIViewController){
      let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      mySelf.show(alert, sender: mySelf)
   }
   
   static func createDialogOkCancel(title:String , msg:String , mySelf:UIViewController , callback:@escaping()->()){
      let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
      
      alert.addAction(UIAlertAction(title: "OK", style: .default , handler: {(uiAlertAction) in
         callback()
      }))
      
      alert.addAction(UIAlertAction(title: "Cancel", style: .cancel , handler: nil))
      mySelf.present(alert, animated: true, completion: nil);
   }
}
