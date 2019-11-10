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

struct Vial: Equatable {
    var numberOfBacteria : Int
    init(_ n:Int) {
        self.numberOfBacteria = n
    }
    
    static func +(lhs:Vial, rhs:Vial) -> Vial {
        let total = lhs.numberOfBacteria + rhs.numberOfBacteria
        return Vial(total)
    }
}

//extension Vial : Equatable {
//    static func ==(lhs:Vial, rhs:Vial) -> Bool {
//        return lhs.numberOfBacteria == rhs.numberOfBacteria
//    }
//}

protocol Flier {
    func fly()
}

protocol Fighter {
    associatedtype Enemy : Fighter
}

protocol GenFlier {
    // associatedtype Other
    associatedtype Other : GenFlier // must be subclass
    func flockTogetherWith(_ f:Other)
    func mateWith(_ f:Other)
}

// @objc protocol is a class protocol
@objc protocol FlierClass {
    @objc optional var song : String? { get set }
}

//@propertyWrapper struct DeferredConstant<T> {
//    private var _value: T? = nil
//    var wrappedValue: T {
//        get {
//            if _value == nil {
//                fatalError("not yet initialized")
//            }
//            return _value!
//        }
//        set {
//            if _value == nil {
//                _value = newValue
//            }
//        }
//    }
//}


// class protocol can take advantage of special memory managements features that
// only apply to classes
protocol MyViewProtocol : UIView {
    // marked as having special memory management that applies only to class instances
    // weak var delegate : Dog?
    func doSomethingReallyCool()
}

class ViewController: UIViewController {
    var scrollView: UIScrollView!
    var imageView: UIImageView!
    var v: MyViewProtocol?
    @IBOutlet var button : UIButton!
    // @IBOutlet @DeferredConstant var myButton: UIButton!
    
    
    // compile error because UIViewController protocol NSCoding requires
    // and you are cutting off inheritance with out initializer
    // init() {
    //     super.init(nibName:"ViewController", bundle:nil) // compile error
    // }
    // required init?(coder: NSCoder) {
    //     fatalError("init(coder:) has not been implemented")
    // }
    
    func hello() {
        print("hello!")
    }
    
    // namespace does not provide security but convenience
    // can only access Klass through ViewController.Klass
    class Quadruped {
        func walk () {
            print("walk walk walk")
        }
    }

    class Dog: Quadruped {
        // private prevents fido.name = "Fido"
        private var name: String
        var nicName: String
        // let name = "Lucy" would prevent changing at all
        
        // static prop
        static let staticProperty = "staticProperty"
        // instance prop
        let instanceProp = "instanceProperty"
        
        // calling self.initFancy will not work because there is no instance yet
        let fancy = {
           return true
        }()
        
        // computer property exists after self exists
        let foo = "foo"
        let bar = "bar"
        // var computed : String {
        //     return self.foo + " " + self.bar
        // }
        // lazy var computed = self.foo + " " + self.bar
        lazy var computed: String = {
            self.foo + " " + self.bar
        }()
        
        // init() { }
        // init(name:String) {
        //     self.name = name
        // }

        // optional wrapping of dog
        // done for items like UIImage where it might fail
        // However, objective-c initializers are not bridged as failable
        // init?(name:String) {
        //     if name.isEmpty {
        //         return nil
        //     }
        //     self.name = name
        // }

        required init(name:String = "", _ nicName: String = "") {
            self.name = name
            self.nicName = nicName
        }
        
        subscript(ix: String) -> String? {
            get {
                let index = Int(ix)
                if index != nil {
                    let i = self.name.index(self.name.startIndex, offsetBy:index!)
                    return String(self.name[i])
                }
                return nil
            }
            set {
                // let index = Int(ix)
                // if index != nil {
                //     self.name.replaceSubrange(index...index, with: String(newValue))
                // }
            }
        }
        
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
        print(Dog.staticProperty)
        print(fido.instanceProp)
        
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
        
        print(globalVariable)
        
        let timed : Bool = {
            return true
        }()
        print(timed)
        print(fido.fancy)
        
        var now: String {
            get {
                return Date().description
            }
            // set {
            //     print(newValue)
            // }
            set (val) {
                print(val)
            }
        }
        now = "howdy"
        print(now)
        
        // CHAPTER 3
        var angle : CGFloat = 0 {
            didSet {
                // modify interface to match
                // self.transform = CGAffineTransform(rotationAngle: self.angle)
                print(oldValue)
            }
        }

