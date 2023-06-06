//
//  CardView.swift
//  WordsLearning
//
//  Created by Iosif Dubikovski on 5/31/23.
//
import UIKit

class CardView: UIView {
    
    var frontView: UIView!
    var backView: UIView!
    var isFlipped = false
    var originalCenter: CGPoint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupGestures()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
        setupGestures()
    }
    
    private func setupViews() {
        // frontView
        frontView = UIView(frame: bounds)
        // Настройка вида лицевой стороны
        // Добавление нужных элементов, например, текст, изображение, кнопки и т.д.
        
        // Добавление UIImageView для изображения на верхней стороне
        let frontImageView = UIImageView(frame: frontView.bounds)
        frontImageView.image = UIImage(named: "impostor")
        frontImageView.contentMode = .scaleAspectFit
        frontView.addSubview(frontImageView)
        
        // backView
        backView = UIView(frame: bounds)
        // Настройка вида обратной стороны
        
        // Добавление нужных элементов, например, текст, изображение, кнопки и т.д.
        let label = UILabel(frame: backView.bounds)
        label.text = "Imposter"
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.textAlignment = .center
        label.numberOfLines = 0
        backView.addSubview(label)
        
        // Добавление frontView и backView в CardView
        addSubview(frontView)
        addSubview(backView)
        
        // Поворот backView на 180 градусов
        backView.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2)
        
        // Скрытие backView, чтобы она была видна только после переворота
        backView.isHidden = true
    }

    private func setupGestures() {
        // Добавление жеста нажатия на CardView
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(flipCard))
        addGestureRecognizer(tapGesture)
        
        // Добавление жеста свайпа на CardView
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
    }
    
    @objc private func flipCard() {
        // Анимация переворота карточки
        
        // Определение направления анимации на основе текущего состояния карточки
        let transitionOptions: UIView.AnimationOptions = isFlipped ? .transitionFlipFromRight : .transitionFlipFromLeft
        
        // Переворачивание карточки с анимацией
        UIView.transition(with: self, duration: 0.5, options: transitionOptions, animations: { [weak self] in
            if let strongSelf = self {
                strongSelf.frontView.isHidden = !strongSelf.isFlipped
                strongSelf.backView.isHidden = strongSelf.isFlipped
            }
        }) { [weak self] _ in
            self?.isFlipped.toggle()
        }
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        
        switch gesture.state {
        case .began:
            // Сохранение исходной позиции центра карточки
            originalCenter = center
        case .changed:
            // Перемещение карточки согласно жесту свайпа
            center = CGPoint(x: originalCenter.x + translation.x, y: originalCenter.y + translation.y)
            // Вращение и масштабирование карточки на основе позиции свайпа
            let rotationStrength = min(translation.x / bounds.width, 1)
            let rotationAngle = CGFloat.pi / 8 * rotationStrength
            let scaleStrength = 1 - abs(rotationStrength) / 4
            let scale = max(scaleStrength, 0.93)
            transform = CGAffineTransform(rotationAngle: rotationAngle).scaledBy(x: scale, y: scale)
        case .ended:
            // Определение направления свайпа
            if translation.x < -100 {
                // Смахивание карточки влево
                animateOffScreen(direction: .left)
            } else if translation.x > 100 {
                // Смахивание карточки вправо
                animateOffScreen(direction: .right)
            } else {
                // Возвращение карточки на исходную позицию
                returnToOriginalPosition()
            }
        default:
            break
        }
    }
    
    private func animateOffScreen(direction: UISwipeGestureRecognizer.Direction) {
        let screenWidth = UIScreen.main.bounds.width
        //let screenHeight = UIScreen.main.bounds.height
        var destination: CGPoint = .zero
        
        switch direction {
        case .left:
            destination = CGPoint(x: -screenWidth, y: center.y)
        case .right:
            destination = CGPoint(x: screenWidth * 2, y: center.y)
        default:
            break
        }
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.center = destination
            self?.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
        }, completion: { [weak self] _ in
            self?.returnToOriginalPosition()
        })
    }
    
    private func returnToOriginalPosition() {
        UIView.animate(withDuration: 0) { [weak self] in
            self?.center = self?.originalCenter ?? CGPoint.zero
            self?.transform = CGAffineTransform.identity
        }
    }
}


