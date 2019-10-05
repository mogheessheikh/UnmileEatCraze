//
//  NetworkManager.swift
//  UnMile
//
//  Created by Adnan Asghar on 1/5/19.
//  Copyright © 2019 Adnan Asghar. All rights reserved.
//
import Foundation
import Alamofire
import SwiftyJSON


public class NetworkManager {

    class func getDetails(path: String, params: Parameters?, success:@escaping (JSON, Bool) -> Void, failure:@escaping (Error) -> Void) {

        AFManager.shared.requestURL(
            path,
            httpMethod: .get,
            params: params,
//            headers: getHeader(),

            success: { (json, isError) in
                success(json, isError)

        }) { (error) in
            failure(error)
        }
    }
    
//    class func postDetails(path: String, params: Parameters?, success:@escaping (JSON, Bool) -> Void, failure:@escaping (Error) -> Void) {
//
//        AFManager.shared.requestURL(
//            path,
//            httpMethod: .post,
//            params: params,
//            headers: [
//                "Content-Type": "application/json",
//                "Accept": "application/json"
//            ],
//
//            success: { (json, isError) in
//                success(json, isError)
//
//        }) { (error) in
//            failure(error)
//        }
//    }
   class func postDetails(path: URL, parameters: Parameters ){
        
        var request = URLRequest(url: path)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                    print(response)
            }
           
                
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])as? NSDictionary
                    let jsonData = try JSONSerialization.data(withJSONObject: json as Any, options: .prettyPrinted)
                    let encodedObjectJsonString = String(data: jsonData, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
                    let jsonData1 = encodedObjectJsonString.data(using: .utf8)
                    if let httpResponse = response as? HTTPURLResponse {
                        print("error \(httpResponse.statusCode)")
                        if httpResponse.statusCode == 200{
                            restResponse = true
                            
                        }
                    }
                    
                } catch {
                    print(error)
                }
            }
            
            }.resume()
        
    }
    
//   class func login(email: String, password: String, success:@escaping (JSON, Bool) -> Void, failure:@escaping (Error) -> Void) {
//
//        AFManager.shared.requestURL(
//            Path.loginPath,
//            httpMethod: .post,
//            params: ["username": email,
//                     "password": password,
//                     "grant_type": "password"],
//            headers: nil,
//
//            success: { (json, isError) in
//                success(json, isError)
//
//        }) { (error) in
//            failure(error)
//        }
//    }

//    class func refreshToken(refreshToken: String, success:@escaping (JSON, Bool) -> Void, failure:@escaping (Error) -> Void) {
//
//        AFManager.shared.requestURL(
//            Path.loginPath,
//            httpMethod: .post,
//            params: ["grant_type": "refresh_token",
//                     "refresh_token": refreshToken,
//                     "client_id": "DefaultClient"],
//            headers: nil,
//
//            success: { (json, isError) in
//                success(json, isError)
//
//        }) { (error) in
//            failure(error)
//        }
//    }

//    class func getUserInfo(token: String, success:@escaping (JSON, Bool) -> Void, failure:@escaping (Error) -> Void) {
//
//        AFManager.shared.requestURL(
//            Path.getUserInfo,
//            httpMethod: .get,
//            params: nil,
//            headers: getHeader(),
//
//            success: { (json, isError) in
//                debugPrint(json)
//                success(json, isError)
//
//        }) { (error) in
//            failure(error)
//        }
//    }

    class func registerAccount(firstName: String, lastName: String, email: String, password: String, phoneNumber: String, success:@escaping (JSON, Bool) -> Void, failure:@escaping (Error) -> Void) {

        let headers : HTTPHeaders = ["Content-Type":"application/json"]
        let params : Parameters = [//"branchId":"",
                                   "companyId":companyId,
                                   "customerType":"MEMBER",
                                   "email":email,
                                   "firstName":firstName,
                                   "internalInfo":"",
                                   "ipAddress":"",
                                   "lastName":lastName,
                                   "mobile":phoneNumber,
                                   "password":password,
                                   "phone":phoneNumber,
                                   "promotionEmail":"false",
                                   "promotionSms":"false",
                                   "registrationDate":"",
                                   "salt":"",
                                   "salutation":"",
                                   "status":1]

        AFManager.shared.requestURL(
            Path.customerUrl,
            httpMethod: .post,
            params: params,
            headers: headers,
            encoding: JSONEncoding.default,

            success: { (json, isError) in
                success(json, isError)

        }) { (error) in
            failure(error)
        }
    }