        // lazy initialization
        // global, static variables are not initialized until needed
        // instance props can be lazy if given word lazy
        
        // Singleton
        // MyClass.sharedSingleton is initiated when called
        // and is always the same instance
        class MyClass {
            static let sharedSingleton = MyClass()
        }
        
        // lazy can refer to the instance
        class MyView : UIView {
            lazy var arrow = self.arrowImage() // legal
            func arrowImage() -> Int {
                // ... big image-generating code goes here ...
                return 10
            }
        }
        
        // Bool struct
        // nothing other than Bool can be coerced to true or false
        class MyBool {
            var p = false
        }
        let bool = MyBool()
        print(bool.p)
        bool.p.toggle()
        print(bool.p)
        
        // Int struct
        // Int.min Int.max
        
        // Double struct
        // Double.infinity Double.pi
        
        // instantiation can do form of number coercion
        let y = 3.8
        let j = Int(y)
        print(j) // 3, an Int
        
        let f = 0.1
        var sum = 0.0
        for _ in 0..<10 { sum += f }
        let product = f * 10
        let ok = sum == product // false
        let ok2 = sum >= product.nextDown && sum <= product.nextUp // true
        print(ok, ok2)
        
        // Foundation NSString properties come when using Swift string
        let str = "hello world"
        let s2 = str.capitalized // "Hello World"
        print(s2)
        
        let filtered = s.filter{"aeiou".contains($0)} // "eo"
        print(filtered)
        
        for ix in (1..<4).reversed() {
            print(ix) // 3, 2, 1
        }
        
        // tuples are purely swift and not compitible with cocoa or objective-C
        // let pair = (1, "two")
        let pair = (first:1, second:"Two")
        print(pair)
        
        for (ix,c) in s.enumerated() {
            print("character \(ix) is \(c)")
        }
        
        // Optional object type (an enum) wraps another object of any type
        // var stringMaybe = Optional("howdy")
        var stringMaybe : String? = "howdy"
        print(stringMaybe)
        print(stringMaybe!) // ! grabs wrapped value, unwrapping nil causes error
        if stringMaybe == nil {
            print("it is empty") // prints
        }
        
        // stringMaybe = nil
        // let upper = stringMaybe!.uppercased() // optional chains
        let upper = stringMaybe?.uppercased() // optional chains (optionally unwraps)
        print(upper)
        
        // map and flatmap send message to wrapped without unwrapping
        let maybeMap = stringMaybe.map{$0.uppercased()}
        print(maybeMap)
        print(maybeMap == "HOWDY")
        
        // flatmap unwraps before wrapping
        let i = stringMaybe.flatMap{Int($0)}
        print(i) // nil
        
        // optional because any objective C object can be nil
        
        // CHAPTER 4 Object Types
        // (1) object types are in 3 flavors--enum, struct, and class
        // Top level object types seen in all files in same module
        // type inside a type creates a namespace
        // type inside a function will only exist when function executed
        // initializer creates instance of object type
        // initializer may call initialized instance property
        let lucy = Dog() // calls initializer
        print(lucy.computed)

        // by default a prop is an instance type and can be different for every instance
        // static/class property belongs to the object type itself
        // instance methods are actually static
        Dog.addName(fido)("fido2.0")
        fido.bark()
        
        // by default, method is an instance method
        // subscript is a special kind of method (appending square brackets to reference)
        print(fido["0"]) // Optional("f")
        
        // ENUM
        // enum has predefined alternative values
        // type String means .albums carries a value of "albums"
        // enum Filter : Int, CaseIterable {
        //     case albums = 1
        //     case playlists
        //     case podcasts
        //     case books
        //     init(_ ix:Int) {
        //         self = Filter.allCases[ix]
        //     }
        // }
        enum Filter : String, CaseIterable {
            case albums
            case playlists
            case podcasts
            case books
            init?(_ ix:Int) {
                if !Filter.allCases.indices.contains(ix) {
                    return nil
                }
                self = Filter.allCases[ix]
            }
            var sillyProperty : String {
                get { return "Howdy" }
                set {} // do nothing
            }
        }
        
        // let type = Filter.albums
        // let type: Filter = .albums
        print(Filter.playlists.rawValue)
        
        // let v = UIView()
        // v.contentMode = .center

        // to use an initializer
         enum MyError {
             case number(Int)
         }
         let err: MyError = .number(4)
         print(err)
        
