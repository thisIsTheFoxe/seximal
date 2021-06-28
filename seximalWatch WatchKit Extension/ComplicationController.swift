//
//  ComplicationController.swift
//  seximalWatch WatchKit Extension
//
//  Created by Henrik Storch on 27.06.21.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Complication Configuration

    func getComplicationDescriptors(handler: @escaping ([CLKComplicationDescriptor]) -> Void) {
        let descriptors = [
            CLKComplicationDescriptor(identifier: "complication", displayName: "seximal",
//                                      supportedFamilies: CLKComplicationFamily.allCases)
                                      supportedFamilies: [.utilitarianSmall, .utilitarianSmallFlat, .utilitarianLarge, .extraLarge, .modularLarge, .modularSmall])
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
        handler(nil)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        // Call the handler with your desired behavior when the device is locked
        handler(.showOnLockScreen)
    }

    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline entry
        let secondsInAMoment = ((60.0 * 60.0 * 24.0) / (36.0 * 36.0 * 36.0))
        let date = Date()
        
        let secondsSinceDay = Int(date.timeIntervalSince(Calendar.utc.startOfDay(for: date)))
        let momentsSinceDay = Double(secondsSinceDay) / secondsInAMoment
        let lullsSinceDay = Int(momentsSinceDay / 36) - 1
        let nextLullInSec = Double(lullsSinceDay) * 36 * secondsInAMoment + 0.25
        
        let d = Calendar.utc.startOfDay(for: date).addingTimeInterval(nextLullInSec)
        let t = SexTime(date: d)
        
        let entry = CLKComplicationTimelineEntry(
            date: d,
            complicationTemplate: template(for: complication.family, time: t)
        )

        handler(entry)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after the given date
        
        let date = Date()
        var entries = [CLKComplicationTimelineEntry]()
        
        defer {
            handler(entries)
        }
        
        guard ![.modularSmall, .utilitarianSmall, .utilitarianSmallFlat].contains(complication.family) else {
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
            return CLKComplicationTemplateModularSmallSimpleText(textProvider: CLKTextProvider(format: time.weekdayShort))
        case .modularLarge:
            return CLKComplicationTemplateModularLargeStandardBody(headerTextProvider: CLKTextProvider(format: time.format(for: .all)!), body1TextProvider: CLKTextProvider(format: "\(time.lapse.asSex()):\(time.lull.asSex())"))
                    
        case .extraLarge:
            return CLKComplicationTemplateExtraLargeStackText(line1TextProvider: CLKTextProvider(format: time.format(for: .all)!), line2TextProvider: CLKTextProvider(format: "\(time.lapse.asSex()):\(time.lull.asSex())"))
            
        case .utilitarianSmall, .utilitarianSmallFlat:
            return CLKComplicationTemplateUtilitarianSmallFlat(textProvider: CLKTextProvider(format: time.weekdayShort))
        case .utilitarianLarge:
            return CLKComplicationTemplateUtilitarianLargeFlat(textProvider: CLKTextProvider(format: time.format(for: .all)!))
//        case .circularSmall:
//
//        case .graphicCorner:
//
//        case .graphicBezel:
//
//        case .graphicCircular:
//
//        case .graphicRectangular:
//
//        case .graphicExtraLarge:
            
        default:
            fatalError()
        }
    }
}
