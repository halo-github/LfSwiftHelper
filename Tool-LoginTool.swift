//
//  Lf_LoginTool.swift
//  Jellyfish
//
//  Created by halo vv on 2018/9/21.
//  Copyright © 2018年 liufeng. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

typealias PlatformResponseHandler = (UMSocialPlatformType, UMSocialUserInfoResponse)-> Void
protocol Lf_UMLoginTool {
    var currentPlatform: UMSocialPlatformType {get set}
    
//    var platformLoginHandler: PlatformResponseHandler {get}
//    var platformLogoutHandler: VoidHandler {get}
    func platformLogin(platform: UMSocialPlatformType)
    func platformLogout(platform: UMSocialPlatformType)
    func platformLogin(response: UMSocialUserInfoResponse,from: UMSocialPlatformType)
    func platformLogout(from: UMSocialPlatformType)
}

extension Lf_UMLoginTool {
     func platformLogin(platform: UMSocialPlatformType){
        let now = Date()
//        UIWindow.showActivityIndicator()
        UMSocialManager.default().getUserInfo(with: platform, currentViewController: nil) { (response, err) in
//            UIWindow.hideActivityIndicator()
            print("interval---\(Date().timeIntervalSince(now))")
//            print(Date().timeIntervalSince(now))
            if err != nil {
                print(err?.localizedDescription)
            } else {
                if let resp = response as? UMSocialUserInfoResponse {
                    print(resp.accessToken)
                        self.platformLogin(response: resp, from: platform)

                }
            }
        }
    }
    
    
    func platformLogout(platform: UMSocialPlatformType){
        self.platformLogout(from: platform)
    }
    
}


typealias ObservableHandler = (PublishSubject<Any>)->Void

class Lf_UserPwdLoginTool: RXProtocol {
    var input: Lf_UserPwdLoginTool.UserPwd
    
    var output: Lf_UserPwdLoginTool.Output
    
    var loginBtn: UIButton?
    

    var checkInput: (()->Bool)?
    
    

    
    struct UserPwd {
        var user: Observable<String>
        var pwd: Observable<String>
    }
    
    
    
    typealias Input = UserPwd
    
    typealias Output = PublishSubject<Any>
    
    
    init(userInput: UITextField, pwdInput: UITextField, loginButton: UIButton) {
        self.input = Input(user: userInput.rx.text.orEmpty.map{$0}, pwd: pwdInput.rx.text.orEmpty.map{$0})
        self.loginBtn  = loginButton
        self.output = Lf_UserPwdLoginTool.Output()
        
    }
    
    func loginTap(_ loginAction:@escaping ObservableHandler) -> PublishSubject<Any>{
        self.loginBtn!.rx.tap
        //            .throttle(0.5, scheduler: MainScheduler.instance)
                    .do(onNext:{
                        if self.checkInput != nil{
                            if self.checkInput!() == false {return}
                        }
                        self.loginBtn!.isEnabled = false
                        loginAction(self.output)
                    })
                    .withLatestFrom(self.output)                //等待output
                    .subscribe { _ in
                        self.loginBtn!.isEnabled = true
                }.disposed(by: self.loginBtn!.bag)
        return self.output
    }

    
    
    func post(user: String, pwd: String,completion: ([String: Any], Bool)->Void){
        print(user,pwd)
        completion(["name": "halo"],true)
    }
    

}
