//
//  ViewController.swift
//  IT21041648
//
//  Created by Isuru Herath on 2024-04-19.
//

import UIKit



class ViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {



    let context = ( UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext
    
    let tableview: UITableView = {
        let table = UITableView()
        
        table.register(UITableViewCell.self, forCellReuseIdentifier:"Cell" )
        table.register(CheckboxTableViewCell.self, forCellReuseIdentifier: "CheckboxCell")

        
        return table
    }()
    
        
    internal var models = [Device]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.addSubview(tableview)
        getAllItems()
        title = "Device Index"
        tableview.delegate = self
        tableview.dataSource = self
        tableview.frame = view.bounds
        
        // Add button
            let button = UIButton(type: .system)
            button.setTitle("Developer Info", for: .normal)
            button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(button)
              
        // Add constraints for the button
              NSLayoutConstraint.activate([
                  button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                  button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                  button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
              ])
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleCheckboxToggled), name: Notification.Name("CheckboxToggled"), object: nil)
    
    }
    
    
    @objc func didTapButton() {
            let secondVC = SecondViewController()
            navigationController?.pushViewController(secondVC, animated: true)
        }
    
    @objc private func didTapAdd() {
        let alert = UIAlertController(title: "New Item", message: "Enter device details", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Device Name"
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Description"
        }
        
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [weak self] _ in
            guard let fields = alert.textFields, fields.count == 2,
                  let name = fields[0].text, let desc = fields[1].text, !name.isEmpty else {
                return
            }
            
            self?.createItem(name: name, desc: desc)
        }))
        
        present(alert, animated: true, completion: nil)
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckboxCell", for: indexPath) as! CheckboxTableViewCell
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        let formattedDateString = dateFormatter.string(from: model.dateGiven ?? Date())
        
        let attributedString = NSMutableAttributedString()
        
        // Name in big text (bold)
        let nameAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 25)
        ]
        let nameString = NSAttributedString(string: "\(model.name ?? "")\n", attributes: nameAttributes)
        attributedString.append(nameString)
        
        // Description just like that
        let descriptionString = NSAttributedString(string: "\(model.issue ?? "")\n")
        attributedString.append(descriptionString)
        
        // Date in grey in a small text
        let dateAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor.gray
        ]
        let dateString = "Given on: \(formattedDateString)"
        let dateStringAttributed = NSAttributedString(string: dateString, attributes: dateAttributes)
        attributedString.append(dateStringAttributed)
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.attributedText = attributedString
        
        cell.checkbox.isOn = model.fixed
        cell.selectionStyle = .none
        
        return cell
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = models[indexPath.row]
        let sheet = UIAlertController(title: "Edit Item", message: nil, preferredStyle: .actionSheet)

        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel , handler: nil))
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive , handler: { [weak self] _ in
            self?.deleteItem(item: item)
        }))

        sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { [weak self] _ in
            let alert = UIAlertController(title: "Edit your Item", message: "Edit device details", preferredStyle: .alert)
            
            alert.addTextField { textField in
                textField.placeholder = "Device Name"
                textField.text = item.name
            }
            
            alert.addTextField { textField in
                textField.placeholder = "Description"
                textField.text = item.issue
            }

            alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self] _ in
                guard let fields = alert.textFields, fields.count == 2,
                      let name = fields[0].text, let desc = fields[1].text, !name.isEmpty else {
                    return
                }
                
                self?.updateItem(item: item, newname: name, newDesc: desc)

            }))
            
            self?.present(alert, animated: true, completion: nil)
        }))
        
        present(sheet, animated: true, completion: nil)
    }
    @objc func handleCheckboxToggled(notification: Notification) {
         guard let indexPath = notification.userInfo?["indexPath"] as? IndexPath else { return }
         models[indexPath.row].fixed.toggle()
     }
     
class CheckboxTableViewCell: UITableViewCell {
        var checkbox: UISwitch = {
            let checkbox = UISwitch()
            checkbox.translatesAutoresizingMaskIntoConstraints = false
            return checkbox
        }()
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            contentView.addSubview(checkbox)
            NSLayoutConstraint.activate([
                checkbox.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                checkbox.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
            ])
            
