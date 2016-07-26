//
//  FullScreenImageViewController.swift
//  MIXR
//
//  Created by Nilesh Patel on 10/04/16.
//  Copyright © 2016 MIXR LLC. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage


class FullScreenImageViewController: UIViewController {
    @IBOutlet weak var imageView : UIImageView!
    
    var dicData : NSMutableDictionary!
    
    override func viewDidLoad() {
        self.navigationController?.navigationBarHidden = true
        self.displayPic()
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
    }
    func displayPic(){
        if let imageNameStr = dicData["media_url"] as? String
        {
            if (imageNameStr.characters.count > 0)
            {
                let URL = NSURL(string: imageNameStr)!
//                    Request.addAcceptableImageContentTypes(["binary/octet-stream"])
//                    let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
//                        size: self.imageView.frame.size,
//                        radius: 0.0
//                    )
                    self.imageView.af_setImageWithURL(URL, placeholderImage: UIImage(named: "ALPlaceholder"), filter: nil, imageTransition: .None, completion: { (response) -> Void in
                        print("image: \(self.imageView.image)")
                        print(response.result.value) //# UIImage
                        print(response.result.error) //# NSError
                    })
                }
        }
        else
        {
            self.imageView.image = UIImage(named:"ALPlaceholder")
        }
    }

    @IBAction func cancelButtonClicked(){
        //self.navigationController?.popViewControllerAnimated(false)
        self.dismissViewControllerAnimated(false) { 
            
        }
    }

}