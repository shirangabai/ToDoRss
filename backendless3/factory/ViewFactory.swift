import Foundation

class ViewFactory {
   public func create(type:String)->DynamicView?{
      switch (type.lowercased()){
      case "label","uilabel","duilabel"    : return DynamicUILabel()
      case "button","uibutton","duibutton" : return DynamicUIButton()
      default                              : return nil
      }
   }
}