        // Optional is simply an enum with .none and .some
        // print(err == MyError.number) // err
        // have to adopt Equatable protocol
        
        // using case iterable protocol
        print(Filter.allCases)
        let type1 = Filter.albums
        let type2 = Filter(rawValue:"playlists")
        let type3 = Filter(2) // .podcasts
        print(type3?.sillyProperty)

        // STRUCT
        // an enum is a special sub type of object
        // a struct is an object includes String, Int, Range, etc
        struct Digit {
            var number = 42
            // implicit initializer, uncessary
            // init(number: Int) {
            //     self.numer = number
            // }
        }
        
        var digit = Digit() // unlike Class, cannot use let
        digit.number = 100
        
        // CLASS
        // unlike struct (1) props can be mutated on instance intiated with let
        // (2) you can have multiple references to the same object
        // subclass inherits all superclass methods
        
        // when you mutate a struct instance, you are actually replacing it
        // Also, cannot pass in struct instance as an argument to be mutated
        var d: Digit = Digit(number: 123) {
            didSet {
                print("d was set")
            }
        }
        d.number = 42
        
        // but classes are reference NOT value types
        // value types assign value to a new variable
        // reference types assign reference to a new variable
        // multiple references can be a lot of overhead
        
        // Cocoa NSString, NSArray, NSDictionary, NSDate, NSIndexSet, NSParagraphStyle
        // are immutable but not necessarily value types
        
        // subclass and superclass
        // Cocoa requires superclass NSObject
        fido.walk()
        
        // overriding
        // subclass can redefine a method
        class Puppy: Dog {
            override func bark() {
                print("arf")
            }
        }
        let puppy = Puppy()
        puppy.bark()
        
        // convenience initializer can prevent requirement of initial params
        
        // polymorphism--single interface for different types
        // type of an object can be a subtype
        // polymorphism is slow b/c is requires dynamic dispatch
        // try using final/private or struct
        let pup: Dog = Puppy()
        
        // casting
        // because an item can have an actual type that is different
        // from the declared type--we sometimes have compile issues
        class NoisyDog : Dog {
            override func bark() {
                super.bark(); super.bark()
            }
            func beQuiet() {
                self.bark()
            }
        }

        func tellToHush(_ d:Dog?) {
            // if d is NoisyDog {
            //     (d as! NoisyDog).beQuiet() // force compiler
            // }
            let d = d as? NoisyDog
            // if d != nil {
            //     d!.beQuiet()
            // }
            d?.beQuiet()
            
            // NOTE: `if d is NoisDog` will work
        }
        let nd = NoisyDog()
        tellToHush(nd)
        print(type(of:nd))
        
        // type as a value
        func dogTypeExpecter(_ whattype:Dog.Type) {
            // print(whattype) // Dog
            let d = whattype.init(name:"Fido")
            print(d)
        }
        dogTypeExpecter(Dog.self)
        dogTypeExpecter(type(of:nd))
        
        // (2) to give object type more flexibility protocols, generics, extensions
        // protocol is an object type--you CAN'T instantiate a protocol
        // since you cannot have substruct
        struct Bird: Flier {
            func fly() {
                
            }
        }
        
        func tellToFly(_ f:Flier) {
            f.fly()
        }
        
        class FancyBird : FlierClass {
            
        }
        let prettyBird: FlierClass = FancyBird()
        print(prettyBird.song)
        // prettyBird[keyPath: \.song] = "tweet tweet" // dot notation is said to be constant
        
        struct Nest : ExpressibleByIntegerLiteral {
            var eggCount : Int = 0
            init() {}
            init(integerLiteral val: Int) {
                self.eggCount = val
            }
        }
        // can pass in int for nest due to ExpressibleByIntegerLiteral
        func reportEggs(_ nest:Nest) {
            print("this nest contains \(nest.eggCount) eggs")
        }
        reportEggs(4) // this nest contains 4 eggs
        
        struct GenBird : GenFlier {
            // generic protocol just argument types to the same
            func flockTogetherWith(_ f:GenBird) {}
            func mateWith(_ f:GenBird) {}
        }
        
        func takeAndReturnSameThing<T> (_ t:T) -> T {
            print(T.self)
            return t
        }
        let thing = takeAndReturnSameThing("howdy")
        
        // type constraint--limit the types eligible to be used for resolving particular placeholder
        
