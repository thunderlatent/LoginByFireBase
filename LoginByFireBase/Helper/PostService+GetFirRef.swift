//
//  PostService+GetFirRef.swift
//  FirebaseDemo
//
//  Created by Jimmy on 2020/11/5.
//  Copyright © 2020 AppCoda. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseStorage
protocol GetFirRef {
    func baseDbRef() -> DatabaseReference
    func postDbRef() -> DatabaseReference
    func photoStorageRef() -> StorageReference

}
extension GetFirRef
{
    func baseDbRef() -> DatabaseReference
    {
        return PostService.shared.baseDbRef()
    }
    
    func postDbRef() -> DatabaseReference
    {
        return PostService.shared.postDbRef()
    }
    
    func photoStorageRef() -> StorageReference
    {
        return PostService.shared.photoStorageRef()
    }
    
}
