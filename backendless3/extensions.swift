//import Foundation

extension String
{
   func trim() -> String
   {
      return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
   }

   var length:Int {
      return self.characters.count
   }
   
   func indexOf(target: String) -> Int? {
      let range = (self as NSString).range(of: target)
      guard range.toRange() != nil else {
         return nil
      }
      return range.location
   }
   
   func lastIndexOf(target: String) -> Int? {
      let range = (self as NSString).range(of: target, options: NSString.CompareOptions.backwards)
      guard range.toRange() != nil else {
         return nil
      }
      return self.length - range.location - 1
   }
   
   func contains(s: String) -> Bool {
      return (self.range(of: s) != nil) ? true : false
   }
   
   func index(from: Int) -> Index {
      return self.index(startIndex, offsetBy: from)
   }
   
   
   func substring(from: Int) -> String {
      let fromIndex = index(from: from)
      return substring(from: fromIndex)
   }
   
   func substring(to: Int) -> String {
      let toIndex = index(from: to)
      return substring(to: toIndex)
   }
   
   func substring(with r: Range<Int>) -> String {
      let startIndex = index(from: r.lowerBound)
      let endIndex = index(from: r.upperBound)
      return substring(with: startIndex..<endIndex)
   }
   
}

extension UIButton {
   func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
      contentMode = mode
      URLSession.shared.dataTask(with: url) { (data, response, error) in
         guard
            let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
            let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
            let data = data, error == nil,
            let image = UIImage(data: data)
            else { return }
         DispatchQueue.main.async() { () -> Void in
            self.setImage(image, for: .normal)          }
         }.resume()
   }
   func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
      guard let url = URL(string: link) else { return }
      downloadedFrom(url: url, contentMode: mode)
   }
}

