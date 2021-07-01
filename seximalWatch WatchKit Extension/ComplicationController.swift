//
//  ComplicationController.swift
//  seximalWatch WatchKit Extension
//
//  Created by Henrik Storch on 27.06.21.
//

import ClockKit
import SwiftUI

class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Complication Configuration

    func getComplicationDescriptors(handler: @escaping ([CLKComplicationDescriptor]) -> Void) {
        let descriptors = [
            CLKComplicationDescriptor(identifier: "complication", displayName: "Current date / time in seximal",
                                      supportedFamilies: CLKComplicationFamily.allCases)
//                                      supportedFamilies: [.utilitarianSmall, .utilitarianSmallFlat, .utilitarianLarge, .extraLarge, .modularLarge, .modularSmall, .graphicRectangular])
            // Multiple complication support can be added here with more descriptors
        ]
        
        // Call the handler with the currently supported complication descriptors
        handler(descriptors)
    }
    
    func handleSharedComplicationDescriptors(_ complicationDescriptors: [CLKComplicationDescriptor]) {
        // Do any necessary work to support these newly shared complication descriptors
    }

    // MARK: - Timeline Configuration
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        // Call the handler with the last entry date you can currently provide or nil if you can't support future timelines
        handler(.distantFuture)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        // Call the handler with your desired behavior when the device is locked
        handler(.showOnLockScreen)
    }

    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline entry
        print(#function)
        let secondsInAMoment = ((60.0 * 60.0 * 24.0) / (36.0 * 36.0 * 36.0))
        let date = Date()
        
        let secondsSinceDay = Int(date.timeIntervalSince(Calendar.utc.startOfDay(for: date)))
        let momentsSinceDay = Double(secondsSinceDay) / secondsInAMoment
        let lullsSinceDay = Int(momentsSinceDay / 36)
        let lullsInSec = Double(lullsSinceDay) * 36 * secondsInAMoment + 0.25
        
        let d = Calendar.utc.startOfDay(for: date).addingTimeInterval(lullsInSec)
        let t = SexTime(date: d)
        
        let entry = CLKComplicationTimelineEntry(
            date: d,
            complicationTemplate: template(for: complication.family, time: t)
        )

        //RUNTIME WARING!
        handler(entry)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after the given date
        print(#function)
        let date = Date()
        var entries = [CLKComplicationTimelineEntry]()
        
        defer {
            handler(entries)
        }
        
        guard ![.utilitarianSmall, .utilitarianSmallFlat, .utilitarianLarge].contains(complication.family) else {
            for i in 0..<limit {
                let d = date.addingTimeInterval(TimeInterval(i * 3600 * 24))
                let t = SexTime(date: d)
                
                entries.append(CLKComplicationTimelineEntry(
                    date: d,
                    complicationTemplate: template(for: complication.family, time: t)
                ))
            }
            
            return
        }
        
        let secondsInAMoment = ((60.0 * 60.0 * 24.0) / (36.0 * 36.0 * 36.0))
        let secondsInALapse = secondsInAMoment * 36
        
        let secondsSinceDay = Int(date.timeIntervalSince(Calendar.utc.startOfDay(for: date)))
        let momentsSinceDay = Double(secondsSinceDay) / secondsInAMoment
        let lullsSinceDay = Int(momentsSinceDay / 36) + 1
        let nextLullInSec = Double(lullsSinceDay) * 36 * secondsInAMoment + 0.25
        
        let now = Calendar.utc.startOfDay(for: date).addingTimeInterval(nextLullInSec)
        
        for i in 0..<limit {
            let d = now.addingTimeInterval(TimeInterval(Double(i) * secondsInALapse))
            let t = SexTime(date: d)
            entries.append(CLKComplicationTimelineEntry(
                date: d,
                complicationTemplate: template(for: complication.family, time: t)
            ))
        }
        
        return
    }

    // MARK: - Sample Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        handler(nil)
    }
    
    func template(for family: CLKComplicationFamily, time: SexTime) -> CLKComplicationTemplate {
        switch family {
        case .modularSmall:
//            return CLKComplicationTemplateModularSmallSimpleImage(imageProvider: CLKFullColorImageProvider(fullColorImage: UIImage(named: "\(time.weekday)\(Int.random(in: 0...4))")))
            return CLKComplicationTemplateModularSmallStackText(
                line1TextProvider: CLKTextProvider(
                    format: time.shortTime),
                line2TextProvider: CLKTextProvider(
                    format: time.shortWeekday))
        case .modularLarge:
            return CLKComplicationTemplateModularLargeStandardBody(
                headerTextProvider: CLKTextProvider(
                    format: time.format(for: .all)!),
                body1TextProvider: CLKTextProvider(
                    format: time.shortTime))
                    
        case .extraLarge:
            return CLKComplicationTemplateExtraLargeStackText(
                line1TextProvider: CLKTextProvider(
                    format: time.shortTime),
                line2TextProvider: CLKTextProvider(
                    format: time.shortWeekday))
            
        case .utilitarianSmall, .utilitarianSmallFlat:
            return CLKComplicationTemplateUtilitarianSmallFlat(textProvider: CLKTextProvider(format: time.weekday))
        case .utilitarianLarge:
            return CLKComplicationTemplateUtilitarianLargeFlat(textProvider: CLKTextProvider(format: time.format(for: .all)!))
            
        case .circularSmall:
            return CLKComplicationTemplateCircularSmallStackText(
                line1TextProvider: CLKTextProvider(format: time.shortTime),
                line2TextProvider: CLKTextProvider(format: time.shortWeekday))
            
        case .graphicCorner:
            return CLKComplicationTemplateGraphicCornerTextView(textProvider: CLKTextProvider(format: time.weekday), label: Text("六").bold())
//            return CLKComplicationTemplateGraphicCornerTextImage(
//                textProvider: CLKTextProvider(format: time.weekday),
//                imageProvider: CLKFullColorImageProvider(
//                    fullColorImage: Bundle.main.icon!))
        case .graphicBezel:
            return CLKComplicationTemplateGraphicBezelCircularText(
                circularTemplate: CLKComplicationTemplateGraphicCircularStackText(
                    line1TextProvider: CLKTextProvider(format: time.shortTime),
                    line2TextProvider: CLKTextProvider(format: time.shortWeekday)),
                textProvider: CLKTextProvider(format: time.format(for: .all)!))
        case .graphicCircular:
            return CLKComplicationTemplateGraphicCircularStackText(
                line1TextProvider: CLKTextProvider(format: time.shortTime),
                line2TextProvider: CLKTextProvider(format: time.shortWeekday))
        case .graphicRectangular:
            return CLKComplicationTemplateGraphicRectangularStandardBody(
                headerTextProvider: CLKTextProvider( format: time.format(for: .all)!),
                body1TextProvider: CLKTextProvider( format: time.shortTime))
        case .graphicExtraLarge:
            return CLKComplicationTemplateGraphicExtraLargeCircularStackText(
                line1TextProvider: CLKTextProvider(
                    format: time.shortTime),
                line2TextProvider: CLKTextProvider(
                    format: time.shortWeekday))
        @unknown default:
            fatalError("Unknown CLKfamily")
        }
    }
}
