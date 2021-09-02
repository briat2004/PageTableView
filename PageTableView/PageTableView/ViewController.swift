//
//  ViewController.swift
//  TabView
//
//  Created by BruceWu on 2021/8/31.
//

import UIKit

class ViewController: UIViewController, PageTableDelegate {
    
    var tabView: TabView = {
        let tabView = TabView()
        tabView.pageIndex = 0
        tabView.translatesAutoresizingMaskIntoConstraints = false
        return tabView
    }()
    
    var pageVc: UIPageViewController = {
        let pageVc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageVc.view.translatesAutoresizingMaskIntoConstraints = false
        return pageVc
    }()
    
    var vcs = [PageTableViewController]()
    var oldPageIndex: Int?
    var model: Model?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testData()
        
        setupViews()
        
        if let model = model {
            for i in 0..<model.list.count {
                let vc = PageTableViewController()
                vc.datas = model.list[i].info
                vcs.append(vc)
            }
            pageVc.setViewControllers([vcs.first!], direction: .forward, animated: true, completion: nil)
            oldPageIndex = tabView.pageIndex
        }
    }
    
    func numberOfTabInPageTableVc(pageTableVc: TabView) -> Int? {
        return model?.list.count
    }
    
    func buttonTitleInPageTableVc(pageTableVc: TabView, index: Int) -> String? {
        return model?.list[index].title
    }
    
    func didSelectionPageTableVc(pageTableVc: TabView, index: Int) {
        guard let oldPageIndex = oldPageIndex else { return }
        if pageTableVc.pageIndex > oldPageIndex {
            pageVc.setViewControllers([vcs[index]], direction: .forward, animated: true, completion: nil)
        } else if pageTableVc.pageIndex < oldPageIndex {
            pageVc.setViewControllers([vcs[index]], direction: .reverse, animated: true, completion: nil)
        }
        self.oldPageIndex = pageTableVc.pageIndex
    }
    
    func setupViews() {
        tabView.delegate = self
        self.view.addSubview(tabView)
        tabView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        tabView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        tabView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        tabView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        self.addChild(pageVc)
        self.view.addSubview(pageVc.view)
        pageVc.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        pageVc.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        pageVc.view.topAnchor.constraint(equalTo: tabView.bottomAnchor).isActive = true
        pageVc.view.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    func testData() {
        model = Model(list: [List(title: "Title1",
                                  info: [Info(title: "1"),
                                         Info(title: "2"),
                                         Info(title: "3")]),
                             List(title: "Title2",
                                  info: [Info(title: "A"),
                                         Info(title: "B"),
                                         Info(title: "D"),
                                         Info(title: "E")]),
                             List(title: "Title3",
                                  info: [Info(title: "7"),
                                         Info(title: "8"),
                                         Info(title: "9")]),
                             List(title: "Title4",
                                  info: [Info(title: "11"),
                                         Info(title: "12"),
                                         Info(title: "13"),
                                         Info(title: "14"),
                                         Info(title: "15")])])
    }
    
}

