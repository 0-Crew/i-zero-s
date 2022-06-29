//
//  HalfModalPresentationController.swift
//  Code-Zero
//
//  Created by 김민희 on 2022/06/02.
//

import UIKit

class HalfModalPresentationController: UIPresentationController {
    
    var backTapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    let blurEffectView: UIView!
    var check: Bool = false
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        blurEffectView = UIView()
        blurEffectView.backgroundColor = .white
        super.init(presentedViewController: presentedViewController, presenting: presentedViewController)
        backTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissController))
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.blurEffectView.isUserInteractionEnabled = true
        self.blurEffectView.addGestureRecognizer(backTapGestureRecognizer)
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        
        CGRect(origin: CGPoint(x: 0,
                               y: self.containerView!.frame.height * 181 / 800),
               size: CGSize(width: self.containerView!.frame.width,
                            height: self.containerView!.frame.height * 619 / 800))
    } 
    
    override func presentationTransitionWillBegin() {
        self.containerView!.addSubview(blurEffectView)
    }
    
    // 모달이 없어질 때 검은색 배경을 슈퍼뷰에서 제거
    override func dismissalTransitionWillBegin() {
        self.presentedViewController.transitionCoordinator?.animate(
            alongsideTransition: { _ in
                self.blurEffectView.alpha = 0 },
            completion: { _ in
                self.blurEffectView.removeFromSuperview()
            })
    }
    
    // 모달의 크기가 조절됐을 때 호출되는 함수
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        blurEffectView.frame = containerView!.bounds
    }
    
    @objc func dismissController() {
        self.presentedViewController.dismiss(animated: true, completion: nil)
    }
}
