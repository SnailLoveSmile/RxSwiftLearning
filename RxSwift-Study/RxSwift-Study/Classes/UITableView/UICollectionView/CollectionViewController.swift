//
//  CollectionViewController.swift
//  RxSwift-Study
//
//  Created by apple on 2019/1/20.
//  Copyright © 2019 incich. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
class CollectionViewController: BaseViewController {
    let bag = DisposeBag()
    fileprivate let cellID = "MyCollectionViewCell"
    lazy var collectionView:UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 70)
        let c = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        c.backgroundColor = .white
        c.register(UINib.init(nibName: cellID, bundle: nil), forCellWithReuseIdentifier: cellID)
        return c
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(self.collectionView)

        let items = Observable.just([SectionModel.init(model: "", items: ["Swift", "Java", "PHP", "JS", "OC", "C"])])

        let dataSource = RxCollectionViewSectionedReloadDataSource
            <SectionModel<String, String>>(configureCell:{ (ds, cv, index, element) in
                let cell = cv.dequeueReusableCell(withReuseIdentifier: self.cellID, for: index) as! MyCollectionViewCell
                cell.contentLabel.text = "\(element)"
                return cell
            })

        items.bind(to: self.collectionView.rx.items(dataSource: dataSource)).disposed(by: bag)
        collectionView.rx.modelSelected(String.self).subscribe { (event) in
            print("\(event.element ?? "find nothing")")}.disposed(by: bag)
        }
    }



