//
//  ViewController.swift
//  WordsLearning
//
//  Created by Iosif Dubikovski on 5/31/23.
//
import UIKit

class ViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Создание экземпляра CardView
        let firstCardView = CardView(frame: CGRect(x: 0, y: 0, width: 300, height: 500))
        firstCardView.center = view.center
        firstCardView.backgroundColor = .green
        firstCardView.layer.cornerRadius = 25
        firstCardView.
        // Настройка вида контроллера
        view.backgroundColor = UIColor.white
        
        // Добавление CardView в контроллер
        view.addSubview(firstCardView)
        
        // Создание экземпляра CardView
        let secondCardView = CardView(frame: CGRect(x: 0, y: 0, width: 300, height: 500))
        secondCardView.center = view.center
        secondCardView.backgroundColor = .green
        secondCardView.layer.cornerRadius = 25
        // Настройка вида контроллера
        view.backgroundColor = UIColor.white
        
        // Добавление CardView в контроллер
        view.addSubview(secondCardView)
        
        
    }

    
}
