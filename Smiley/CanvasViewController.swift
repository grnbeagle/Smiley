//
//  CanvasViewController.swift
//  Smiley
//
//  Created by Amie Kweon on 5/7/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController {
    var trayOriginalCenter: CGPoint!
    var trayOpened = false
    var smileyOriginalCenter: CGPoint!

    var openPositionY: CGFloat?
    var closePositionY: CGFloat?

    @IBOutlet weak var trayView: UIView!

    var newlyCreatedFace: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        openPositionY = trayView.frame.origin.y
        closePositionY = view.frame.height - 30.0

        var currentFrame = trayView.frame

        changeTrayViewY(closePositionY!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func changeTrayViewY(y: CGFloat) {
        var currentFrame = trayView.frame

        UIView.animateWithDuration(Double(0.5), delay: 0,
            usingSpringWithDamping: CGFloat(0.2),
            initialSpringVelocity: CGFloat(0.1),
            options: UIViewAnimationOptions.CurveEaseIn,
            animations: { () -> Void in
                self.trayView.frame = CGRect(x: currentFrame.origin.x, y: y, width: currentFrame.width, height: currentFrame.height)
        }) { (complete) -> Void in
            //
        }

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func onTrayPanGesture(panGestureRecognizer: UIPanGestureRecognizer) {
        var point = panGestureRecognizer.locationInView(view)
        var velocity = panGestureRecognizer.velocityInView(view)
        var translation = panGestureRecognizer.translationInView(view)

        if panGestureRecognizer.state == .Began {
            trayOriginalCenter = trayView.center
            println("Gesture began \(point)")
        } else if panGestureRecognizer.state == .Changed {
            var newPositionY = trayOriginalCenter.y + translation.y
            var openCenterY = view.frame.height - openPositionY! / 2 + 30
            println("---  newPositionY: \(newPositionY); openPositionY: \(openPositionY!)")
            trayView.center = CGPoint(x: trayOriginalCenter.x, y: newPositionY)
//            trayView.center = CGPoint(x: trayOriginalCenter.x, y: max(newPositionY, openCenterY))
//            println("Gesture changed \(point)")
        } else if panGestureRecognizer.state == .Ended {
            println("Gesture ended \(point)")
            var movingDown = velocity.y > 0
            if (!movingDown) {
                changeTrayViewY(openPositionY!)
            } else {
                changeTrayViewY(closePositionY!)
            }
        }
    }

    /// Panning faces after they are created
    func onSmileyPanGesture2(panGestureRecognizer: AnyObject) {
        var point = panGestureRecognizer.locationInView(view)
        var velocity = panGestureRecognizer.velocityInView(view)
        var translation = panGestureRecognizer.translationInView(view)

        if panGestureRecognizer.state == .Began {
            var senderImage = panGestureRecognizer.view as? UIImageView
            if let senderImage = senderImage {
                newlyCreatedFace = senderImage
                smileyOriginalCenter = newlyCreatedFace?.center
            }
        } else if panGestureRecognizer.state == .Changed {
            var newXCenter = smileyOriginalCenter.x + translation.x
            var newYCenter = smileyOriginalCenter.y + translation.y
            newlyCreatedFace.center = CGPoint(x: newXCenter, y: newYCenter)
        } else if panGestureRecognizer.state == .Ended {
            
        }
    }

    @IBAction func onSmileyPanGesture(panGestureRecognizer: AnyObject) {
        var point = panGestureRecognizer.locationInView(view)
        var velocity = panGestureRecognizer.velocityInView(view)
        var translation = panGestureRecognizer.translationInView(view)

        if panGestureRecognizer.state == .Began {
            var imageView = panGestureRecognizer.view as? UIImageView
            newlyCreatedFace = UIImageView(image: imageView?.image)
            newlyCreatedFace.frame = imageView!.frame
            view.addSubview(newlyCreatedFace)

            newlyCreatedFace.center = imageView!.center
            newlyCreatedFace.center.y += trayView.frame.origin.y


            // create pan gesture
            var smileyPanGuesture = UIPanGestureRecognizer(target: self, action: "onSmileyPanGesture2:")
            newlyCreatedFace.addGestureRecognizer(smileyPanGuesture)
            newlyCreatedFace.userInteractionEnabled = true


            smileyOriginalCenter = newlyCreatedFace.center
        } else if panGestureRecognizer.state == .Changed {
            var newXCenter = smileyOriginalCenter.x + translation.x
            var newYCenter = smileyOriginalCenter.y + translation.y
            newlyCreatedFace.center = CGPoint(x: newXCenter, y: newYCenter)
        } else if panGestureRecognizer.state == .Ended {

        }

    }
}