//    class func registerExternalAccount(email: String, firstName: String, lastName: String, username: String, userPlan: Int, source: String, providerKey: String, accessToken: String, success:@escaping (JSON, Bool) -> Void, failure:@escaping (Error) -> Void) {
//
//        AFManager.shared.requestURL(
//            Path.registerExternalAccount,
//            httpMethod: .post,
//            params: ["UserName": username,
//            "FirstName": firstName,
//            "LastName": lastName,
//            "Email": email,
//            "UserPlan": userPlan,
//            "LoginProvider": source,
//            "ProviderKey": providerKey
//            ],
//            headers: ["Authorization": "Bearer \(accessToken)"],
//
//            success: { (json, isError) in
//                success(json, isError)
//
//        }) { (error) in
//            failure(error)
//        }
//    }

//    class func verifyExternalAccess(provider: String, accessToken: String, providerKey: String, email: String, firstName: String, lastName: String, success:@escaping (JSON, Bool) -> Void, failure:@escaping (Error) -> Void) {
//
//        AFManager.shared.requestURL(
//            Path.verifyExternalToken,
//            httpMethod: .post,
//            params: ["LoginProvider": provider,
////                     "AccessToken": accessToken,
//                     "ProviderKey": providerKey,
//                     "Email": email,
//                     "FirstName": firstName,
//                     "LastName": lastName,
//                     ],
//            headers: nil,
//
//            success: { (json, isError) in
//                success(json, isError)
//
//        }) { (error) in
//            failure(error)
//        }
//    }

//    class func linkExternalAccount(provider: String, providerKey: String, email: String, success:@escaping (JSON, Bool) -> Void, failure:@escaping (Error) -> Void) {
//
//        AFManager.shared.requestURL(
//            Path.linkExternalAccount,
//            httpMethod: .post,
//            params: ["LoginProvider": provider,
//                     "ProviderKey": providerKey,
//                     "EmailAddress": email
//                     ],
//            headers: nil,
//
//            success: { (json, isError) in
//                success(json, isError)
//
//        }) { (error) in
//            failure(error)
//        }
//    }

//    class func createUserAccount(username: String, email: String, password: String, confirmPassword: String, code: String, success:@escaping (JSON, Bool) -> Void, failure:@escaping (Error) -> Void) {
//
//        AFManager.shared.requestURL(
//            Path.createUser,
//            httpMethod: .post,
//            params: [
//                "username": username,
//                "Email": email,
//                "Password": password,
//                "ConfirmPassword":  confirmPassword,
//                "isMobileRequest": true,
//                "code": code],
//            headers: nil,
//
//            success: { (json, isError) in
//                success(json, isError)
//
//        }) { (error) in
//            failure(error)
//        }
//    }

//    class func forgotPassword(email: String, success:@escaping (JSON, Bool) -> Void, failure:@escaping (Error) -> Void) {
//
//        AFManager.shared.requestURL(
//            Path.forgotPassword,
//            httpMethod: .post,
//            params: ["Email": email],
//            headers: nil,
//
//            success: { (json, isError) in
//                success(json, isError)
//
//        }) { (error) in
//            failure(error)
//        }
//    }

//    class func resetPassword(firstName: String, lastName: String, email: String,password: String, confirmPassword: String, code: String, timeZone: String, startDayOfWeek: String, pictureURL: String, country: String, success:@escaping (JSON, Bool) -> Void, failure:@escaping (Error) -> Void) {
//
//        AFManager.shared.requestURL(
//            Path.resetPassword,
//            httpMethod: .post,
//            params: ["eMail": email,
//                     "password": password,
//                     "confirmPassword": confirmPassword],
//            headers: nil,
//
//            success: { (json, isError) in
//                success(json, isError)
//
//        }) { (error) in
//            failure(error)
//        }
//    }


