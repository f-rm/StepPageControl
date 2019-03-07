//
//  ViewController.swift
//  StepPageControl
//
//  Created by Ryuji Muraoka on 2019/02/07.
//  Copyright © 2019年 rm studio. All rights reserved.
//

import UIKit
import StepPageControl

enum ScrollDirection: Int {
    case None = 0
    case Horizontal
    case Vertical
}

class ViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var stepControl: StepPageControl?
    
    @IBOutlet weak var contentView: UIScrollView?
    
    @IBOutlet var page1View: UIView?
    
    @IBOutlet var page2View: UIView?
    
    @IBOutlet var page3View: UIView?
    
    @IBOutlet var page4View: UIView?
    
    @IBOutlet var page5View: UIView?
    
    var scrollDirection: ScrollDirection = .None
    
    var startPoint: CGPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.contentView?.delegate = self

        self.contentView?.contentSize = CGSize(width: self.view.frame.width * 5,
                                               height: self.view.frame.height)
        
        // ステップ数
        self.stepControl?.numberOfStep = 5

        // 現在位置の色
        self.stepControl?.currentFillColor = UIColor(red: 255/255, green: 230/255, blue: 0, alpha: 1.0)

        // 現在位置の線の色
        self.stepControl?.currentStrokeColor = UIColor(red: 255/255, green: 230/255, blue: 0, alpha:1.0)

        // 未読の色
        self.stepControl?.waitingFillColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)

        // 未読の線の色
        self.stepControl?.waitingStrokeColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)

        // 既読の色
        self.stepControl?.doneFillColor = UIColor.white

        // 既読の線の色
        self.stepControl?.doneStrokeColor = UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1.0)

        layoutViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func layoutViews() {

        guard let page1View = self.page1View,
            let page2View = self.page2View,
            let page3View = self.page3View,
            let page4View = self.page4View,
            let page5View = self.page5View else {
                return
        }

        let scrollScreenWidth = self.view.frame.width
        let scrollScreenHeight = self.view.frame.height

        page1View.frame = CGRect.init(x: 0,
                                      y: 0,
                                      width: scrollScreenWidth,
                                      height: scrollScreenHeight)
        self.contentView?.addSubview(page1View)

        page2View.frame = CGRect.init(x: scrollScreenWidth,
                                      y: 0,
                                      width: scrollScreenWidth,
                                      height: scrollScreenHeight)
        self.contentView?.addSubview(page2View)

        page3View.frame = CGRect.init(x: scrollScreenWidth*2,
                                      y: 0,
                                      width: scrollScreenWidth,
                                      height: scrollScreenHeight)
        self.contentView?.addSubview(page3View)

        page4View.frame = CGRect.init(x: scrollScreenWidth*3,
                                      y: 0,
                                      width: scrollScreenWidth,
                                      height: scrollScreenHeight)
        self.contentView?.addSubview(page4View)

        page5View.frame = CGRect.init(x: scrollScreenWidth*4,
                                      y: 0,
                                      width: scrollScreenWidth,
                                      height: scrollScreenHeight)
        self.contentView?.addSubview(page5View)

    }

    // MARK: - UIScrollViewDelegate
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.scrollDirection = .None
        self.startPoint = scrollView.contentOffset
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if fmod(scrollView.contentOffset.x, scrollView.frame.width) == 0 {
            let currentStep: Int = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
            print("step:", currentStep)
            self.stepControl?.currentStep = currentStep
            if let maxStep = self.stepControl?.hasDoneStep {
                if maxStep <= currentStep {
                    self.stepControl?.hasDoneStep = currentStep
                }
            }
            self.stepControl?.setNeedsLayout()
            self.stepControl?.layoutIfNeeded()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPoint: CGPoint = scrollView.contentOffset
        
        if let startPoint = self.startPoint {
            if self.scrollDirection == .None {
                if !currentPoint.equalTo(startPoint) {
                    let moveHorizontal: CGFloat = abs(currentPoint.x - startPoint.x)
                    let moveVertical: CGFloat = abs(currentPoint.y - startPoint.y)
                    
                    if ( moveHorizontal < moveVertical ) {
                        self.scrollDirection = .Vertical
                    } else {
                        self.scrollDirection = .Horizontal
                    }
                }
            }
            if self.scrollDirection == .Vertical {
                scrollView.contentOffset.x = startPoint.x
            } else if self.scrollDirection == .Horizontal {
                scrollView.contentOffset.y = startPoint.y
            }
        }
    }

    @IBAction func gotoPage(sender: AnyObject) {
        guard let stepControlView = self.stepControl else {
            return
        }
        let step: Int = stepControlView.currentStep
        print("step:", step)

        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
            self.contentView?.contentOffset.x = CGFloat(Int(self.view.bounds.width) * step)
        }, completion: nil)
    }
}

