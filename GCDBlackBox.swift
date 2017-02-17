//
//  GCDBlackBox.swift
//  Cute Animals
//
//  Created by Jaxson Mann on 2/3/17.
//  Copyright © 2017 Jaxson Mann. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.sync {
        updates()
    }
}