//    class func selectPlan(userPlan: Int, success:@escaping (JSON, Bool) -> Void, failure:@escaping (Error) -> Void) {
//
//        AFManager.shared.requestURL(
//            Path.selectPlan,
//            httpMethod: .post,
//            params: ["userPlan": userPlan],
//            headers: getHeader(),
//
//            success: { (json, isError) in
//                success(json, isError)
//
//        }) { (error) in
//            failure(error)
//        }
//    }

//    class func changePassword(oldPassword: String, newPassword: String, confirmPassword: String, success:@escaping (JSON, Bool) -> Void, failure:@escaping (Error) -> Void) {
//
//        AFManager.shared.requestURL(
//            Path.changePassword,
//            httpMethod: .post,
//            params: ["oldPassword": oldPassword,
//                     "newPassword" : newPassword,
//                     "confirmPassword" : confirmPassword],
//            headers: getHeader(),
//
//            success: { (json, isError) in
//                success(json, isError)
//
//        }) { (error) in
//            failure(error)
//        }
//    }

//    class func saveProfile(firstName: String, lastName: String, phoneNumber: String, industry: String, jobRole: String, country: String, success:@escaping (JSON, Bool) -> Void, failure:@escaping (Error) -> Void) {
//
//        AFManager.shared.requestURL(
//            Path.saveProfile,
//            httpMethod: .post,
//            params: ["FirstName" : firstName,
//                     "LastName" : lastName,
//                     "jobTitle" : jobRole,
//                     "PhoneNumber" : phoneNumber,
//                     "industry" : industry,
//                     "country" : country],
//            headers: getHeader(),
//
//            success: { (json, isError) in
//                success(json, isError)
//
//        }) { (error) in
//            failure(error)
//        }
//    }

//    class func searchUserTasks(params: [String : Any]?, success:@escaping (JSON, Bool) -> Void, failure:@escaping (Error) -> Void) {
//
//        AFManager.shared.requestURL(
//            Path.searchUserTasks,
//            httpMethod: .post,
//            params: params,
//            headers: getHeader(),
//
//            success: { (json, isError) in
//                success(json, isError)
//
//        }) { (error) in
//            failure(error)
//        }
//    }

//    class func getSummary(params: [String : Any]?, success:@escaping (JSON, Bool) -> Void, failure:@escaping (Error) -> Void) {
//
//        AFManager.shared.requestURL(
//            Path.getSummary,
//            httpMethod: .get,
//            params: params,
//            headers: getHeader(),
//
//            success: { (json, isError) in
//                success(json, isError)
//
//        }) { (error) in
//            failure(error)
//        }
//    }

//    class func saveUserTask(params: [String : Any]?, success:@escaping (JSON, Bool) -> Void, failure:@escaping (Error) -> Void) {
//
//        AFManager.shared.requestURL(
//            Path.saveUserTask,
//            httpMethod: .post,
//            params: params,
//            headers: getHeader(),
//
//            success: { (json, isError) in
//                success(json, isError)
//
//        }) { (error) in
//            failure(error)
//        }
//    }

//    class func saveUserTask(aTask: UserTask, success:@escaping (JSON, Bool) -> Void, failure:@escaping (Error) -> Void) {
//
//        AFManager.shared.requestURL(
//            Path.saveUserTask,
//            httpMethod: .post,
//            params: aTask.getDictionary() as [String: AnyObject],
//            headers: getHeader(),
//
//            success: { (json, isError) in
//                success(json, isError)
//
//        }) { (error) in
//            failure(error)
//        }
//    }

//    class func saveRepeatTask(repetition: Repetition, success:@escaping (JSON, Bool) -> Void, failure:@escaping (Error) -> Void) {
//
//        AFManager.shared.requestURL(
//            Path.saveUserTask,
//            httpMethod: .post,
//            params: repetition.getDictionary(),
//            headers: [
//                "Authorization": "Bearer \(UserDefault.getAccessToken())",
//                "Accept": "application/json",
//                //"Content-Type": "application/json"
//            ],
//
//            success: { (json, isError) in
//                success(json, isError)
//
//        }) { (error) in
//            failure(error)
//        }
//    }

