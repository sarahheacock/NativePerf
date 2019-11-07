//
//  ViewController.swift
//  Perf
//
//  Created by Sarah Heacock on 11/6/19.
//  Copyright © 2019 Sarah Heacock. All rights reserved.
//

// imports Foundation too which allows you to speak to speak to NSString
// without having the write Foundation.NSString
// scope includes module, file, and curly braces
import UIKit

extension Int {
    func sayHello() {
        print("Hello, I'm \(self)")
    }
}

class ViewController: UIViewController {
    var scrollView: UIScrollView!
    var imageView: UIImageView!
    
    func hello() {
        print("hello!")
    }
    
    // namespace does not provide security but convenience
    // can only access Klass through ViewController.Klass
    class Dog {
        // private prevents fido.name = "Fido"
        private var name = ""
        // let name = "Lucy" would prevent changing at all
        func bark() {
            print("woof", self.name)
        }
        
        func addName(name: String) {
            self.name = name
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // CHAPTER 1
        // if you can extend it, it's an object
        // primitives/scalar are really objects
        // 1 is not a class or instance but an instance of a struct
        1.sayHello() // outputs: "Hello, I'm 1"

        // let is a constant
        // variables cannot change type
        // only function can contain executable code
        // this works because runtime will always call viewDidLoad
        
        // create instance of Dog
        let fido = Dog()
        fido.bark()
        fido.addName(name: "Fido")
        fido.bark()
    }
}

