//
//  ViewController.swift
//  ColourfulBall
//
//  Created by Lucas Valle on 02/10/17.
//  Copyright © 2017 Lucas Valle. All rights reserved.
//

import ChameleonFramework
import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    var circleView: UIView!
    let disposeBag = DisposeBag()
    
    //MARK: IBOutlets

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Private
    
    func setup() {
        // Add circle view
        circleView = UIView(frame: CGRect(origin: view.center, size: CGSize(width: 100.0, height: 100.0)))
        circleView.layer.cornerRadius = circleView.frame.width / 2.0
        circleView.center = view.center
        circleView.backgroundColor = .green
        view.addSubview(circleView)
        
        let circleViewModel = CircleViewModel()
        // Bind the center point of the CircleView to the centerObservable
        circleView
            .rx.observe(CGPoint.self, "center")
            .bind(to: circleViewModel.centerVariable)
            .addDisposableTo(disposeBag)
        
        // Subscribe to backgroundObservable to get new colors from the ViewModel.
        circleViewModel.backgroundColorObservable
            .subscribe(onNext: { [weak self] backgroundColor in
                UIView.animate(withDuration: 0.1, animations: {
                    self?.circleView.backgroundColor = backgroundColor
                    // Try to get complementary color for given background color
                    let viewBackgroundColor = UIColor(complementaryFlatColorOf: backgroundColor)
                    // If it is different that the color
                    if viewBackgroundColor != backgroundColor {
                        // Assign it as a background color of the view
                        // We only want different color to be able to see that circle in a view
                        self?.view.backgroundColor = viewBackgroundColor
                    }
                })
            })
            .addDisposableTo(disposeBag)
        
        // Add gesture recognizer
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(circleMoved(_:)))
        circleView.addGestureRecognizer(gestureRecognizer)
    }
    
    func circleMoved(_ recognizer: UIPanGestureRecognizer) {
        let location = recognizer.location(in: view)
        UIView.animate(withDuration: 0.1, animations: {
            self.circleView.center = location
        })
    }


}