//    class func getAllProjects(params: [String : Any]?, success:@escaping (JSON, Bool) -> Void, failure:@escaping (Error) -> Void) {
//
//        AFManager.shared.requestURL(
//            Path.getAllProjects,
//            httpMethod: .post,
//            params: params,
//            headers: getUpdatedHeader(),
//
//            success: { (json, isError) in
//                success(json, isError)
//
//        }) { (error) in
//            failure(error)
//        }
//    }

//    class func getAllProjects(path: String, params: [String : Any]?, success:@escaping (JSON, Bool) -> Void, failure:@escaping (Error) -> Void) {
//
//        AFManager.shared.requestURL(
//            path,
//            httpMethod: .get,
//            params: params,
//            headers: getUpdatedHeader(),
//
//            success: { (json, isError) in
//                success(json, isError)
//
//        }) { (error) in
//            failure(error)
//        }
//    }

//    class func getProjectDetails(params: [String : Any]?, success:@escaping (JSON, Bool) -> Void, failure:@escaping (Error) -> Void) {
//
//        AFManager.shared.requestURL(
//            Path.getProjectDetails,
//            httpMethod: .get,
//            params: params,
//            headers: getHeader(),
//
//            success: { (json, isError) in
//                success(json, isError)
//
//        }) { (error) in
//            failure(error)
//        }
//    }

//    class func getAvailableProjectTasks(params: [String : Any]?, success:@escaping (JSON, Bool) -> Void, failure:@escaping (Error) -> Void) {
//
//        AFManager.shared.requestURL(
//            Path.getAvailableProjectTasks,
//            httpMethod: .get,
//            params: params,
//            headers: getHeader(),
//
//            success: { (json, isError) in
//                success(json, isError)
//
//        }) { (error) in
//            failure(error)
//        }
//    }

//    class func saveProject(projectName: String, tasks: [String], success:@escaping (JSON, Bool) -> Void, failure:@escaping (Error) -> Void) {
//
//        AFManager.shared.requestURL(
//            Path.saveProject,
//            httpMethod: .post,
//            params: [
//                "projectName"   : projectName,
//                "projectTasks"  : tasks,
//                ],
//            headers: getHeader(),
//
//            success: { (json, isError) in
//                success(json, isError)
//
//        }) { (error) in
//            failure(error)
//        }
//    }

//    class func performTaskAction(path: String, taskId: String, success:@escaping (JSON, Bool) -> Void, failure:@escaping (Error) -> Void) {
//
//        AFManager.shared.requestURL(
//            path,
//            httpMethod: .get,
//            params: ["taskid": taskId],
//            headers: getHeader(),
//
//            success: { (json, isError) in
//                success(json, isError)
//
//        }) { (error) in
//            failure(error)
//        }
//    }

//    class func getMeetings(parameters: [String: Any], success:@escaping (JSON, Bool) -> Void, failure:@escaping (Error) -> Void) {
//
//        AFManager.shared.requestURL(
//            Path.getMeetingBoardMeetings,
//            httpMethod: .post,
//            params: parameters,
//            headers: getHeader(),
//
//            success: { (json, isError) in
//                success(json, isError)
//
//        }) { (error) in
//            failure(error)
//        }
//    }

//    class func markTaskAsStarred(taskId: String, isStarred: Bool, success:@escaping (JSON, Bool) -> Void, failure:@escaping (Error) -> Void) {
//
//        AFManager.shared.requestURL(
//            Path.markAsStarredTask,
//            httpMethod: .post,
//            params: ["taskid": taskId,
//                     "MarkStar": NSNumber(value: isStarred)],
//            headers: getHeader(),
//
//            success: { (json, isError) in
//                success(json, isError)
//
//        }) { (error) in
//            failure(error)
//        }
//    }

