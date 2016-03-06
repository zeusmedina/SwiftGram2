//
//  UserData.swift
//  SwiftGram
//
//  Created by zeus medina on 3/5/16.
//  Copyright © 2016 Zeus. All rights reserved.
//

import UIKit
import Parse

class UserData: NSObject {
    func postNewImage(image: UIImage?, withCaption caption: String?, withCompletion completion: PFBooleanResultBlock?) {
        
        let data = PFObject(className: "UserData")
        
        data["image"] = getImage(image)
        
        data["author"] = PFUser.currentUser()
        
        data["caption"] = caption
        
        // Save the media object to the server after we have set the fields
        data.saveInBackgroundWithBlock(completion)
        
    }
    
    
    //PFFile represents any sort of file type on Parse, in this case an image.
    func getImage(image: UIImage?) -> PFFile? {
        if let image = image {
            if let imageData = UIImagePNGRepresentation(image) {
                return PFFile(name: "image.png", data: imageData)
            }
        }
        
        //Error in image passed
        NSLog("Error in returning PNG iamge")
        return nil
    }

}
