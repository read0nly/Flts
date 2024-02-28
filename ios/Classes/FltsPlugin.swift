import Flutter
import UIKit
import LTSSDK

public class FltsPlugin: NSObject, FlutterPlugin {
  static var lts:LTSSDK?
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flts", binaryMessenger: registrar.messenger())
    let instance = FltsPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "initLts":
        initLts(call, result: result)
    case "setLocalLogLevel":
        setLocalLogLevel(call, result: result)
    case "report":
        report(call, result: result)
    case "reportImmediately":
        reportImmediately(call, result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
    private func setLocalLogLevel(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let levelName = call.arguments as? String  {
            var level = LTSLoggerLevel.off;
            if (levelName == "DEBUG") {
                level = .debug
            }else if(levelName == "ERROR") {
                level = .error
            }else if(levelName == "INFO") {
                level = .info
            }else if(levelName == "OFF") {
                level = .off
            }else if(levelName == "WARNING") {
                level = .warn
            }
            LTSSDK.setLogLevel(level)
            result(true)
        }else {
            result(false)
        }
    }
    
    private func initLts(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let arguments = call.arguments as? [String: Any]  {
            // LTS参数配置
            let params = LTSConfigParams()
            // 必填参数
            params.region = arguments["region"] as? String ?? ""
            params.projectId = arguments["projectId"] as? String ?? ""
            params.groupId = arguments["groupId"] as? String ?? ""
            params.streamId = arguments["streamId"] as? String ?? ""
            params.accessKey = arguments["accessKey"] as? String ?? ""
            params.secretKey = arguments["secretKey"] as? String ?? ""
            // 选填参数
//            params.url = "https://lts-access.cn-north-4.myhuaweicloud.com" //要上报的LTS公网地址域名
//            params.cacheThreshold = 200
//            params.timeInterval = 3
//            params.isReportWhenEnterBackgroundEnabled = true
//            params.isReportWhenAPPLaunchEnabled = false

            // 初始化打印日志级别（默认.off）
            LTSSDK.setLogLevel(.off)
            // LTS初始化方法
            let lts = LTSSDK(config:params)
            FltsPlugin.lts = lts
            print("初始化LTSSDK 成功：\(params.region)")
            result(true)
        }else {
            result(false)
        }
    }
    
    /// 上报
    private func report(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let lts = FltsPlugin.lts {
            if let arguments = call.arguments as? [String: Any]  {
                if let logs = arguments["logs"] as? [[String: Any]],let labels = arguments["labels"]  as? [String: Any]{
                    lts.report(logs, labels: labels );
                }
            }
        }  else {
            print("""
                       ===================================================
                       LTS SDK 未初始化
                       ===================================================
                      """)
        }
       
    }
    
    private func reportImmediately(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let lts = FltsPlugin.lts {
            if let arguments = call.arguments as? [String: Any]  {
                if let logs = arguments["logs"] as? [[String: Any]],let labels = arguments["labels"]  as? [String: String]{
                    DispatchQueue(label: "com.kyy.lts").async {
//                        lts.report([["content1_key": "content1_value"], ["content2_key": "content2_value"]], labels: ["label_key": "label_value"])
                        lts.reportImmediately(logs, labels: labels );
                    }
                }
            }
        }  else {
            print("""
                       ===================================================
                       LTS SDK 未初始化
                       ===================================================
                      """)
        }
    }
}
