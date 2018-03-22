//
//  CaptureMetadataCallback.swift
//  BarcodeScanner
//
//  Created by Maximilian Sonntag on 21.06.17.
//  Copyright © 2017 Maximilian Sonntag. All rights reserved.
//


import AVFoundation

protocol CaptureMetadataCallback{
    func setEANField(text : String)
}
