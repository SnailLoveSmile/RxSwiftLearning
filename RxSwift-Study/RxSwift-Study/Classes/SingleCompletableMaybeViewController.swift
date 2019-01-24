//
//  SingleCompletableMaybeViewController.swift
//  RxSwift-Study
//
//  Created by apple on 2019/1/7.
//  Copyright © 2019 incich. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class SingleCompletableMaybeViewController: BaseViewController {
    enum DataError: Error {
        case cantParseJson
    }
    enum CacheLocalError:Error {
        case failedToCache
    }
    enum StringError: Error {
        case failedGenerate
    }
    let bag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        print("------single--------------single---------")

        getPlayList("22").subscribe { (event) in
            switch event {
            case .success(let json):
                print("json=\(json)")
            case .error(let error):
                print("error=\(error)")
            }
        }.disposed(by: bag)

        print("------completeable-------------completeable---------")
        cacheLocal().subscribe { (event) in
            switch event {
            case .completed:
                print("ok")
            case .error(let error):
                print(error)
            }
        }.disposed(by: bag)

        print("------maybe-------------maybe---------")

        //使用
        generateString().subscribe {maybe in
            switch maybe {
            case .success(let element):
                print("\(element)")
            case .completed:
                print("执行完成，但是没有任何元素")
            case .error(let error):
                print("\(error.localizedDescription)")
            }
            }.disposed(by: bag)
    }

}


//single: 要么发出一个元素要么产生一个error事件, 不会共享状态变化
/**
 enum SingleEvent<Element> {
    case success(Element)
    case error(Swift.Error)
}
 */
extension SingleCompletableMaybeViewController {


    func getPlayList(_ channel: String) -> Single<[String:Any]> {

        return Single<[String:Any]>.create(subscribe: { (single) -> Disposable in
             let url = "https://douban.fm/j/mine/playlist?type=n&channel=\(channel)&from=mainsite"
            let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { (data, _, error) in
                if let error = error {
                    single(.error(error))
                    return
                }
                guard let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves), let result = json as? [String:Any] else {
                    single(.error(DataError.cantParseJson))
                    return
                }
                single(.success(result))
            })
            task.resume()
            return Disposables.create{
                task.cancel()
            }
        })
    }
}

//completeabel: 要么complete要么error, 不共享状态变化
/*
 enum CompletableEvent {
 case error(Swift.Error)
 case completed
 }
 **/
extension SingleCompletableMaybeViewController {

    func cacheLocal() -> Completable {
        return Completable.create(subscribe: { (completeable) -> Disposable in
            let success = (arc4random() % 2 == 0)

            guard success else {
                completeable(.error(CacheLocalError.failedToCache))
                return Disposables.create()
            }
            completeable(.completed)

            return Disposables.create()
        })
    }
}

//Maybe: 要么只能发出一个元素，要么产生一个completed事件，要么产生一个error事件。适用于：可能需要发出一个元素，也可能不需要发出的情况。
/*
 enum MaybeEvent<Element> {
 case success<Element>
 case error(Swift.Error)
 case completed
 }
 */
extension SingleCompletableMaybeViewController {
    func generateString() -> Maybe<String> {
        return Maybe<String>.create { maybe in
            //成功并发出一个元素
            maybe(.success("manofit"))
            //成功但是不发出元素
            maybe(.completed)
            //失败
            maybe(.error(StringError.failedGenerate))

            return Disposables.create {
            }
        }
    }
}
