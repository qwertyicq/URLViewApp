//
//  ViewController.swift
//  URLViewApp
//
//  Created by Nikolay T on 17.10.2021.
//

import UIKit

struct serverResponce: Decodable {
    let postId: Int
    let id: Int
    let name: String
    let email: String
    let body: String
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var topView = UIView()
    var btnRequest = UIButton()
    var topLabel = UILabel()
    var textField = UITextField()
    var tableView = UITableView()
    let identifier = "Cell"
    
    var array: [serverResponce] = [serverResponce]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var isReaded: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        createView()
        setConstraintTopView()
        
        createTextField()
        setConstraintTextField()
        
        createButton()
        setConstraintButton()
        
        createTable()
        setConstraintTableView()
    }
    
    //MARK - Функции создания интерфейса
    func createView() {
        self.topView = UIView(frame: CGRect(x: self.view.frame.minX, y: self.view.frame.minY, width: self.view.frame.width, height: 50.0))
        self.topView.backgroundColor = .systemGray5
        self.topView.layer.cornerRadius = self.topView.frame.width / 40
        self.topView.layer.borderColor = CGColor.init(red: 1.0, green: 0.5, blue: 0.5, alpha: 1.0)
        self.topView.layer.borderWidth = 2
        self.topView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.topView)
    }
    
    func createLabel() {
        self.topLabel = UILabel(frame: self.topView.frame)
        self.topLabel.text = "Load data App"
        self.topLabel.textColor = .black
        self.topLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.topView.addSubview(self.topLabel)
    }
    
    func createTextField() {
        self.textField = UITextField(frame: self.topView.frame)
        self.textField.placeholder = "  Input id number..."
        self.textField.backgroundColor = .white
        
        self.textField.translatesAutoresizingMaskIntoConstraints = false
        
        self.topView.addSubview(self.textField)
    }
    
    func createButton() {
        self.btnRequest = UIButton(frame: CGRect(x: self.view.frame.minX, y: self.view.frame.minY, width: 50.0, height: 50.0))
        self.btnRequest.setImage(.checkmark, for: .normal)
        self.btnRequest.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        self.btnRequest.translatesAutoresizingMaskIntoConstraints = false
        
        self.topView.addSubview(self.btnRequest)
    }
    
    @objc func buttonAction (sender:UIButton!) {
        let url: URL?
        
        if self.isReaded {
            self.array.removeAll()
        }
        
        if self.textField.text != "" {
            url = URL(string: "https://jsonplaceholder.typicode.com/comments?postId=\(self.textField.text!)")
            getPosts(url)
        } else {
            url = URL(string: "https://jsonplaceholder.typicode.com/comments")
            getPosts(url)
        }
    }
    
    func createTable() {
        self.tableView = UITableView(frame: view.bounds, style: .plain)
        self.tableView.backgroundColor = .white
        self.tableView.separatorColor = .black
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(self.tableView)
    }
    
    //MARK - Функции расстановки ограничений
    func setConstraintTopView() {
        NSLayoutConstraint.init(item: self.topView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .topMargin, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint.init(item: self.topView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint.init(item: self.topView, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.10, constant: 0).isActive = true
        NSLayoutConstraint.init(item: self.topView, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1, constant: 0).isActive = true
    }
    
    func setLabelConstraint() {
        NSLayoutConstraint.init(item: self.topLabel, attribute: .leading, relatedBy: .equal, toItem: self.topView, attribute: .leadingMargin, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint.init(item: self.topLabel, attribute: .centerY, relatedBy: .equal, toItem: self.topView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
    }
    
    func setConstraintTextField() {
        NSLayoutConstraint.init(item: self.textField, attribute: .leading, relatedBy: .equal, toItem: self.topView, attribute: .leadingMargin, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint.init(item: self.textField, attribute: .centerY, relatedBy: .equal, toItem: self.topView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint.init(item: self.textField, attribute: .width, relatedBy: .equal, toItem: self.topView, attribute: .width, multiplier: 0.5, constant: 0).isActive = true
        NSLayoutConstraint.init(item: self.textField, attribute: .height, relatedBy: .equal, toItem: self.topView, attribute: .height, multiplier: 0.5, constant: 0).isActive = true
    }
    
    func setConstraintButton() {
        NSLayoutConstraint.init(item: self.btnRequest, attribute: .trailing, relatedBy: .equal, toItem: self.topView, attribute: .trailingMargin, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint.init(item: self.btnRequest, attribute: .height, relatedBy: .equal, toItem: self.topView, attribute: .height, multiplier: 0.8, constant: 0).isActive = true
        NSLayoutConstraint.init(item: self.btnRequest, attribute: .width, relatedBy: .equal, toItem: self.btnRequest, attribute: .height, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint.init(item: self.btnRequest, attribute: .centerY, relatedBy: .equal, toItem: self.topView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
    }
    
    func setConstraintTableView() {
        NSLayoutConstraint.init(item: self.tableView, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint.init(item: self.tableView, attribute: .top, relatedBy: .equal, toItem: self.topView, attribute: .bottomMargin, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint.init(item: self.tableView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottomMargin, multiplier: 1, constant: 0).isActive = true
    }
    
    //MARK - Делегаты UITableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        cell.backgroundColor = .white
        
        cell.textLabel?.numberOfLines = 40
        cell.textLabel?.text = "PostID: \(array[indexPath.item].postId)\r\nID: \(array[indexPath.item].id)\nName: \(array[indexPath.item].name)\nEmail: \(array[indexPath.item].email)\nBody: \(array[indexPath.item].body)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250.0
    }
    
    func getPosts (_ url: URL?) {
        guard let unwrapedURL = url else { return }
        
        var request = URLRequest(url: unwrapedURL)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let loadTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            
            if (response as? HTTPURLResponse)?.statusCode == 200 {
                do {
                    let parsedJSON = try JSONDecoder().decode([serverResponce].self, from: data)
                    for item in parsedJSON {
                        self.array.append(item)
                    }
                    self.isReaded = true
                } catch {
                    print(error)
                }
            } else {
                if error != nil {
                    return
                } else {
                    print("Ошибка выполнения запроса")
                }
            }
        }
        loadTask.resume()
    }
}

