//
//  Lf_Binder.swift
//  Jellyfish
//
//  Created by halo vv on 2018/8/30.
//  Copyright © 2018年 liufeng. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift


public extension Binder {
    public static func bind<T: Comparable>(item1: BehaviorRelay<T>,item2: BehaviorRelay<T>,disposeBy: DisposeBag) {
        item1.distinctUntilChanged().subscribe(onNext: {
            if $0 != item1.value {
                item2.accept($0)
            }
        }).disposed(by: disposeBy)
        item2.distinctUntilChanged().subscribe(onNext: {
            if $0 != item1.value {
                item1.accept($0)
            }
        }).disposed(by: disposeBy)
    }
}
