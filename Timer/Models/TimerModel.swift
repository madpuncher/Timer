//
//  TimerModel.swift
//  TimerModel
//
//  Created by Eʟᴅᴀʀ Tᴇɴɢɪᴢᴏᴠ on 25.08.2021.
//

class TimerModel: Comparable {
   
    let name: String
    var timeCount: Int
    var finish = false
    
    init(name: String, timeCount: Int) {
        self.name = name
        self.timeCount = timeCount
    }
    
    static func <(lhs: TimerModel, rhs: TimerModel) -> Bool {
        return lhs.timeCount < rhs.timeCount
    }
    
    static func == (lhs: TimerModel, rhs: TimerModel) -> Bool {
        lhs.timeCount == rhs.timeCount
    }
    
}
