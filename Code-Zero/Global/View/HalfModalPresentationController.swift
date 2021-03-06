//
//  HalfModalPresentationController.swift
//  Code-Zero
//
//  Created by 김민희 on 2022/06/02.
//

import UIKit

class HalfModalPresentationController: UIPresentationController {

    let blurEffectView: UIView
    let swipeBar: UIView
    var modalHeight: CGFloat = 0

    override init(presentedViewController: UIViewController,
                  presenting presentingViewController: UIViewController?) {
        blurEffectView = UIView()
        blurEffectView.backgroundColor = .white
        swipeBar = UIView()
        swipeBar.backgroundColor = .black
        swipeBar.makeRounded(cornerRadius: 5)
        super.init(presentedViewController: presentedViewController, presenting: presentedViewController)

        let backTapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                              action: #selector(dismissController))
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(dismissController))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down

        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.isUserInteractionEnabled = true
        blurEffectView.addGestureRecognizer(backTapGestureRecognizer)
        blurEffectView.addGestureRecognizer(swipeDown)
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        modalHeight = (self.containerView!.frame.width * 323 / 327) + 308.5
        if modalHeight > self.containerView!.frame.height - 80 {
            modalHeight = self.containerView!.frame.height - 80
            return CGRect(origin: CGPoint(x: 0,
                                          y: self.containerView!.frame.height - modalHeight),
                          size: CGSize(width: self.containerView!.frame.width,
                                       height: modalHeight))
        }
        return CGRect(origin: CGPoint(x: 0,
                                      y: self.containerView!.frame.height - modalHeight),
                      size: CGSize(width: self.containerView!.frame.width,
                                   height: modalHeight))
    }
    override func presentationTransitionWillBegin() {
        self.containerView!.addSubview(blurEffectView)
        setSwipeBarFrame()
    }
    override func dismissalTransitionWillBegin() {
        UIView.animate(withDuration: 0.29) {
            self.swipeBar.removeFromSuperview()
        }
        self.presentedViewController.transitionCoordinator?.animate(
            alongsideTransition: { _ in
                self.blurEffectView.alpha = 0 },
            completion: { _ in
                self.blurEffectView.removeFromSuperview()
            })
    }
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        blurEffectView.frame = containerView!.bounds
        UIView.animate(withDuration: 0.29) {
            self.swipeBar.frame.origin.y = self.containerView!.frame.height - self.modalHeight - 20
        }
    }
    @objc func dismissController() {
        self.presentedViewController.dismiss(animated: true, completion: nil)
    }
    func setSwipeBarFrame() {
        containerView!.addSubview(swipeBar)
        swipeBar.frame = CGRect(origin: CGPoint(x: self.containerView!.frame.width/2 - 20,
                                                y: self.containerView!.frame.height+10),
                                size: CGSize(width: 40,
                                             height: 10))
    }
}
