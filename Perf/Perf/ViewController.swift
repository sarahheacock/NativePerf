//
//  ViewController.swift
//  Perf
//
//  Created by Sarah Heacock on 11/6/19.
//  Copyright © 2019 Sarah Heacock. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var scrollView: UIScrollView!
    var imageView: UIImageView!
//    var image: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView = UIScrollView(frame: view.bounds)
        
        guard let url = URL(string: "https://cdn1-www.dogtime.com/assets/uploads/2011/03/puppy-development.jpg") else { return }
        let data = try? Data(contentsOf: url)
        guard let image = UIImage(data: data!) else { return }

        for n in 1...500 {
            imageView = UIImageView(image: image)
            let size: Int = 100
            imageView.frame = CGRect(x: 0, y: n * size, width: size, height: size)
            scrollView.addSubview(imageView)
        }

        view.addSubview(scrollView)
    }
}

