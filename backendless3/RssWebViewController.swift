import Foundation

class RssWebViewController : UIViewController {
   var link: String = ""
   
   @IBOutlet weak var webView: UIWebView!
   
   func setLink(link: String){
      self.link = link
   }
   
   override func viewDidLoad() {
      let url=URL(string: link)!;
      webView.loadRequest(URLRequest(url: url));
   }

   @IBAction func onClickClose(_ sender: UIButton) {
      dismiss(animated: true, completion: nil)
   }
}
