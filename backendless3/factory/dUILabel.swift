import Foundation

class dUILabel : UILabel , dView {
   
   public func setProperties(xPosition:CGFloat , width:CGFloat , title:String){
      self.text = title
      self.contentMode = .scaleAspectFill
      self.numberOfLines = 0
      self.textColor = UIColor.white
      
      self.frame.origin.x = xPosition
      self.frame.origin.y = 10
      
      self.frame.size.width = width - 100
      self.font = UIFont.systemFont(ofSize: 16)
      self.sizeToFit()
      self.frame.size.width = width - 100 //need twice
      self.textAlignment = .right
   }
   
   public func setProperties(xPosition:CGFloat , width:CGFloat , link:String , tag:Int){}
}
