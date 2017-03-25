import Foundation

class MyXMLParser : XMLParser, XMLParserDelegate{
   private var isItem = false
   private var isTitle = false
   private var isDesc = false
   private var isLink = false
   private var rssList : [Rss] = []
   private var rss = Rss()
   
   init(data: Data , tag: String) {
      super.init(data: data)
      self.delegate = self
   }
   
   func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
      switch elementName {
      case "item":
         rss = Rss()
         isItem = true
      case "title":
         isTitle = true
      case "description":
         isDesc = true
      case "link":
         isLink = true
      default: break
      }
   }
   
   func parser(_ parser: XMLParser, foundCharacters content: String) {
      if isItem {
         if isTitle {
            rss.setTitle(title: content)
         }else if isDesc {
            let startIndex = 10
            let endIndex = content.indexOf(target: ".gif")! + 4
            
            rss.setThumb(thumb: "\(content.substring(with: startIndex..<endIndex))")
         }else if isLink {
            rss.setLink(link: content)
         }
      }
   }
   
   
   func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
      switch elementName {
      case "item":
         rssList.append(rss)
         isItem = false
      case "title":
         isTitle = false
      case "description":
         isDesc = false
      case "link":
         isLink = false
      default: break
      }
   }
   
   func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
      print("Failed to parse your XML");
   }
   
   func getRssList()->[Rss]{
      return rssList
   }
}






