//
//  ViewController.swift
//  AddOne
//
//  Created by Tran Minh Tuan on 12/14/17.
//  Copyright © 2017 Tran Minh Tuan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: Properties
    var randNum: UInt32 = 0
    var digit: [UInt32] = [0,0,0,0]
    var add_1: [UInt32] = [0,0,0,0]
    var result = false
    var count = 0
    
    var gameTimer: Timer?
    
    let countdownLabel: UILabel = {
        let lb = UILabel()
        lb.backgroundColor = UIColor.white
        lb.textColor = UIColor.black
        lb.textAlignment = .center
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    let randomNumberTextField: MyTextField = {
        let textfield = MyTextField()
        textfield.placeholder = "Random Number"
        textfield.textAlignment = .center
        return textfield
    }()
    
    var addOneNumberTextField: [MyTextField] = [MyTextField(), MyTextField(), MyTextField(), MyTextField()] {
        didSet {
            for i in 0...3 {
                addOneNumberTextField[i].keyboardType = UIKeyboardType.numberPad
                addOneNumberTextField[i].textAlignment = .center
            }
        }
    }
    
    let compareButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.backgroundColor = UIColor.black
        button.setTitle("Compare", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControlState.normal)
        button.addTarget(self, action: #selector(compareClick), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    let randomNumberGeneratorButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.backgroundColor = UIColor.black
        button.setTitle("New Game", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControlState.normal)
        button.addTarget(self, action: #selector(newGameClick), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    // MARK: Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        view.addSubview(countdownLabel)
        view.addSubview(randomNumberTextField)
        for i in 0...3 {
            
            addOneNumberTextField[i].keyboardType = .numberPad
            addOneNumberTextField[i].textAlignment = .center
            view.addSubview(addOneNumberTextField[i])
        }
        view.addSubview(compareButton)
        view.addSubview(randomNumberGeneratorButton)
        
        setupViews()
        
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
    }

    // MARK: setupViews
    private func setupViews()
    {
        // countdownLabel
        countdownLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 60).isActive = true
        countdownLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -24).isActive = true
        countdownLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        countdownLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        // randomNumberTextField
        randomNumberTextField.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -24).isActive = true
        randomNumberTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        randomNumberTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        randomNumberTextField.topAnchor.constraint(equalTo: countdownLabel.bottomAnchor, constant: 40).isActive = true
        
        // addOneNumberTextField_1
        for i in 0...3 {
            addOneNumberTextField[i].widthAnchor.constraint(equalTo: randomNumberTextField.widthAnchor, multiplier: 1/4).isActive = true
            addOneNumberTextField[i].heightAnchor.constraint(equalTo: randomNumberTextField.heightAnchor).isActive = true
            addOneNumberTextField[i].topAnchor.constraint(equalTo: randomNumberTextField.bottomAnchor, constant: 24).isActive = true
        }
        addOneNumberTextField[0].leftAnchor.constraint(equalTo: randomNumberTextField.leftAnchor).isActive = true
        addOneNumberTextField[1].leftAnchor.constraint(equalTo: addOneNumberTextField[0].rightAnchor).isActive = true
        addOneNumberTextField[2].leftAnchor.constraint(equalTo: addOneNumberTextField[1].rightAnchor).isActive = true
        addOneNumberTextField[3].leftAnchor.constraint(equalTo: addOneNumberTextField[2].rightAnchor).isActive = true
    
        // compareButton
        compareButton.topAnchor.constraint(equalTo: addOneNumberTextField[0].bottomAnchor, constant: 24).isActive = true
        compareButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        compareButton.widthAnchor.constraint(equalTo:randomNumberTextField.widthAnchor).isActive = true
        compareButton.heightAnchor.constraint(equalTo: randomNumberTextField.heightAnchor).isActive = true
        
        // randomNumberGeneratorButton
        randomNumberGeneratorButton.topAnchor.constraint(equalTo: compareButton.bottomAnchor, constant: 24).isActive = true
        randomNumberGeneratorButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        randomNumberGeneratorButton.widthAnchor.constraint(equalTo: compareButton.widthAnchor).isActive = true
        randomNumberGeneratorButton.heightAnchor.constraint(equalTo: compareButton.heightAnchor).isActive = true
    }

    // MARK: Handlers
    @objc func compareClick()
    {
        result = true
        for i in 0...3 {
            let tmp = digit[i] + 1
            add_1[i] = tmp == 10 ? 0 : tmp
            result = result && (Int(addOneNumberTextField[i].text!) == Int(add_1[i]))
        }
        
        if (result) {
            let alert = UIAlertController(title: "Congratulations!", message: "You win!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
        
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func newGameClick()
    {
        result = false
        gameTimer?.invalidate()
        count = 0
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
        countdownLabel.text = "0"
        randNum = generateRandomNumber(lowerBound: 1000, upperBound: 9999)

        digit[3] = randNum  % 10
        digit[2] = (randNum  % 100) / 10
        digit[1] = (randNum / 100) % 10
        digit[0] = randNum / 1000
        
        randomNumberTextField.text = "\(randNum) - \(digit[0]) \(digit[1]) \(digit[2]) \(digit[3]) "
    }
    
    private func generateRandomNumber(lowerBound: Int, upperBound: Int) -> UInt32
    {
        var randNum = arc4random_uniform(9999)
        while (randNum < lowerBound)
        {
            randNum = randNum + arc4random_uniform(9999) / 4
        }
        return randNum
    }
    
    @objc func countdown() {
        count = count + 1
        countdownLabel.text = String(count)
    }
    
}

class MyTextField: UITextField, UITextFieldDelegate {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        placeholder = ""
        backgroundColor = UIColor.white
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        translatesAutoresizingMaskIntoConstraints = false
        delegate = self
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print(textField.text?.count ?? 1000)
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("End Editing")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (textField.text!.count >= 1) {
            textField.text = ""
        }
        
        return true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