//    class func uploadImage(taskId: String, image: UIImage, success:@escaping (JSON, Bool) -> Void, failure:@escaping (Error) -> Void) {
//
//        let base64String = image.toBase64String(maxSizeInMB: 1)
//
//        AFManager.shared.requestURL(
//            Path.uploadFile,
//            httpMethod: .post,
//            params: [
//                "ObjectId": taskId,
//                "ObjectType": "Task",
//                "FileBase64String": base64String,
//                "FileType": "png"
//            ],
//            headers: getHeader(),
//            success: { (json, isError) in
//                success(json, isError)
//
//        }) { (error) in
//            failure(error)
//        }
//    }

//    class func saveCommentAndAttachment(fileName: String, fileBase64String: String, fileType: String, taskId: String, commentText: String, objectType: String, commentType: String, commentEntryType: String, success:@escaping (JSON, Bool) -> Void, failure:@escaping (Error) -> Void) {
//
//        AFManager.shared.requestURL(
//            Path.saveComment,
//            httpMethod: .post,
//            params: [
//                "FileName": fileName,
//                "FileBase64String": fileBase64String,
//                "FileType": fileType,
//                "ObjectId": taskId,
//                "CommentText": commentText,
//                "ObjectType": objectType,
//                "CommentType": commentType,
//                "CommentEntryType": commentEntryType
//            ],
//            headers: getUpdatedHeader(),
//
//            success: { (json, isError) in
//                success(json, isError)
//
//        }) { (error) in
//            failure(error)
//        }
//    }

//    class func saveAttachment(taskId: String, documentName: String, documentDescription: String, documentType: String, documentPath: String, success:@escaping (JSON, Bool) -> Void, failure:@escaping (Error) -> Void) {
//
//        AFManager.shared.requestURL(
//            Path.saveAttachments,
//            httpMethod: .post,
//            params: [
//                "taskid"            : taskId,
//                "DocsName"          : documentName,
//                "DocsDescription"   : documentDescription,
//                "DocsType"          : documentType,
//                "DocsPath"          : documentPath,//filename
//            ],
//            headers: getHeader(),
//
//            success: { (json, isError) in
//                success(json, isError)
//
//        }) { (error) in
//            failure(error)
//        }
//    }

//    class func saveComment(taskId: String, commentId: String/*undefined*/, commentText: String/*somefilename.png*/, fileCommentId: String, commentType: String, success:@escaping (JSON, Bool) -> Void, failure:@escaping (Error) -> Void) {
//
//        AFManager.shared.requestURL(
//            Path.saveComment,
//            httpMethod: .post,
//            params: [
//                "CommentId"     : commentId,
//                "CommentText"   : commentText,
//                "TaskId"        : taskId,
//                "FileCommentId" : fileCommentId,
//                "CommentType"   : commentType,
//            ],
//            headers: getHeader(),
//
//            success: { (json, isError) in
//                success(json, isError)
//
//        }) { (error) in
//            failure(error)
//        }
//    }

//    class func repeatTask(taskId: String, dailyInterval: Int, weeklyInterval: Int, monthlyInterval: Int, endBy: String, numberOfTasks: Int, selectedWeekDays: [String], dayOfMonthlyInterval: Int, weekOfMonth: Int, dayOfWeek: String, monthlyIntervalType: String, repeatTaskFrequency: String, endDate: String, success:@escaping (JSON, Bool) -> Void, failure:@escaping (Error) -> Void) {
//
//        var parameters: [String : Any] = ["taskid": taskId,
//                                          "repeatTaskFrequency": repeatTaskFrequency,
//                                          "dailyInterval": 1,
//                                          "weeklyInterval": 1,
//                                          "monthlyInterval": 1]
//
//        if repeatTaskFrequency == "Daily" {
//            parameters["dailyInterval"] = dailyInterval
//        } else if repeatTaskFrequency == "Weekly" {
//            parameters["weeklyInterval"] = weeklyInterval
//            parameters["selectedWeekDays"] = selectedWeekDays
//        } else if repeatTaskFrequency == "Monthly" {
//            parameters["monthlyInterval"] = monthlyInterval
//            parameters["monthlyIntervalType"] = monthlyIntervalType
//
//            if monthlyIntervalType == "SelectDay" {
//                parameters["dayOfMonthlyInterval"] = dayOfMonthlyInterval
//            } else {
//                parameters["weekOfMonth"] = weekOfMonth
//                parameters["dayOfWeek"] = dayOfWeek
//            }
//        }
//
//        if repeatTaskFrequency != "Never" {
//
//            parameters["endBy"] = endBy
//
//            if endBy == "Date" {
//                parameters["endDate"] = endDate
//            } else {
//                parameters["numberOfTasks"] = numberOfTasks
//            }
//        }
//
//        AFManager.shared.requestURL(
//            Path.repeatTask,
//            httpMethod: .post,
//            params: parameters,
//            headers: getHeader(),
//
//            success: { (json, isError) in
//                success(json, isError)
//
//        }) { (error) in
//            failure(error)
//        }
//    }

