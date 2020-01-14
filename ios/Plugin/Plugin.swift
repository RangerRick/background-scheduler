import Foundation
import Capacitor
import BackgroundTasks

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitor.ionicframework.com/docs/plugins/ios
 */
@objc(BackgroundScheduler)
public class BackgroundScheduler: CAPPlugin {
    @available(iOS 13.0, *)
    lazy private var _inFlight = [String: BGTask]()

    @available(iOS 13.0, *)
    func handleTask(task: BGTask) {
        _inFlight[task.identifier] = task
        notifyListeners(task.identifier, data: nil, retainUntilConsumed: true)
    }

    public override func load() {
        if #available(iOS 13.0, *) {
            
            guard let info = Bundle.main.object(forInfoDictionaryKey: "BGTaskSchedulerPermittedIdentifiers") as? Array<Any> else {
                print("BGTaskSchedulerPermittedIdentifiers is not set.")
                return
            }

            info.forEach { identifier in
                let id = identifier as! String
                print("BackgroundScheduler: registering " + id + ".")
                BGTaskScheduler.shared.register(forTaskWithIdentifier: id, using: nil) {
                    task in self.handleTask(task: task)
                }
            }

        }
    }

    // to trigger: e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"com.raccoonfink.cruisemonkey.fetch"]
    // then, "continue"
    @objc func schedule(_ call: CAPPluginCall) {
        guard let identifier = call.getString("identifier") else {
            call.error("Must provide an identifier to register!")
            return;
        }
        let type = call.getString("type") ?? "refresh"
        let earliestBeginDate = call.getDate("earliestBeginDate") ?? Date(timeIntervalSinceNow: 1)

        print("BackgroundScheduler: scheduling task " + identifier + "\n")

        if #available(iOS 13.0, *) {
            let request = type == "refresh" ? BGAppRefreshTaskRequest(identifier: identifier) : BGProcessingTaskRequest(identifier: identifier)
            request.earliestBeginDate = earliestBeginDate
            do {
                try BGTaskScheduler.shared.submit(request)
            } catch {
                print("BackgroundScheduler: failed to schedule task: \(error)")
            }
        } else {
            print("BackgroundScheduler: Background Tasks not available on iOS < 13.");
        }
    }

    @objc func finished(_ call: CAPPluginCall) {
        guard let identifier = call.getString("identifier") else {
            call.error("Must supply the identifier to mark as finished!")
            return
        }
        
        if #available(iOS 13.0, *) {
            guard let task = _inFlight[identifier] else {
                call.error("Task " + identifier + " is not currently running!")
                return
            }

            print("BackgroundScheduler: marking task " + identifier + " as finished.\n")
            task.setTaskCompleted(success: true)
        }

        call.success()
    }
}
