import Foundation

class SecondController : UIViewController , UITableViewDelegate , UITableViewDataSource {
   
   var backendless : Backendless!
   var tasks : [Task] = []
   var sort = "created DESC"
   
   @IBOutlet weak var tvTasks: UITableView!
   
   @IBOutlet weak var btnSort0: UIButton!
   @IBOutlet weak var btnSort1: UIButton!
   @IBOutlet weak var btnSort2: UIButton!
   @IBOutlet weak var scrollView: UIScrollView!
   
   var rssList : [Rss] = []
   
   
   public func setBackendless(backendless : Backendless){
      self.backendless = backendless
   }
   
   override func viewDidLoad() {
      print(backendless.userService.currentUser.email)
      print(backendless.userService.currentUser.objectId)
      loadTasks()
      parseXML()
   }
   
   func parseXML(){
      let session = URLSession.shared
      let baseUrl="http://one.co.il/RSS"
      let url=URL(string: baseUrl)!
      
      session.dataTask(with: url, completionHandler: {(d,r,e) in
         let entryParser = MyXMLParser(data: d!,tag: "item")
         entryParser.parse()
         self.rssList = entryParser.getRssList()
         
         DispatchQueue.main.async(execute: {
            self.loadRssToScroll()
         })
      }).resume()
   }
   
   func loadRssToScroll(){
      let factory = ViewFactory()
      scrollView.frame.size.width = view.frame.width
      scrollView.contentSize.width = scrollView.frame.width * CGFloat(rssList.count)
      
      for i in 0..<rssList.count{
         let lbl = factory.create(type: "label")
         lbl?.setProperties(xPosition: scrollView.frame.width * CGFloat(i) + 90,width: scrollView.frame.width, title: rssList[i].getTitle()!)
         scrollView.addSubview(lbl as! UIView)
         
         let btn = factory.create(type: "button")
         (btn as! UIButton).addTarget(self, action: #selector(onClick) , for: .touchUpInside)
         btn?.setProperties(xPosition: scrollView.frame.width * CGFloat(i) + 10, width: 70, link: rssList[i].getThumb()!,tag:i)
         scrollView.addSubview(btn as! UIView)
      }
   }
      
   func onClick(btn:UIButton){
      let next=storyboard!.instantiateViewController(withIdentifier: "id_rss_webview_controller")
      (next as! RssWebViewController).setLink(link: rssList[btn.tag].getLink()!)
      show(next, sender: self)
   }
   
   
   @IBAction func onClickLogout(_ sender: UIButton) {
      logoutUserAsync()
      dismiss(animated: true, completion: nil)
   }
   
   @IBAction func onClickAddTask(_ sender: UIButton) {
      toAddTaskViewController()
   }
   
   func toAddTaskViewController() {
      let next=storyboard!.instantiateViewController(withIdentifier: "id_add_task_controller")
      (next as! AddTaskController).setBackendless(parentController: self)
      show(next, sender: self)
   }
   
   @IBAction func onCkickSort(_ sender: UIButton) {
      btnSort0.setImage(#imageLiteral(resourceName: "sortDisable"), for: .normal )
      btnSort1.setImage(#imageLiteral(resourceName: "sortDisable"), for: .normal )
      btnSort2.setImage(#imageLiteral(resourceName: "sortDisable"), for: .normal )
      
      func checkSort(category:String){
         if sort == "\(category) DESC"{
            sort = "\(category)"
            sender.setImage(#imageLiteral(resourceName: "sortUp"), for: .normal)
         }else{
            sort = "\(category) DESC"
            sender.setImage(#imageLiteral(resourceName: "sortDown"), for: .normal )
         }
      }
      
      switch sender.tag {
      case 0:
         checkSort(category: "priority")
      case 1:
         checkSort(category: "created")
      case 2:
         checkSort(category: "doneB")
      default: break
      }
      
      loadTasks()
      print (sort)
      
   }
   
   //------------ table view ----------------------------
   public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return tasks.count
   }
   
   public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TaskCellController
      
      cell.lblTask.text = tasks[indexPath.row].task
      cell.lblCreated.text = U.dateFormat(date: tasks[indexPath.row].created!)
      cell.img.image = UIImage(named: "Priority\(tasks[indexPath.row].priority)")
      cell.switchDone.isOn = tasks[indexPath.row].doneB
      cell.task = tasks[indexPath.row]
      cell.backendless = backendless
      return cell
   }
   
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 100
   }
   
   func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle==UITableViewCellEditingStyle.delete {
         removeTask(index: indexPath.row)
         tvTasks.reloadData()
      }
   }
   
   func removeTask (index: Int){
      deleteTaskAsync(task: tasks[index])
      tasks.remove(at: index)
      
   }
   
   //-------------- backendless -----------------------------------
   
   func logoutUserAsync() {
      backendless.userService.logout({( user : Any?) -> () in
         print("User logged out.")
      },error: { ( fault : Fault?) -> () in
         print("Server reported an error: \(fault!)")
      })
   }
   
   
   func loadTasks(){
      let queryOptions = QueryOptions()
      //queryOptions.sortBy = ["created DESC"]
      queryOptions.sortBy = [sort]
      
      
      
      
      
      let whereClause = "ownerId = '\(backendless.userService.currentUser.objectId!)'"
      let dataQuery = BackendlessDataQuery()
      dataQuery.whereClause = whereClause
      
      dataQuery.queryOptions = queryOptions
      
      
      let dataStore = backendless.data.of(Task.ofClass())!
      dataStore.find(dataQuery, response: {(result: BackendlessCollection?)->Void in
         self.tasks = result!.getCurrentPage()! as! [Task]
         self.tvTasks.reloadData()
      },error: { (fault: Fault?) -> Void in
         print("\n\nServer reported an error: \(fault)")
      })
   }
   
   
   func deleteTaskAsync(task: Task) {
      let dataStore = backendless.data.of(Task.ofClass())
      
      dataStore?.remove( task , response: { (result: Any?) -> Void in
         print("Task has been deleted: \(result)")
      },error: { (fault: Fault?) -> Void in
         print("Server reported an del error: \(fault)")
      })
      
   }
   
   //--------------------------
}


