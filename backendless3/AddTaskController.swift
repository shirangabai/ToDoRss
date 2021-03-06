import UIKit

class AddTaskController : UIViewController{
   var tasks : [Task] = []
   var parentController : SecondController?
   
   @IBOutlet var txtInputAddTask: UITextField!
   @IBOutlet weak var segPriority: UISegmentedControl!
   @IBOutlet weak var imgPriority1: UIImageView!
   @IBOutlet weak var imgPriority2: UIImageView!
   
   public func setBackendless(parentController : SecondController){
      self.parentController = parentController
   }
   
   @IBAction func onClickOKAddTask(_ sender: UIButton) {
      
      let task = txtInputAddTask.text!.trim()
      if task.isEmpty {return}
      let priority = segPriority.selectedSegmentIndex
      addTask(newTask: task, priority: priority )
   }
   
   @IBAction func onCliclCancel(_ sender: UIButton) {
      dismiss(animated: true, completion: nil)
   }
   
   @IBAction func onChangeValueSegment(_ sender: UISegmentedControl) {
      imgPriority1.image = UIImage(named: "Priority\(sender.selectedSegmentIndex)")
      imgPriority2.image = UIImage(named: "Priority\(sender.selectedSegmentIndex)")
   }
   
   
   //-------------- backendless -----------------------------------
   func addTask(newTask: String , priority : Int) {
      let task = Task()
      task.task = newTask
      task.priority = priority
      
      let dataStore = parentController!.backendless.data.of(Task.ofClass())
      
      dataStore?.save(task, response: { (result: Any!) -> Void in
         let obj = result as! Task
         print("Contact has been saved: \(obj.objectId)")
         self.parentController?.loadTasks()

         self.dismiss(animated: true, completion: nil)
      },error: { (fault: Fault?) -> Void in
         print("fServer reported an error: \(fault)")
      })
   }

   
   
}
