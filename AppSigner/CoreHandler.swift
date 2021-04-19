import Foundation
import AppKit
import Darwin
import SwiftShell

public class Corehandler {

    let prapperation = Preparation()
  
    func start() -> String? {
        
        let debugOption = Preparation().debugRelease(debugOption: prapperation.debug)
        
        let fileHandler = FileHandler(preperation: self.prapperation)

        fileHandler.createAssetsDir()
        fileHandler.createConfigDir()

        let checkJsonResult: String = fileHandler.checkJson()

        let jsonFileAt = fileHandler.getScriptDirectory().appendingPathComponent("\(prapperation.packageName)_Config.json")
        let jsonFileTo = fileHandler.getScriptDirectory().appendingPathComponent("configs/\(prapperation.packageName)_Config.json")
        let jsonFileToStrig = "\(jsonFileTo.path)"

        let fileManager = FileManager.default

        do {
            try fileManager.moveItem(at: jsonFileAt, to: jsonFileTo)
        }
        catch let error as NSError {
            print("Ooops! Something went wrong with cut and copy the Config.json results: \(error)")
        }

        if let newJsonData = fileHandler.handleJsonData(jsonPath: jsonFileToStrig){
    
            if (newJsonData.AppName == "" || newJsonData.AppPath == "" || newJsonData.KeyPass == "" || newJsonData.KeyStore == "")  {
                print("Fill in Config.json AppName / AppPath / KeyPass / KeyStore ")
        
                let jsonFileAt = fileHandler.getScriptDirectory().appendingPathComponent("\(prapperation.packageName)_Config.json")
                let jsonFileTo = fileHandler.getScriptDirectory().appendingPathComponent("configs/\(prapperation.packageName)_Config.json")
                let fileManager = FileManager.default

                do {
                    try fileManager.moveItem(at: jsonFileTo, to: jsonFileAt)
                }
                catch _ as NSError {
                }
                exit(0)
            }
            else if (newJsonData.SigningScheme == 0 || newJsonData.SigningScheme > 4) {
                print("SigningScheme has to be 1-4")
        
                let jsonFileAt = fileHandler.getScriptDirectory().appendingPathComponent("\(prapperation.packageName)_Config.json")
                let jsonFileTo = fileHandler.getScriptDirectory().appendingPathComponent("configs/\(prapperation.packageName)_Config.json")
                let fileManager = FileManager.default

                do {
                    try fileManager.moveItem(at: jsonFileTo, to: jsonFileAt)
                }
                catch _ as NSError {
                }
                exit(0)
            }
    
            let apkName = "\(newJsonData.AppName!)_\(prapperation.versionName)_\(prapperation.versionCode)_\(debugOption).apk"

            fileHandler.reNameApkFile(apkName: apkName)

            let stringScript = fileHandler.dataFromSingingScript()
            let stringSigningScheme: String = String(newJsonData.SigningScheme)

    
            func checkForAssetsKeystore() -> String {
                if FileManager.default.fileExists(atPath: "assets/\(newJsonData.KeyStore!)"){
                    let keystoreAssetsDir = "assets/\(newJsonData.KeyStore!)"
                    return keystoreAssetsDir
                }
                print("Missing .keystore file in assets Directory")
        
                let jsonFileAt = fileHandler.getScriptDirectory().appendingPathComponent("\(prapperation.packageName)_Config.json")
                let jsonFileTo = fileHandler.getScriptDirectory().appendingPathComponent("configs/\(prapperation.packageName)_Config.json")
                let fileManager = FileManager.default

                do {
                    try fileManager.moveItem(at: jsonFileTo, to: jsonFileAt)
                }
                catch _ as NSError {
                }
                exit(0)
            }
            func checkForAssetsPass() -> String {
                if FileManager.default.fileExists(atPath: "assets/\(newJsonData.KeyPass!)"){
                    let keyPassAssetsDir = "assets/\(newJsonData.KeyPass!)"
                    return keyPassAssetsDir
                }
                print("Missing keypass.txt file in assets Directory")
        
                let jsonFileAt = fileHandler.getScriptDirectory().appendingPathComponent("\(prapperation.packageName)_Config.json")
                let jsonFileTo = fileHandler.getScriptDirectory().appendingPathComponent("configs/\(prapperation.packageName)_Config.json")
                let fileManager = FileManager.default

                do {
                    try fileManager.moveItem(at: jsonFileTo, to: jsonFileAt)
                }
                catch _ as NSError {
                }
                exit(0)
            }
    
            let apkSignerDtagXcode = run(stringScript!, checkForAssetsKeystore(), checkForAssetsPass() , stringSigningScheme, apkName).stdout
            print(apkSignerDtagXcode)
    
            let apkParameter = fileHandler.getScriptDirectory().appendingPathComponent("\(newJsonData.AppName!)_\(prapperation.versionName)_\(prapperation.versionCode)_\(debugOption)_log.txt")

            do {
                try apkSignerDtagXcode.write(to: apkParameter, atomically: true, encoding: String.Encoding.utf8)
            } catch {
                print ("failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding")
            }
    
            let apkNameWithoutIndex = "\(newJsonData.AppName!)_\(prapperation.versionName)_\(prapperation.versionCode)_\(debugOption)"
            let apkParameterName = "\(newJsonData.AppName!)_\(prapperation.versionName)_\(prapperation.versionCode)_\(debugOption)_log.txt"
    
            func handelSubDir() -> String{
                if(newJsonData.AppName == newJsonData.AppPath){
                    let appNameDir = newJsonData.AppName!
                    return appNameDir
                }
                else{
                    let appNameDir = newJsonData.AppPath!
                    return appNameDir
                }
            }
    
            let apkNameURL: URL = fileHandler.getScriptDirectory().appendingPathComponent(apkName)
            let apkNameAlinged: URL = fileHandler.getScriptDirectory().appendingPathComponent("\(apkNameWithoutIndex)_aligned.apk")
            let apkNameAlingedSigned: URL = fileHandler.getScriptDirectory().appendingPathComponent("\(apkNameWithoutIndex)_aligned_signed.apk")
            let idsigName: URL = fileHandler.getScriptDirectory().appendingPathComponent("\(apkNameWithoutIndex)_aligned_signed.apk.idsig")
            let apkParameterToString: URL = apkParameter
    
            let destionationPath = "signedAPKs/\(handelSubDir())/\(prapperation.versionName)/\(debugOption)"
            let scriptURLDestionation = fileHandler.getScriptDirectory().appendingPathComponent(destionationPath)
    
            let apkNameUrlDes: URL = fileHandler.getScriptDirectory().appendingPathComponent("\(destionationPath)/\(apkName)")
            let apkNameAlingedDes: URL = fileHandler.getScriptDirectory().appendingPathComponent("\(destionationPath)/\(apkNameWithoutIndex)_aligned.apk")
            let apkNameAlingedSignedDes: URL = fileHandler.getScriptDirectory().appendingPathComponent("\(destionationPath)/\(apkNameWithoutIndex)_aligned_signed.apk")
            let apkParameterToStringDes: URL = fileHandler.getScriptDirectory().appendingPathComponent("\(destionationPath)/\(apkParameterName)")
            let idsigNameDes: URL = fileHandler.getScriptDirectory().appendingPathComponent("\(destionationPath)/\(apkNameWithoutIndex)_aligned_signed.apk.idsig")
      
            let fileManager = FileManager.default
    
            do {
                try fileManager.createDirectory(at: scriptURLDestionation, withIntermediateDirectories: true, attributes: nil)
            }
            catch let error as NSError {
                print("Ooops! Something went wrong with creating directorys: \(error)")
            }
    
            do {
                try fileManager.moveItem(at: apkNameURL, to: apkNameUrlDes)
                try fileManager.moveItem(at: apkNameAlinged, to: apkNameAlingedDes)
                try fileManager.moveItem(at: apkNameAlingedSigned, to: apkNameAlingedSignedDes)
                try fileManager.moveItem(at: apkParameterToString, to: apkParameterToStringDes)
                if newJsonData.SigningScheme == 4{
                    try fileManager.moveItem(at: idsigName, to: idsigNameDes)
                }
            }
            catch let error as NSError {
                print("Ooops! Something went wrong with cut and copy the singing results: \(error)")
            }
            return apkSignerDtagXcode
        }
        else{
            print("The developer made a big mistake with the json file!!!")
        }
        return nil
    }
}