//    class func saveMeeting(meetingName:String, taskId: String, location: String, startDate:String, startTime: String, durationHours: Int, durationMins: Int, dailyInterval: Int, weeklyInterval: Int, monthlyInterval: Int, endBy: String, numberOfTasks: Int, selectedWeekDays: [String], dayOfMonthlyInterval: Int, weekOfMonth: Int, dayOfWeek: String, monthlyIntervalType: String, repeatTaskFrequency: String, endDate: String, success:@escaping (JSON, Bool) -> Void, failure:@escaping (Error) -> Void) {
//
//        var parameters: [String : Any] = ["meetingDisplayName": meetingName,
//                                          "taskid": taskId,
//                                          "location": location,
//                                          "startDate": startDate,
//                                          "startTime": startTime,
//                                          "endDate": startDate,
//                                          "durationHours": durationHours,
//                                          "durationMins": durationMins,
//                                          "meetingFrequency": repeatTaskFrequency,
//                                          "dailyInterval": 1,
//                                          "weeklyInterval": 1,
//                                          "monthlyInterval": 1]
//
//        if repeatTaskFrequency == "Daily" {
//            parameters["dailyInterval"] = dailyInterval
//        } else if repeatTaskFrequency == "Weekly" {
//            parameters["weeklyInterval"] = weeklyInterval
//            parameters["selectedWeekDays"] = selectedWeekDays
//        } else if repeatTaskFrequency == "Monthly" {
//            parameters["monthlyInterval"] = monthlyInterval
//            parameters["monthlyIntervalType"] = monthlyIntervalType
//
//            if monthlyIntervalType == "SelectDay" {
//                parameters["dayOfMonthlyInterval"] = dayOfMonthlyInterval
//            } else {
//                parameters["weekOfMonth"] = weekOfMonth
//                parameters["dayOfWeek"] = dayOfWeek
//            }
//        }
//
//        if repeatTaskFrequency != "NoRecurrence" {
//
//            parameters["endBy"] = endBy
//
//            if endBy == "Date" {
//                parameters["endDate"] = endDate
//            } else {
//                parameters["numberOfMeetings"] = numberOfTasks
//            }
//        }
//
//        AFManager.shared.requestURL(
//            Path.saveMeeting,
//            httpMethod: .post,
//            params: parameters,
//            headers: getHeader(),
//
//            success: { (json, isError) in
//                success(json, isError)
//
//        }) { (error) in
//            failure(error)
//        }
//    }

//    class func saveTimeZone(timeZone: String, success:@escaping (JSON, Bool) -> Void, failure:@escaping (Error) -> Void) {
//
//        AFManager.shared.requestURL(
//            Path.saveTimeZone,
//            httpMethod: .get,
//            params: ["timeZone": timeZone],
//            headers: getHeader(),
//
//            success: { (json, isError) in
//                success(json, isError)
//
//        }) { (error) in
//            failure(error)
//        }
//    }

//    class func editProjectName(projectId: String, editProjectName: String, success:@escaping (JSON, Bool) -> Void, failure:@escaping (Error) -> Void) {
//
//        AFManager.shared.requestURL(
//            Path.editProjectName,
//            httpMethod: .get,
//            params: ["projectId": projectId,
//                     "editProjectName": editProjectName],
//            headers: getHeader(),
//
//            success: { (json, isError) in
//                success(json, isError)
//
//        }) { (error) in
//            failure(error)
//        }
//    }

