import Foundation

class DynamicUIButton : UIButton , DynamicView{
   public func setProperties(xPosition:CGFloat , width:CGFloat , link:String , tag:Int){
      self.downloadedFrom(link: link)
      self.frame = CGRect(x: xPosition, y: 0, width: width, height: 70	)
      self.layer.masksToBounds = false;
      self.layer.cornerRadius = 5;
      self.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
      self.layer.shadowRadius = 5;
      self.layer.shadowOpacity = 0.5;
      self.tag = tag
      
      
   }
   public func setProperties(xPosition:CGFloat , width:CGFloat , title:String){}
   
}