            checkbox.addTarget(self, action: #selector(checkboxToggled), for: .valueChanged)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        @objc func checkboxToggled() {
            guard let indexPath = getIndexPath() else { return }
            NotificationCenter.default.post(name: Notification.Name("CheckboxToggled"), object: nil, userInfo: ["indexPath": indexPath])
        }
        
        private func getIndexPath() -> IndexPath? {
            guard let tableView = superview as? UITableView, let indexPath = tableView.indexPath(for: self) else {
                return nil
            }
            return indexPath
        }
}

    
    class SecondViewController: UIViewController {
        override func viewDidLoad() {
            super.viewDidLoad()
            
            view.backgroundColor = .white
            
            // Logo Image View
            let logoImageView = UIImageView(image: UIImage(named: "logo"))
            logoImageView.translatesAutoresizingMaskIntoConstraints = false
            logoImageView.contentMode = .scaleAspectFit
            view.addSubview(logoImageView)
                    
            // App Name Label
            let appNameLabel = UILabel()
            appNameLabel.translatesAutoresizingMaskIntoConstraints = false
            appNameLabel.text = "App Name: DeviceIndex Device manager"
            appNameLabel.numberOfLines = 0
            view.addSubview(appNameLabel)
                    
            // Version Label
            let versionLabel = UILabel()
            versionLabel.translatesAutoresizingMaskIntoConstraints = false
            versionLabel.text = "Version: v.1.0.0"
            view.addSubview(versionLabel)
                    
            // Developer Name Label
            let developerNameLabel = UILabel()
            developerNameLabel.translatesAutoresizingMaskIntoConstraints = false
            developerNameLabel.text = "Developer Name: Isuru Herath"
            view.addSubview(developerNameLabel)
                    
            // IT Number Label
            let itNumberLabel = UILabel()
            itNumberLabel.translatesAutoresizingMaskIntoConstraints = false
            itNumberLabel.text = "IT Number: IT21041648"
            view.addSubview(itNumberLabel)
            
            // Build using Label
            let buildUsingLabel = UILabel()
            buildUsingLabel.translatesAutoresizingMaskIntoConstraints = false
            buildUsingLabel.text = "Built using: Swift Storyboard"
            view.addSubview(buildUsingLabel)
            
            // Add constraints for the UI elements
            NSLayoutConstraint.activate([
                logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                    logoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                    logoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                    logoImageView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 0.3), // Limit height to 30% of the screen height
                
                appNameLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
                appNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                appNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                
                versionLabel.topAnchor.constraint(equalTo: appNameLabel.bottomAnchor, constant: 10),
                versionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                
                developerNameLabel.topAnchor.constraint(equalTo: versionLabel.bottomAnchor, constant: 10),
                developerNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                
                itNumberLabel.topAnchor.constraint(equalTo: developerNameLabel.bottomAnchor, constant: 10),
                itNumberLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                
                buildUsingLabel.topAnchor.constraint(equalTo: itNumberLabel.bottomAnchor, constant: 10),
                buildUsingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            ])
            
            
            
            
        }
    }
    

    
    // Core data code
    
    
    func getAllItems () {
        
 
        
        do {
            models = try context.fetch(Device.fetchRequest())
            DispatchQueue.main.async {
                self.tableview.reloadData()
            }
       
        }
        catch {
            
//           print(error)
        }
        
    }
    
    func createItem ( name : String , desc : String ){
        
        let newItem = Device(context: context)
        
        newItem.name = name
        newItem.issue = desc
        newItem.fixed = false
        newItem.dateGiven = Date()
        
        
        do {
            try context.save()
            getAllItems()
        }
        catch {
            
           print(error)
        }
    }
    
    func deleteItem ( item : Device) {
        
        context.delete(item)
        
        do {
            try context.save()
            getAllItems()
        }
        catch {
            
//            print(error)
        }
        
    }
    
    func updateItem ( item : Device , newname : String ,  newDesc : String) {
        
        item.issue = newDesc
        item.name = newname
        
        do {
            try context.save()
            getAllItems()
        }
        catch {
            
//            print(error)
        }
        
    }


}