        // associate type manually
        // both are able to use protocol Fighter
        // with an Enemy of a different struct
        struct Soldier : Fighter {
            typealias Enemy = Archer
        }
        struct Archer : Fighter {
            typealias Enemy = Soldier
        }
        
        // where clauses
        // function for where we want to group types
        func flockTogether<T> (_ f:T) where T:GenFlier, T.Other:Equatable {}

        // EXTENSIONS
        // extension is a way of injecting your own code into an object type
        // that has already been declared elsewhere

        // can declare prop but can have computed prop
        // only can have convenience initializer
        // can overload but cannot override method
        
        // Array is a generic struct
        var intArr = [Int]() // items in array are mutable
        // let arr2 : [Flier] = [Insect(), Bird()] // protocol adopters
        
        // Array(1...3) generates the array of Int [1,2,3].
        // Array("hey") generates the array of Character ["h","e","y"]
        // Array(d), where d is a Dictionary, generates an array of tuples of the key–value pairs of d.
        let strings : [String?] = Array(repeating:nil, count:100)
        
        let optionalArr : [Int?] = [1,2,3]
        print(optionalArr) // [Optional(1), Optional(2), Optional(3)]
        // you can compare 2 arrays
        
        // DICTIONARY
        // struct--unordered collection of object pairs
        // can also initialize from array of tuples
        // var dict : [String:String] = [:]
        let dict = ["CA": "California", "NY": "New York"]
        for pair in dict {
            print("\(pair.key) stands for \(pair.value)")
        }
        
        // SET
        // struct--unordered collection of unique objects
        // if unique set of items and do not care about order
        // could be more space efficient than an array
        let set : Set<Int> = [1, 2, 3, 4, 5]
        
        // CHAPTER 5 flow control
        // conditional binding--if variable equals nil, block skipped
        let optionalStr: String? = "foo"
        if let variable = optionalStr {
            print(variable)
        }
        guard let variable = optionalStr else { return }
        print(variable)
        
        let num: Int? = 2
        switch num {
        case 1?:
            print("You have 1 thingy!")
        case let n?:
            print("You have \(n) thingies!")
        case nil: break
        }
        
        switch num {
        case .none: break
        case .some(1):
            print("You have 1 thingy!")
        case .some(let n):
            print("You have \(n) thingies!")
        }
        
        switch d {
        case is NoisyDog:
            print("You have a noisy dog!")
        case _:
            print("You have a dog")
        }

        // if you just want to extract a value from one enum case
        // you can use if case
        
        // obj c has collapsed ternary to test against nil
        // use unwrapped val or subbed val
        // nil coalescing operator
        let newNum = num ?? 0
        
        // can create readonly sequence of numbers on fly (Range)
        for i in 1...5 {
            print(i) // 1, 2, 3, 4, 5
        }
        
        // under the hood
        var iterator = (1...5).makeIterator()
        while let i = iterator.next() {
            print(i) // 1, 2, 3, 4, 5
        }
        
        // actually iterating through a copy
        // safe to mutate
        var mySet : Set = [1,2,3,4,5]
        for i in mySet {
            if i.isMultiple(of:2) {
                mySet.remove(i)
            }
        }
        print(mySet) // s is now [1,3,5]
        
        var dogs : [Dog] = [Dog(name: "rover", "rover"), Dog(name: "fido", "fido")]
        for var dog in dogs {
            dog.nicName = dog.nicName.uppercased()
            print(dog.nicName)
        }
        for var dog in dogs {
            print(dog.nicName)
        }
        
        struct DogStruct {
            var name : String
            init(_ n:String) {
                self.name = n
            }
        }
        // if variable type is a value type,
        // the variable is also a copy
        var dogStructs : [DogStruct] = [DogStruct("rover"), DogStruct("fido")]
        // for var dog in dogStructs {
        //     dog.name = dog.name.uppercased()
        //     print(dog.name)
        // }
        // have to iterate through indices instread
        for ix in dogStructs.indices {
            dogStructs[ix].name = dogStructs[ix].name.uppercased()
        }
        for var dog in dogStructs {
            print(dog.name) // lowercase
        }
        
        // sometimes you need to specify which construct you mean when
        // you say continue or break
        struct Primes {
            static var primes = [2]
            static func appendNextPrime() {
                next: for i in (primes.last!+1)... {
                    let sqrt = Int(Double(i).squareRoot())
                    for prime in primes.lazy.prefix(while:{$0 <= sqrt}) {
                        if i.isMultiple(of: prime) {
                            continue next
                        }
                    }
                    primes.append(i)
                    return
                }
            }
        }
        
