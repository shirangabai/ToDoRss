import Foundation

class Task : NSObject {
   
   override init() {
      
   }
   
   var objectId : String?
   var ownerId : String?
   var task : String=""
   var created : Date?
   var priority : Int=0
   var doneB : Bool = true;
 }
