//
//  PhotoCropViewController.swift
//  comp90018
//
//  Created by imac on 4/10/2015.
//  Copyright (c) 2015 Huabin Liu. All rights reserved.
//

import UIKit

class PhotoCropViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var image: UIImage!
    var imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        imageView.image = image
        imageView.frame = CGRectMake(0, 0, image!.size.width, image!.size.height / 2)
        imageView.contentMode = UIViewContentMode.Center
        
        scrollView.addSubview(imageView)
        scrollView.contentSize = image!.size
        
        let scrollViewFrame = scrollView.frame
        let scaleWidth = scrollViewFrame.size.width / scrollView.contentSize.width
        let scaleHeight = scrollViewFrame.size.height / scrollView.contentSize.height
        let minScale = min(scaleHeight, scaleWidth)
        
        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = 6
        scrollView.zoomScale = minScale
        
        centerScrollViewContents()
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func centerScrollViewContents() {
        let boundsSize = scrollView.bounds.size
        var contentsFrame = imageView.frame
        
        if contentsFrame.size.width < boundsSize.width {
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2
        } else {
            contentsFrame.origin.x = 0
        }
        
        if contentsFrame.size.height < boundsSize.height {
            
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2 - self.navigationController!.navigationBar.frame.size.height - UIApplication.sharedApplication().statusBarFrame.size.height
        } else {
            contentsFrame.origin.y = -self.navigationController!.navigationBar.frame.size.height - UIApplication.sharedApplication().statusBarFrame.size.height
        }
        
        imageView.frame = contentsFrame
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        centerScrollViewContents()
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    @IBAction func cropAndSave(sender: UIButton) {
        let imageToSave = crop()
        UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil, nil)
    }
    
    func crop() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(scrollView.bounds.size, true, UIScreen.mainScreen().scale)
        let offset = scrollView.contentOffset
        
        CGContextTranslateCTM(UIGraphicsGetCurrentContext(), -offset.x, -offset.y)
        scrollView.layer.renderInContext(UIGraphicsGetCurrentContext())
        
        let imageToCrop = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return imageToCrop
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if(segue.identifier == "push") {
            let navController = segue.destinationViewController as! UINavigationController
            let filterController = navController.topViewController as! PhotoFilterViewController
            let imageToSend = crop()
            filterController.image = imageToSend
        }
    }
}