        // DEFER STATEMENT
        // defer when the path of execution leaves curly braces
        
        func doSomethingTimeConsuming() {
            defer {
                // make sure that this always called before last line of function
                UIApplication.shared.endIgnoringInteractionEvents()
            }
            // stop all user touches from reaching any view of the application
            UIApplication.shared.beginIgnoringInteractionEvents()
            // ... do stuff ...
            return
            
            // other stuff
        }
        
        struct Countdown: Sequence, IteratorProtocol {
            var count: Int
            mutating func next() -> Int? {
                if count == 0 {
                    return nil
                } else {
                    // returns count as is before defer
                    defer { count -= 1 }
                    return count
                }
            }
        }
        
        var countdown = Countdown(count: 1)
        let newCount = countdown.next()
        print(countdown) // 0
        print(newCount) // 1
        
        // fatalError can halt entire program
        // assert is ignore during production build
        
        // all declaration are internal by default (globally visible in same module)
        // in C and obj-C you explicitly have to include or import
        // object types are only visible inside file
        // private only inside curly braces

        // must declare module public (can subclass)
        // open (can override in subclass)
        
        // extension have access to private vars
        
        // INTROSPECTION
        // let object display names and values of its properties
        // instantiate a mirror
        // The Mirror’s children will then be name–value tuples describing the original object’s properties
        
        // OPERATOR
        // an operator is a function
        // Swift operators can be overloaded for different types of operand

        let v1 = Vial(500_000)
        let v2 = Vial(400_000)
        let v3 = v1 + v2 // only works at top of file
        print(v3.numberOfBacteria) // 900000
        
        // MEMORY MANAGEMENT
        // memory management is handled automatically in Swift
        // memory leak when reference types reference eachother
        func testRetainCycle() {
            class Dog {
                var cat : Cat?
                // weak var cat : Cat?
                deinit {
                    print("farewell from Dog")
                }
            }
            class Cat {
                // unowned has to be const
                // changing reference d will cause a crash
                // have to make sure cat instance will outlive dog
                unowned let dog : Dog
                init(dog: Dog){ self.dog = dog }
                // var dog : Dog?
                // weak var dog : Dog?
                deinit {
                    print("farewell from Cat")
                }
            }
            let d = Dog()
            // let c = Cat()
            // defer {
            //     d.cat = nil // fixes issue
            // }
            // d.cat = c // create a...
            // c.dog = d // ...retain cycle
            
            let c = Cat(dog: d)
        }
        testRetainCycle() // nothing in console :-(
        // strong reference--dog has reference to cat. Cat will never be destroyed
        // one of of them has to go first
        
        // anonymous functions that refer to the object holding reference
        // will also cause retention cycle
        class FunctionHolder {
            var function : (() -> ())?
            deinit {
                print("farewell from FunctionHolder")
            }
        }
        func testFunctionHolder() {
            let fh = FunctionHolder()
            // only stored function can raise possibility of retain cycle
            fh.function = {
                [weak fh] in // fixes (marks as weak)
                // fh now marked as optional
                guard let fh = fh else { return }
                print(fh)
            }
            fh.function?()
        }
        testFunctionHolder() // nothing in console
        // only reference to class type can be weak or unowned
        
        // EQUATABLE
        // == operator can be used
        // create extension with equatable protocol
        let vialArr = [v1,v2]
        guard let vialIndex = vialArr.firstIndex(of:v1) else { return } // Optional wrapping 0
        print(v1 == vialArr[vialIndex])
        
        // will implement == automatically if you just want to equate properties
        // object type has to be struct or enum
        
        // Set, Dictionary, and enum with values are hashtbales
        // hashtable requires adopter to be equatable
        struct DogHash : Hashable { // and therefore Equatable
            let name : String
            let license : Int
            let color : UIColor
            static func ==(lhs:DogHash,rhs:DogHash) -> Bool {
                return lhs.name == rhs.name && lhs.license == rhs.license
            }
            func hash(into hasher: inout Hasher) {
                name.hash(into:&hasher)
                license.hash(into:&hasher)
            }
        }
        
        // key paths store reference to property without accessing property
        var prop = \Dog.nicName
        puppy.nicName = "skippy"
        let whatname = puppy[keyPath:prop]
        print(whatname)
    }
}

