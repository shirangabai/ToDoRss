import Foundation

class U {
   static func dateFormat (date: Date)->String{
      let formatter = DateFormatter()
      formatter.dateFormat = "dd.MM.yy HH:mm"
      
      return formatter.string(from: date)
   }
   
   static func isValidEmail(testStr:String) -> Bool {
      // print("validate calendar: \(testStr)")
      let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
      
      let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
      return emailTest.evaluate(with: testStr)
   }
   
}
