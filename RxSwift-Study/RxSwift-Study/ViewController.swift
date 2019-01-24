//
//  ViewController.swift
//  RxSwift-Study
//
//  Created by apple on 2019/1/4.
//  Copyright © 2019 incich. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

struct Project {
    let title: String
}
struct ProjectListModel {
    let data = Observable<[Project]>.just([
        Project(title: "Observable介绍, 创建可观察序列"),
        Project(title: "Observable订阅、事件监听、订阅销毁"),
        Project(title: "观察者1:AnyObserver、Binder"),
        Project(title: "观察者2:自定义可绑定属性"),
        Project(title: "Subjects、BehaviorRelay"),
        Project(title: "变换操作符：buffer、map、flatMap、scan等"),
        Project(title: "过滤操作符：filter、take、skip等"),
        Project(title: "结合操作符：startWith、merge、zip等"),
        Project(title: "算数&聚合操作符：toArray、reduce、concat"),
        Project(title: "连接操作符：connect、publish、replay、multicast"),
        Project(title: "其他操作符：delay、materialize、timeout等"),
        Project(title: "错误处理"),
        Project(title: "调试操作"),
        Project(title: "特征序列1：Single、Completable、Maybe"),
        Project(title: "特征序列2：Driver"),
        Project(title: "特征序列3：ControlProperty、 ControlEvent"),
        Project(title: "给 UIViewController 添加 RxSwift 扩展"),
        Project(title: "调度器、subscribeOn、observeOn"),
        Project(title: "UI控件扩展1：UILabel"),
        Project(title: "UI控件扩展2：UITextField、UITextView"),
        Project(title: "UI控件扩展3：UIButton、UIBarButtonItem"),
        Project(title: "UI控件扩展4：UISwich, UISegmentControl"),
        Project(title: "UI控件扩展5：GestureRecognizerViewController"),
         Project(title: "UI控件扩展6：UIDatePickerController"),
         Project(title: "双向绑定"),
         Project(title: "UITableViewController"),
         Project(title: "UICollectionViewController"),
         Project(title: "RxAlamofire-01-简单介绍"),
         Project(title: "RxAlamofire-02-JSON"),
         Project(title: "RxAlamofire-03-Model"),
         Project(title: "RxMoya-01-简单介绍"),
         Project(title: "RxMoya-02-JSON"),
         Project(title: "RxMoya-03-Model"),
         Project(title: "MVVM - 注册界面")
        ])
}


class ViewController: UIViewController {


    @IBOutlet weak var tableView: UITableView!
    let projectListModel = ProjectListModel()
   public let bag = DisposeBag()
    func pushTo(_ vc: UIViewController, project: Project) {
        vc.title = project.title
        self.navigationController?.pushViewController(vc, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "RxSwift"

        projectListModel.data.bind(to: (tableView.rx.items(cellIdentifier: "cellid")))
        {
            (index, project, cell) in

            cell.textLabel?.text = String(format: "%02d--", index + 1) + project.title
            cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
            }.disposed(by: bag)


        Observable.zip(tableView.rx.modelSelected(Project.self), tableView.rx.itemSelected).subscribe(onNext:{ [weak self] project, indexPath in
            switch indexPath.row {

            case 0:
                self?.pushTo(ObservableIntroduceCreateViewController(),project: project)
            case 1:
                self?.pushTo(ObservableSubscribeDoonDisposeViewController(),project: project)
            case 2:
                self?.pushTo(AnyObserverBinderViewController(),project: project)
            case 3:
                self?.pushTo(CustomBindablePropertyViewController(),project: project)
            case 4:
                self?.pushTo(SubjectsViewController(), project: project)
            case 5:
                self?.pushTo(BufferMapFlatMapScanViewController(), project: project)
            case 6:
                self?.pushTo(FilterTakeSkipViewController(), project: project)
            case 7:
                self?.pushTo(StartWithMergeZipViewController(), project: project)
            case 8:
                self?.pushTo(ToArrayReduceConcatViewController(), project: project)
            case 9:
                self?.pushTo(ConnectPublishReplayMulticastViewController(), project: project)
            case 10:
                self?.pushTo(DelayMaterializeTimeoutViewController(), project: project)
            case 11:
                self?.pushTo(ErrorHandlerViewController(), project: project)
            case 12:
                self?.pushTo(DebuggingViewController(), project: project)
            case 13:
                self?.pushTo(SingleCompletableMaybeViewController(), project: project)
            case 14:
                self?.pushTo(DriverViewController(), project: project)

            case 15:
                self?.pushTo(ControlPropetyControlEventViewController(), project: project)
            case 16:
                self?.pushTo(UIViewControllerRxExtendViewController(), project: project)
            case 17:
                self?.pushTo(SubscribeOnObserveOnViewController(), project: project)
            case 18:
                self?.pushTo(UILabelViewController(), project: project)
            case 19:
                self?.pushTo(UITextFieldUITextViewViewController(), project: project)
            case 20:
                self?.pushTo(UIButtonUIBarButtonItemViewController(), project: project)
            case 21:
                self?.pushTo(UISwitchAndSegmentController(), project: project)
            case 22:
                self?.pushTo(GestureRecognizerViewController(), project: project)
            case 23:
                self?.pushTo(CTimerViewController(), project: project)
            case 24:
                self?.pushTo(BBViewController(), project: project)
            case 25:
                self?.pushTo(TableViewController(), project: project)
            case 26:
                self?.pushTo(CollectionViewController(), project: project)
            case 27:
                self?.pushTo(RxAlamofireViewController(), project: project)
            case 28:
                self?.pushTo(RxAlamofireJsonViewController(), project: project)
            case 29:
                self?.pushTo(RxAlamofireCViewController(), project: project)
            case 30:
                self?.pushTo(RxMoyaViewController(), project: project)
            case 31:
                self?.pushTo(RxMoyaJsonViewController(), project: project)
            case 32:
                self?.pushTo(RxMoyaCViewController(), project: project)
            case 33:
                self?.pushTo(SignupViewController(), project: project)

            default:
                print("no way")
            }
        }).disposed(by: bag)

    }

}

