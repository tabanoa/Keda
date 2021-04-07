//
//  ProductPageVC.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.
import UIKit

protocol ProductPageVCDelegate: class {
    func numberOfPages(_ num: Int)
    func currentPage(_ num: Int)
}

class ProductPageVC: UIPageViewController {
    
    weak var kDelegate: ProductPageVCDelegate?
    var imageLinks: [String] = []
    
    lazy var controllers: [UIViewController] = {
        var controllers: [UIViewController] = []
        for _ in imageLinks {
            let vc = ProductImageVC()
            controllers.append(vc)
        }

        kDelegate?.numberOfPages(controllers.count)
        return controllers
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        delegate = self
        dataSource = self
        turnPages(0)
    }
}

//MARK: - Configures

extension ProductPageVC {
    
    func turnPages(_ index: Int) {
        let controller = controllers[index]
        var direction = UIPageViewController.NavigationDirection.forward
        
        if let currentVC = viewControllers?.first {
            if let currentIndex = controllers.firstIndex(of: currentVC) {
                if currentIndex > index {
                    direction = .reverse
                }
            }
        }
        
        configureDisplay(controller)
        setViewControllers([controller], direction: direction, animated: true, completion: nil)
    }
    
    func configureDisplay(_ controller: UIViewController) {
        for (index, vc) in controllers.enumerated() {
            if controller == vc {
                if let controller = controller as? ProductImageVC {
                    controller.imageLink = imageLinks[index]
                    kDelegate?.currentPage(index)
                }
                
                kDelegate?.currentPage(index)
            }
        }
    }
}

//MARK: - UIPageViewControllerDataSource

extension ProductPageVC: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = controllers.firstIndex(of: viewController) {
            if index > 0 {
                return controllers[index - 1]
                
            } else {
                return nil
            }
        }
        
        return controllers.last
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = controllers.firstIndex(of: viewController) {
            if index < controllers.count - 1 {
                return controllers[index + 1]
                
            } else {
                return nil
            }
        }
        
        return controllers.first
    }
}

//MARK: - UIPageViewControllerDelegate

extension ProductPageVC: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        configureDisplay(pendingViewControllers.first!)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if !completed {
            configureDisplay(previousViewControllers.first!)
        }
    }
}
