import Foundation

class ViewFactory {
   public func create(type:String)->dView?{
      switch (type.lowercased()){
      case "label","uilabel","duilabel"    : return dUILabel()
      case "button","uibutton","duibutton" : return dUIButton()
      default                              : return nil
      }
   }
}
