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
    @IBOutlet var button : UIButton!
    
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
        
        func addName(_ name: String) -> String {
            self.name = name
            return self.name
        }
    }
    
    func echo(string s:String, times n:Int) -> String {
        var result = ""
        for _ in 1...n { result += s }
        return result
    }
    
    func echo(_ s:String) -> String {
        return s
    }
    
    func sayStrings(_ arrayOfStrings: String ...) {
        // parameters are automatically let
        for s in arrayOfStrings {
            print(s)
        }
    }
    
    func removeCharacter(_ c: Character, _ s: inout String) {
        while let ix = s.firstIndex(of: c) {
            s.remove(at: ix)
        }
    }

    func createCounter(_ cb: @escaping (_ i: Int) -> ()) -> () -> () {
        var num = 0
        return {
            num += 1
            cb(num)
        }
    }
    func createCounter() -> (_ cb: () -> ()) -> () {
        var num = 0
        return {
            (_ cb: () -> ()) -> () in
            print(num)
            num += 1
            cb()
        }
    }
    
    // @objc ensures objective c visibility
    @objc func buttonPressed(_ sender: Any) {
        print("Pressed!")
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
        let fido = Dog() // calling special function Dog which is initializer
        fido.bark()
        let name = fido.addName("Fido")
        print(name)
        fido.bark()
        
        // CHAPTER 2
        // external parameter names -> function can externalize names of params
        // can help distinguish between functions of same name
        // can help swift interface with Objective C and Cocoa
        print(echo(string: "hello there", times: 2))
        
        // can overload because of strict typing
        print(echo("bye"))
        
        // variadic parameters, infinite paramaters of the same type
        sayStrings("hello", "friend")
        
        // in order to mutate parameter
        // if talking to objecitve C, it's UnsafteMutablePointer<...>
        var s = "hello"
        removeCharacter("l", &s)
        print(s)
        // you can also mutate class instances in functions
        // classes are reference types where other object flavors are value types

        // anonymous function
        // UIView.animate(withDuration:0.4,
        //                animations: {
        //                 () -> () in
        //                 self.myButton.frame.origin.y += 20
        // },
        //                completion: {
        //                 (finished:Bool) -> () in
        //                 print("finished: \(finished)")
        // }
        // )

        // OR without type
        // UIView.animate(withDuration:0.4,
        //     animations: {
        //         self.myButton.frame.origin.y += 20
        //     }, completion: {
        //         print("finished: \($0)") // *
        // })

        let arr = [2, 4, 6, 8]
        let arr2 = arr.map ({
            (i:Int) -> Int in
            return i*2
        })
        print(arr2)
        // $0 is the only param
        // let arr2 = arr.map{$0*2}
        // trailing closure if you put anonymous function outside parantheses
        // of a function call

        
        let count = createCounter()
         count(){
             print("hello")
         }
         count(){}
        
        var printNum = {
            print("other", $0)
        }
        let otherCount = createCounter(printNum)
        otherCount() // other 1
        printNum = {
            print("updated", $0)
        }
        otherCount() // other 2
        
        button = UIButton(type: UIButton.ButtonType.infoLight)
        // self.button.addTarget(self, action: "buttonPressed", for: .touchUpInside)
        // selector validates function reference
        self.button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        let container = UIView(frame: CGRect(x: 200, y: 200, width: 100, height: 100))
        container.addSubview(button)
        view.addSubview(container)
    }
}

