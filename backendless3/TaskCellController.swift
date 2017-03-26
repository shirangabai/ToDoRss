import UIKit

class TaskCellController: UITableViewCell {
   
   @IBOutlet weak var img: UIImageView!
   @IBOutlet weak var lblTask: UILabel!
   @IBOutlet weak var switchDone: UISwitch!
   @IBOutlet weak var lblCreated: UILabel!
   
   var task : Task?
   var backendless : Backendless!
   
   override func awakeFromNib() {
      super.awakeFromNib()
   }
   
   override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)
   }
   
   @IBAction func onValueChangeDone(_ sender: UISwitch) {
      task?.doneB = sender.isOn
      updateTask()
   }
   
   func updateTask() {
      let dataStore = backendless.data.of(Task.ofClass())
      
      dataStore?.save(task, response: { (result: Any!) -> Void in
         print ("update row")
      },error: { (fault: Fault?) -> Void in
         print("fServer reported an error: \(fault)")
      })
   }
   
   
   
}
