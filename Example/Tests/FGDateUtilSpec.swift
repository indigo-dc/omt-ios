//
//  FGDateUtilSpec.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 03.02.2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import IndigoOmtIosLibrary

class FGDateUtilSpec: QuickSpec {
    override func spec() {
        describe("FGDateUtil") {
            context("parseDate") {
                
                it("should not parse invalid date string") {
                    
                    // prepare
                    let dateString = "invalid date"
                    
                    // test
                    let date = FGDateUtil.parseDate(dateString)
                    
                    // verify
                    expect(date).to(beNil())
                }
                
                it("should parse valid date") {
                    
                    // prepare
                    let comp = [2017, 1, 1, 12, 0, 0]
                    let dateString = "\(comp[0])-\(comp[1])-\(comp[2]) \(comp[3]):\(comp[4]):\(comp[5])"
                    
                    // test
                    let date = FGDateUtil.parseDate(dateString)
                    let components = Calendar.current.dateComponents(
                        [.hour, .minute, .second, .day, .month, .year], from: date ?? Date())
                    
                    // verify
                    expect(date).toNot(beNil())
                    expect(components.year).to(equal(comp[0]))
                    expect(components.month).to(equal(comp[1]))
                    expect(components.day).to(equal(comp[2]))
                    expect(components.hour).to(equal(comp[3]))
                    expect(components.minute).to(equal(comp[4]))
                    expect(components.second).to(equal(comp[5]))
                }
            }
        }
        
        context("format") {
            
            it("should format date") {
                
                // prepare
                let date = Date()
                let format = "yyyy-MM-dd"
                
                // test
                let dateString = FGDateUtil.format(format, date: date)
                
                // verify
                expect(dateString).toNot(beNil())
            }
            
            it("should return empty string when date is empty") {
                
                // prepare
                let date: Date? = nil
                let format = "yyyy-MM-dd"
                
                // test
                let dateString = FGDateUtil.format(format, date: date)
                
                // verify
                expect(dateString).to(beNil())
            }
        }
    }
}
