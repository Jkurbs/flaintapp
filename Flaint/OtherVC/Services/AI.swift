//
//  AI.swift
//  Flaint
//
//  Created by Kerby Jean on 9/14/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import NaturalLanguage

class AI {
    
    static let shared = AI()
    
    let tagger = NLTagger(tagSchemes: [.sentimentScore])
    
    func sentimentAnalysis(string: String) -> String? {
        
        tagger.string = string
        
        let (sentiment, _) = tagger.tag(at: string.startIndex, unit: .paragraph, scheme: .sentimentScore)

        let score = Double(sentiment!.rawValue)!
        if score < 0 {
           return "negative"
        } else if score > 0 {
            return "positive"
        } else {
            return "neutral"
        }
    }
}
