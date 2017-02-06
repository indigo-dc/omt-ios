//
//  FGApiResolverSpec.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 03.02.2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import IndigoOmtIosLibrary

class FGApiResolverSpec: QuickSpec {
    override func spec() {
        describe("FGApiResolver") {
            
            
            
            
            return;
            it("e") {
                
                let p = FGUnauthorizedSessionHelper(queue: DispatchQueue.global())
                
                let resolver = FGApiResolver(baseUrl: URL(string: "http://google.com")!, versionID: "", helper: p)
                var re: FGApiResolverResponse?
                
                // test
                waitUntil { done in
                    
                    resolver.resolveUrlWithVersion { response in
                        
                        re = response
                        
                        
                        expect(response.error).toNot(beNil())
                        expect(response.url).to(beNil())
                        
                        
                        done()
                    }
                }
                
                // verify
                
                
                
                
            }
            
            
            
            
            
            
            
            
            
            
        }
    }
}
