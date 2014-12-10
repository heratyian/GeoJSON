// MultiPointTests.swift
//
// The MIT License (MIT)
//
// Copyright (c) 2014 Raphaël Mor
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation
import XCTest
import GeoJSON

class MultiPointTests: XCTestCase {
	
	var geoJSON :GeoJSON!
	
	override func setUp() {
		super.setUp()
		
		geoJSON = geoJSONfromString("{ \"type\": \"MultiPoint\", \"coordinates\": [] }")
	}
	
	override func tearDown() {
		geoJSON = nil
		
		super.tearDown()
	}
	
	// MARK: Nominal cases
	
	func testBasicMultiPointShouldBeRecognisedAsSuch() {
		XCTAssertEqual(geoJSON.type, GeoJSONType.MultiPoint)
	}
	
	func testEmptyMultiPointShouldBeParsedCorrectly() {
		if let geoMultiPoint = geoJSON.multiPoint {
			XCTAssertEqual(geoMultiPoint.coordinates.count, 0)
		} else {
			XCTFail("MultiPoint not parsed Properly")
		}
	}
	
	func testBasicMultiPointShouldBeParsedCorrectly() {
		
		geoJSON = geoJSONfromString("{ \"type\": \"MultiPoint\", \"coordinates\": [ [1.0 , 2.0], [3.0 , 4.0] ] }")
		
		if let geoMultiPoint = geoJSON.multiPoint {
			XCTAssertEqual(geoMultiPoint.coordinates.count, 2)
			XCTAssertEqualWithAccuracy(geoMultiPoint.coordinates[0][0], 1.0, 0.000001)
			XCTAssertEqualWithAccuracy(geoMultiPoint.coordinates[0][1], 2.0, 0.000001)
			XCTAssertEqualWithAccuracy(geoMultiPoint.coordinates[1][0], 3.0, 0.000001)
			XCTAssertEqualWithAccuracy(geoMultiPoint.coordinates[1][1], 4.0, 0.000001)
		} else {
			XCTFail("MultiPoint not parsed Properly")
		}
	}
	
	// MARK: Error cases
	
	func testMultiPointWithoutCoordinatesShouldRaiseAnError() {
		geoJSON = geoJSONfromString("{ \"type\": \"MultiPoint\" }")
		
		if let error = geoJSON.error {
			XCTAssertEqual(error.domain, GeoJSONErrorDomain)
			XCTAssertEqual(error.code, GeoJSONErrorInvalidGeoJSONObject)
		}
		else {
			XCTFail("Invalid MultiPoint should raise an invalid object error")
		}
	}
	
	func testMultiPointWithAPointWithLessThanTwoCoordinatesShouldRaiseAnError() {
		geoJSON = geoJSONfromString("{ \"type\": \"MultiPoint\", \"coordinates\": [ [0.0, 1.0], [2.0] ] }")
		
		if let error = geoJSON.error {
			XCTAssertEqual(error.domain, GeoJSONErrorDomain)
			XCTAssertEqual(error.code, GeoJSONErrorInvalidGeoJSONObject)
		}
		else {
			XCTFail("Invalid MultiPoint should raise an invalid object error")
		}
	}
	
	func testIllFormedMultiPointShouldRaiseAnError() {
		geoJSON = geoJSONfromString("{ \"type\": \"MultiPoint\", \"coordinates\": [ [0.0, 1.0], {\"invalid\" : 2.0} ] }")
		
		if let error = geoJSON.error {
			XCTAssertEqual(error.domain, GeoJSONErrorDomain)
			XCTAssertEqual(error.code, GeoJSONErrorInvalidGeoJSONObject)
		}
		else {
			XCTFail("Invalid MultiPoint should raise an invalid object error")
		}
	}
}