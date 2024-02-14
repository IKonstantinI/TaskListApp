//
//  ViewController.swift
//  TaskListApp
//
//  Created by horze on 11.02.2024.
//

import UIKit

final class TaskListViewController: UITableViewController {
    
    private var taskList: [ToDoTask] = []
    private let cellID = "Task"
    
    private lazy var storageManager = StorageManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        fetchData()
    }
    
    private func fetchData() {
        taskList = storageManager.fetchEntities(ofType: ToDoTask.self)
    }
    
    @objc private func addNewTask() {
        let alert = UIAlertController(title: "Новая задача", message: "Что вы хотите сделать?", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Сохранить задачу", style: .default) { [weak self] _ in
            guard let taskName = alert.textFields?.first?.text, !taskName.isEmpty else { return }
            self?.save(taskName)
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .destructive)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField { textField in
            textField.placeholder = "Новая задача"
        }
        present(alert, animated: true)
    }
    
    private func save(_ taskName: String) {
        let task = ToDoTask(context: storageManager.persistentContainer.viewContext)
        task.title = taskName
        taskList.insert(task, at: taskList.count)
        
        storageManager.saveContext()
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Task", for: indexPath)
        let task = taskList[indexPath.row]
        cell.textLabel?.text = task.title
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = taskList[indexPath.row]
        let alert = UIAlertController(title: "Редактировать задачу", message: "Новая задача", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Сохранить задачу", style: .default) { [weak self] _ in
            guard let taskName = alert.textFields?.first?.text, !taskName.isEmpty else { return }
            task.title = taskName
            
            self?.storageManager.saveContext()
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .destructive)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField { textField in
            textField.placeholder = "Новая задача"
            textField.text = task.title
        }
        present(alert, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = taskList[indexPath.row]
            storageManager.deleteEntity(task)
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
}


// MARK: - Setup UI
private extension TaskListViewController {
    func setupNavigationBar() {
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = true
        // Navigation bar appearance
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        
        navBarAppearance.backgroundColor = .milkBlue
        
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        //Add button to navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewTask)
        )
        navigationController?.navigationBar.tintColor = .white
    }
}


