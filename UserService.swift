//

//

import Foundation
import UIKit


public class UserService:APIService {
    
    // #show and hide loader in this class depending on your needs.
    // #you can make service class according to module
    // #show errors in this class, if you have any need where you want to show in controller class, then just by-pass error method.
    

    func getFactslist(target:UIViewController? = nil,complition:@escaping (Any?) -> Void){
//        target?.showLoader()
        super.startService(with: .GET, parameters: nil,files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let response):
                    // #parse response here
                    if let data = response{
                        complition(data)
                    } else {
                        complition(nil)
                    }
                case .Error(let _):
                    // #display error message here
                    complition(nil)
                }
            }
        }
}

    
}

