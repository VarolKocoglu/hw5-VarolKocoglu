//
//  PageHomeworkViewController.swift
//  UIComponents
//
//  Created by varol on 21.01.2022.
//

import UIKit

class PageHomeworkViewController: UIViewController {
    
    var timer: Timer?
    
    //Createing page controller
    let pageCtrl: UIPageControl =  {
        let pageCtrl = UIPageControl()
        pageCtrl.numberOfPages = 5
        pageCtrl.backgroundColor = .black
        return pageCtrl
    }()
    
    let scrollView = UIScrollView()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        pageCtrl.addTarget(self,
                           action: #selector(pageControlDidChange(_:)),
                           for: .valueChanged)
        scrollView.backgroundColor = .purple
        view.addSubview(pageCtrl)
        view.addSubview(scrollView)
        
        //Timer trigger
        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(triggerMethod), userInfo: nil, repeats:true)
        
    }
    
    //timer method
    @objc func triggerMethod (_ sender: UIPageControl){
        var current = Int(Float(scrollView.contentOffset.x) / Float(scrollView.frame.size.width)) + 1
        if 6 > current && current > 1 {
            scrollView.setContentOffset(CGPoint(x: CGFloat(CGFloat(current) * view.frame.size.width), y: 0), animated: true)
            pageCtrl.currentPage = current - 1
        } else {
            current = 1
            scrollView.setContentOffset(CGPoint(x: CGFloat(CGFloat(current) * view.frame.size.width), y: 0), animated: true)
            pageCtrl.currentPage = current - 1
        }
    }
    
    
    
    //listen page controller then changes scroll view
    @objc func pageControlDidChange (_ sender: UIPageControl){
        let current = Int(Float(scrollView.contentOffset.x) / Float(scrollView.frame.size.width)) + 1
        print(current)
        scrollView.setContentOffset(CGPoint(x: CGFloat(CGFloat(current) * view.frame.size.width), y: 0), animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pageCtrl.frame = CGRect(x: 10, y: view.frame.size.height-100, width: view.frame.size.width-20, height: 70)
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height-100)
        
        if scrollView.subviews.count == 2 {
            configureScrollView()
        }
    }
    
    func configureScrollView() {
        scrollView.contentSize = CGSize(width: view.frame.size.width * 7 , height: scrollView.frame.size.height)
        scrollView.isPagingEnabled = true

        for x in 0..<7 {
            let viewForScroll = setView()[x]
            viewForScroll.frame = CGRect(x: CGFloat(x) * view.frame.size.width , y: 0, width: view.frame.size.width, height: scrollView.frame.size.height)
            scrollView.addSubview(viewForScroll)
        }
        self.scrollView.contentOffset = CGPoint(x: scrollView.frame.size.width, y:0)
    }

    //Creating views
    func setView() -> [UIView] {
        let zerothView = UIView()
        zerothView.backgroundColor = .blue
        
        let firstView = UIView()
        firstView.backgroundColor = .red

        let secondView = UIView()
        secondView.backgroundColor = .yellow

        let thirdView = UIView()
        thirdView.backgroundColor = .white


        let fourtView = UIView()
        fourtView.backgroundColor = .cyan

        let fifthView = UIView()
        fifthView.backgroundColor = .blue

        let sixthView = UIView()
        sixthView.backgroundColor = .red
        return [zerothView,firstView, secondView, thirdView, fourtView, fifthView,sixthView]
    }
    
}

extension PageHomeworkViewController: UIScrollViewDelegate {
    //listen scrollview then changes pageCtrl
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.x
        print(contentOffset)
        
        if contentOffset >= 414 {
            if contentOffset >= scrollView.frame.size.width * 6 {
                self.scrollView.contentOffset = CGPoint(x: scrollView.frame.size.width, y:0)
                pageCtrl.currentPage = 0
            }else {
                pageCtrl.currentPage = Int(floorf(Float(scrollView.contentOffset.x) / Float(scrollView.frame.size.width))) - 1
            }
        } else {
            self.scrollView.contentOffset = CGPoint(x: scrollView.frame.size.width * 5, y:0)
            pageCtrl.currentPage = Int(floorf(Float(scrollView.contentOffset.x) / Float(scrollView.frame.size.width))) - 1

        }
    }
}
