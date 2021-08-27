//
//  TimerViewController.swift
//  Timer
//
//  Created by Eʟᴅᴀʀ Tᴇɴɢɪᴢᴏᴠ on 25.08.2021.
//

import UIKit

class TimerViewController: UIViewController {
    
    var timer: Timer?
    
    var timers = [TimerModel]() {
        didSet {
            timers.sort(by: >)
            tableView.reloadData()
        }
    }
    
    let addNewTimerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Добавление таймеров"
        label.textColor = .secondaryLabel
        return label
    }()
    
    let footerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 1))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        view.backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        return view
    }()
    
    let secondFooterView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 1))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        view.backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        return view
    }()
    
    let nameTimerTF: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Название таймера"
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    let timerSecondsTF: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Время в секундах"
        tf.borderStyle = .roundedRect
        tf.keyboardType = .numberPad
        return tf
    }()
    
    let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Добавить", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 0.7001746601)
        button.layer.cornerRadius = 13
        return button
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Мультитаймер"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TimerListCell.self, forCellReuseIdentifier: TimerListCell.identifier)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        setupUI()
    }
    
    
    private func setupUI() {
        view.addSubview(addButton)
        view.addSubview(addNewTimerLabel)
        view.addSubview(tableView)
        view.addSubview(nameTimerTF)
        view.addSubview(footerView)
        view.addSubview(timerSecondsTF)
        
        NSLayoutConstraint.activate([
            addNewTimerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            addNewTimerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addNewTimerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20),
        ])
        
        NSLayoutConstraint.activate([
            footerView.topAnchor.constraint(equalTo: addNewTimerLabel.bottomAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            nameTimerTF.topAnchor.constraint(equalTo: addNewTimerLabel.bottomAnchor, constant: 25),
            nameTimerTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameTimerTF.widthAnchor.constraint(equalToConstant: 250)
        ])
        
        NSLayoutConstraint.activate([
            timerSecondsTF.topAnchor.constraint(equalTo: nameTimerTF.bottomAnchor, constant: 20),
            timerSecondsTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            timerSecondsTF.widthAnchor.constraint(equalToConstant: 250)
        ])
        
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: timerSecondsTF.bottomAnchor, constant: 25),
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 40),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc func updateIfNeeded() {
        guard let rows = tableView.indexPathsForVisibleRows else { return }
        
        for task in timers { task.timeCount -= 1 }
        
        for index in rows {
            
            guard let cell = tableView.cellForRow(at: index) as? TimerListCell else { return }
            
            cell.updateSeconds()
            
            if timers[index.row].finish {
                timers.remove(at: index.row)
            } else if timers.count == 0 {
                stopTimer()
            }
        }
    }
    
    @objc func addButtonTapped() {
        guard let name = nameTimerTF.text else { return }
        guard let currentTime = timerSecondsTF.text else { return }
        
        guard name.count > 0 else {
            showAlert(title: "Ошибка ввода", message: "Пожалуйста, введите название таймера")
            return
        }
        
        guard let timeSec = Int(currentTime) else {
            showAlert(title: "Ошибка ввода", message: "Пожалуйста, введите корректное время")
            timerSecondsTF.text = ""
            return
        }
        guard timeSec <= 86400 else {
            showAlert(title: "Ошибка ввода", message: "Пожалуйста, введите время не превышающее сутки")
            timerSecondsTF.text = ""
            return
        }
        nameTimerTF.text = ""
        timerSecondsTF.text = ""
        
        let task = TimerModel(name: name, timeCount: timeSec)
        self.timers.append(task)
        
        newTimerStart()
        view.endEditing(true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    private func newTimerStart() {
        if timer == nil {
            let newTimer = Timer(timeInterval: 1, target: self, selector: #selector(updateIfNeeded), userInfo: nil, repeats: true)
            self.timer = newTimer
            RunLoop.current.add(newTimer, forMode: .default)
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

extension TimerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TimerListCell.identifier, for: indexPath) as! TimerListCell
        
        cell.currentTimer = timers[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 30))
        returnedView.backgroundColor = .white
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
        label.text = "Таймеры"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        returnedView.addSubview(label)
        returnedView.addSubview(secondFooterView)
        
        label.leadingAnchor.constraint(equalTo: returnedView.leadingAnchor, constant: 19).isActive = true
        secondFooterView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10).isActive = true
        
        return returnedView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

//MARK: Setup Canvas
import SwiftUI

struct MainProvider: PreviewProvider {
    static var previews: some View {
        ContainerView()
            .edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            UINavigationController(rootViewController: TimerViewController())
        }
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