//    class func saveFilter(parameters: [String: Any], success:@escaping (JSON, Bool) -> Void, failure:@escaping (Error) -> Void) {
//
//        AFManager.shared.requestURL(
//            Path.saveFilter,
//            httpMethod: .post,
//            params: parameters,
//            headers: getHeader(),
//
//            success: { (json, isError) in
//                success(json, isError)
//
//        }) { (error) in
//            failure(error)
//        }
//    }

//    class func deleteProject(projectId: String, success:@escaping (JSON, Bool) -> Void, failure:@escaping (Error) -> Void) {
//
//        AFManager.shared.requestURL(
//            Path.deleteProject,
//            httpMethod: .get,
//            params: ["projectId": projectId],
//            headers: getHeader(),
//
//            success: { (json, isError) in
//                success(json, isError)
//
//        }) { (error) in
//            failure(error)
//        }
//    }

//    class func copyProject(projectId: String, copiedProjectName: String, taskPrefix: String, success:@escaping (JSON, Bool) -> Void, failure:@escaping (Error) -> Void) {
//
//        AFManager.shared.requestURL(
//            Path.copyProject,
//            httpMethod: .get,
//            params: ["projectId": projectId,
//                     "copiedProjectName": copiedProjectName,
//                     "appendTask": taskPrefix],
//            headers: getHeader(),
//
//            success: { (json, isError) in
//                success(json, isError)
//
//        }) { (error) in
//            failure(error)
//        }
//    }

//    class func saveStartDayOfWeek(selectedWeekDay: String, success:@escaping (JSON, Bool) -> Void, failure:@escaping (Error) -> Void) {
//
//        AFManager.shared.requestURL(
//            Path.saveStartDayOfWeek,
//            httpMethod: .get,
//            params: ["dayOfWeek": selectedWeekDay],
//            headers: getHeader(),
//
//            success: { (json, isError) in
//                success(json, isError)
//
//        }) { (error) in
//            failure(error)
//        }
//    }

//    class func searchFromAPI(query: String, success:@escaping (JSON, Bool) -> Void, failure:@escaping (Error) -> Void) {
//
//        AFManager.shared.requestURL(
//            Path.dynamicSearch,
//            httpMethod: .get,
//            params: ["searchQuery" : query],
//            headers: getHeader(),
//
//            success: { (json, isError) in
//                success(json, isError)
//
//        }) { (error) in
//            failure(error)
//        }
//    }

//    class func saveFirebaseDeviceToken(fcmToken: String, success:@escaping (JSON, Bool) -> Void, failure:@escaping (Error) -> Void) {
//
//        AFManager.shared.requestURL(
//            Path.saveFireBaseDeviceToken,
//            httpMethod: .post,
//            params: ["FirebaseDeviceId": fcmToken,
//                     "DeviceType" : "IOS"],
//            headers: getHeader(),
//
//            success: { (json, isError) in
//                success(json, isError)
//
//        }) { (error) in
//            failure(error)
//        }
//    }

//    class func logoutAccount(success:@escaping (JSON, Bool) -> Void, failure:@escaping (Error) -> Void) {
//
//        AFManager.shared.requestURL(
//            Path.logoutAccount,
//            httpMethod: .post,
//            params: nil,
//            headers: getHeader(),
//
//            success: { (json, isError) in
//                success(json, isError)
//
//        }) { (error) in
//            failure(error)
//        }
//    }

//    class func getActivityLog(parameters: [String:Any], success:@escaping (JSON, Bool) -> Void, failure:@escaping (Error) -> Void) {
//
//        AFManager.shared.requestURL(
//            Path.getActivityLog,
//            httpMethod: .get,
//            params: parameters,
//            headers: getHeader(),
//
//            success: { (json, isError) in
//                success(json, isError)
//
//        }) { (error) in
//            failure(error)
//        }
//    }

