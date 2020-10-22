//
//  TaskViewController.swift
//  Agenda
//
//  Created by KMMX on 21/10/20.
//

import UIKit

class TaskViewController: UITableViewController {
    // MARK: - Instance var Cell
    var cells:[UITableViewCell] = []
    var taskHelper:TaskHelper! {
        didSet{
            taskHelper.tasks = TasksUtility.fetch() ?? [[Task](),[Task]()]
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        if #available(iOS 13.0, *) {
            let navBarApperance = UINavigationBarAppearance()
            navBarApperance.configureWithTransparentBackground()
            navBarApperance.backgroundColor = UIColor(displayP3Red: 38/255, green: 166/255, blue: 211/255, alpha: 1)
            navBarApperance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            navBarApperance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            
            
            navigationController?.navigationBar.standardAppearance = navBarApperance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarApperance
            navigationController?.navigationBar.isTranslucent = true
            navigationController?.navigationBar.backgroundColor = UIColor.clear
        }
        cellSetup()
        tableViewSetUp()
    }
    
    func cellSetup() {
        /*for _ in 0...10 {
            let cell = UITableViewCell()
            cell.textLabel?.text = "Bad way!"
            cells.append(cell)
        }*/
        let todoTask = [Task(name: "Estudiar"),Task(name: "Ir de compras"), Task(name: "Gimnasio")]
        let doneTask = [Task(name: "Recoger hijo", isDone: true)]
        taskHelper.tasks = [todoTask,doneTask]
    }
    
    func tableViewSetUp(){
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 350
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return taskHelper.tasks.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return taskHelper.tasks[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = taskHelper.tasks[indexPath.section][indexPath.row].name
        //cell.textLabel?.text = "Wow much better!"
        // Configure the cell...

        return cell
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "To-do" : "Done"
    }
    // MARK: ibActions

    @IBAction func addTaskBtn(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Nueva Tarea", message: nil, preferredStyle: .alert)

        

        //Set up the acitons
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            //get text from text field's input
            guard let textField = alert.textFields?.first?.text else {return}
            let newTask = Task(name: textField)
            let indexPath = IndexPath(row:0,section:0)
            self.taskHelper.add(newTask, at: 0)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
        }
        //Disable by default
        addAction.isEnabled = false
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        //Add the textField
        alert.addTextField{ textField in
            textField.placeholder = "Enter the task name..."
            textField.addTarget(self, action: #selector(self.handleTextChanged), for: .editingChanged)
        }
        //Add  tghe actions
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    @objc private func handleTextChanged(_ sender: UITextField){
        /*
         Aqui llegamos porque se configuro que alguien responda a los eventos
         pero debemos obtener a la alerta para que de ahi conseguir la accion
         llamamos a alertController.actions.first porque en la alerta primero insertamos la aacion Add
         */
        guard let alertController = presentedViewController as? UIAlertController,
              let addAction = alertController.actions.first,
              let text = sender.text
        else {return}
        
        /*
         ninguna variable hace falta, ya que podemos continuar
         habilitar / deshabilitar el boton si el texto esta vacio
         es un trim al inicio y final del string, y comprobamos si esta o no vacio
         */
        addAction.isEnabled = !text.trimmingCharacters(in: .whitespaces).isEmpty
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
// MARK: Delegate
extension TaskViewController{
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil){ (action, sourceView, completionHandler) in
            guard let isDone =  self.taskHelper.tasks[indexPath.section][indexPath.row].isDone
            else { return }
            let _ = self.taskHelper.remove(at: indexPath.row, isDone: isDone)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        deleteAction.image = #imageLiteral(resourceName: "delete")
        deleteAction.backgroundColor = #colorLiteral(red: 0.8454501671, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let doneAction = UIContextualAction(style: .normal, title: nil){(action, sourceView, completionHandler) in
            //toggle that the task is done
            //only in the first or cero section the user can complete a task
            self.taskHelper.tasks[0][indexPath.row].isDone = true
            //remove the task from array containing todo tasks
            let doneTask = self.taskHelper.remove(at: indexPath.row)
            // reload table view
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.taskHelper.add(doneTask, at : 0 , isDone:true)
            //reload table view
            tableView.insertRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
            completionHandler(true)
        }
        doneAction.image = #imageLiteral(resourceName: "done")
        doneAction.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        
        return indexPath.section == 0 ? UISwipeActionsConfiguration(actions: [doneAction]) : nil
    }
}
