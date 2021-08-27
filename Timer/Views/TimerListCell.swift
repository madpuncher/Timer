//
//  TimerListCell.swift
//  Timer
//
//  Created by Eʟᴅᴀʀ Tᴇɴɢɪᴢᴏᴠ on 25.08.2021.
//

import UIKit

class TimerListCell: UITableViewCell {
    
    static let identifier = "cell"
        
    let timerNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    
    let secondsCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        return label
    }()
    
    var currentTimer: TimerModel? {
        didSet {
            updateSeconds()
            timerNameLabel.text = currentTimer?.name
        }
    }
            
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(timerNameLabel)
        addSubview(secondsCountLabel)
        
        NSLayoutConstraint.activate([
            timerNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            timerNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        
        NSLayoutConstraint.activate([
            secondsCountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            secondsCountLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    func updateSeconds() {
        
        guard let currentTimer = currentTimer else { return }
        
        let timeCount = currentTimer.timeCount
        
        if timeCount <= 0 { currentTimer.finish = true; return }
        
        let hours = timeCount / 3600
        let minutes = timeCount / 60 % 60
        let seconds = timeCount % 60
        
        secondsCountLabel.text = String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
}

//MARK: Setup Canvas
import SwiftUI

struct CellProvider: PreviewProvider {
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