//    class func sendInvitationEmail(with email: String, success:@escaping (JSON, Bool) -> Void, failure:@escaping (Error) -> Void) {
//
//        AFManager.shared.requestURL(
//            Path.sendInvitationEmail,
//            httpMethod: .post,
//            params: ["Email": email],
//            headers: getHeader(),
//
//            success: { (json, isError) in
//                success(json, isError)
//
//        }) { (error) in
//            failure(error)
//        }
//    }

//    class func uploadProfileImage(image: UIImage, success:@escaping (JSON, Bool) -> Void, failure:@escaping (Error) -> Void) {
//
//        let base64String = image.toBase64String(maxSizeInMB: 1)
//
//        AFManager.shared.requestURL(
//            Path.uploadProfileImage,
//            httpMethod: .post,
//            params: [
//                "FileBase64String": base64String,
//                "FileType": "png"
//            ],
//            headers: getHeader(),
//            success: { (json, isError) in
//                success(json, isError)
//
//        }) { (error) in
//            failure(error)
//        }
//    }

//    class func downloadAttachmentFile(filePath: String, fileName: String, success:@escaping (JSON, Bool) -> Void, failure:@escaping (Error) -> Void) {
//        AFManager.shared.requestFileDownload(
//            Path.downloadFiles,
//            httpMethod: .get,
//            params: ["url" : filePath,
//                     "fileName" : filePath
//            ],
//            headers: nil,
//
//            success: { (json, isError) in
//                success(json, isError)
//
//        }) { (error) in
//            failure(error)
//        }
//    }

//    class func update(preferences: String, success:@escaping (JSON, Bool) -> Void, failure:@escaping (Error) -> Void) {
//
//        var header = getUpdatedHeader()
//        header!["Content-Type"] = "application/x-www-form-urlencoded"
//
//        AFManager.shared.requestURL(
//            Path.updateUserPreferences,
//            httpMethod: .post,
//            params: ["updatePreferencesListString": preferences],
//            headers: [
//                "Authorization": "Bearer \(UserDefault.getAccessToken())",
////                "Accept": "application/json",
//                "platform": "IOS"
//            ],
//            success: { (json, isError) in
//                success(json, isError)
//
//        }) { (error) in
//            failure(error)
//        }
//    }
}

extension NetworkManager {
    
//    class func getHeader() -> [String: String]? {
//
//        print("Bearer \(UserDefault.getAccessToken())")
//
//        return [
//            "Authorization": "Bearer \(UserDefault.getAccessToken())",
//            "Accept": "application/json",
////            "Content-Type": "application/json"
//        ]
//    }

//    class func getUpdatedHeader() -> [String: String]? {
//
//        print("Bearer \(UserDefault.getAccessToken())")
//
//        return [
//            "Authorization": "Bearer \(UserDefault.getAccessToken())",
//            "Accept": "application/json",
//            "platform": "IOS"
//        ]
//    }

    func getJSON(anArray: Any) -> String {
        if let theJSONData = try? JSONSerialization.data(withJSONObject: anArray, options: []), let theJSONText = String(data: theJSONData, encoding: .utf8) {
            print("JSON string = \(theJSONText)")
            return theJSONText
        } else {
            return ""
        }
    }
}

enum ServerURLs {
    static let stagingURL           = "http://130.211.192.1:8082/rest"
    static let productionURL        = "http://35.153.13.41:8082/rest"
    static let googleServerURL      = "http://35.243.235.232:8082/rest"

}

enum Path {
    static let companyUrl                = ServerURLs.stagingURL + "/company"
    static let companyCityUrl            = ServerURLs.stagingURL + "/companycity"
    static let branchUrl                 = ServerURLs.stagingURL + "/branch"
    static let menuUrl                   = ServerURLs.stagingURL + "/menu"
    static let customerUrl               = ServerURLs.stagingURL + "/customer"
    static let addressUrl                = ServerURLs.stagingURL + "/address"
    static let transIdUrl                = ServerURLs.stagingURL + "/transid"
    static let customerOrderUrl          = ServerURLs.stagingURL + "/customer-order"
}

