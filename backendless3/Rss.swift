import Foundation

class Rss{
   private var title : String?
   private var thumb : String?
   private var link : String?
   
   public func setTitle(title: String)->Rss{
      self.title = title
      return self
   }
   
   public func setThumb (thumb: String)->Rss{
      self.thumb = thumb
      return self
   }
   
   public func setLink (link: String)->Rss{
      self.link = link
      return self
   }
   
   public func getTitle ()->String?{
      return title
   }
   
   public func getThumb ()->String?{
      return thumb
   }
   
   public func getLink ()->String?{
      return link
   }
   
   
}
