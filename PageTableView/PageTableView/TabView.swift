//
//  PageTableVC.swift
//  TabView
//
//  Created by BruceWu on 2021/8/31.
//

import UIKit

protocol PageTableDelegate: NSObject {
    func numberOfTabInPageTableVc(pageTableVc: TabView) -> Int?
    func buttonTitleInPageTableVc(pageTableVc: TabView, index: Int) -> String?
    func didSelectionPageTableVc(pageTableVc: TabView, index: Int)
}

class TabView: UIView {
    
    weak var delegate: PageTableDelegate? {
        didSet {
            //設定delegate後馬上執行畫面delegate
            setNumberOfPage()
        }
    }
    
    private var buttonStackView: UIStackView?
    private var buttonArray: [UIButton]?
    private var animationButtonView: UIView?
    private var animationViewConstrains: NSLayoutConstraint?
    var pageIndex = 0 {
        didSet {
            setupAnimationViews()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    private func setNumberOfPage() {
        
        //delegate順序.1
        guard let delegate = delegate, let pages = delegate.numberOfTabInPageTableVc(pageTableVc: self) else { return }
        setupViews()
        buttonArray = [UIButton]()
        //設定stackView裡button數量
        for i in 0..<pages {
            let button = UIButton()
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            button.setTitleColor(.black, for: .normal)
            button.tag = 1000 + i
            buttonArray?.append(button)
            buttonStackView?.addArrangedSubview(button)
            //delegate順序.2
            setButtonTitle(index: button.tag - 1000)
        }
        setupAnimationViews()
        
    }
    
    private func setButtonTitle(index: Int) {
        guard let title = delegate?.buttonTitleInPageTableVc(pageTableVc: self, index: index) else { return }
        buttonArray?[index].setTitle(title, for: .normal)
    }
    
    //按鈕點擊事件
    @objc private func buttonAction(sender: UIButton) {
        pageIndex = sender.tag - 1000
        _ = buttonArray?.filter({ btn in
            animationViewConstrains?.isActive = false
            animationViewConstrains = animationButtonView?.centerXAnchor.constraint(equalTo: (buttonArray?[pageIndex].centerXAnchor)!)
            animationViewConstrains?.isActive = true
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.layoutIfNeeded()
            }, completion: nil)
            return true
        })
        delegate?.didSelectionPageTableVc(pageTableVc: self, index: pageIndex)
    }
    
    private func setupViews() {
        buttonStackView = UIStackView()
        buttonStackView?.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonStackView!)
        buttonStackView?.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        buttonStackView?.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        buttonStackView?.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        buttonStackView?.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        buttonStackView?.axis = .horizontal
        buttonStackView?.alignment = .fill
        buttonStackView?.distribution = .fillEqually
        
        animationButtonView = UIView()
        animationButtonView?.backgroundColor = .blue
        animationButtonView?.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(animationButtonView!)
    }
    
    private func setupAnimationViews() {
        guard let buttonArray = buttonArray, buttonArray.count > pageIndex else { return }
        let button = buttonArray[pageIndex]
        animationButtonView?.heightAnchor.constraint(equalToConstant: 2).isActive = true
        animationButtonView?.widthAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        animationButtonView?.bottomAnchor.constraint(equalTo: button.bottomAnchor).isActive = true
        animationViewConstrains?.isActive = false
        animationViewConstrains = animationButtonView?.centerXAnchor.constraint(equalTo: button.centerXAnchor)
        animationViewConstrains?.isActive = true
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
