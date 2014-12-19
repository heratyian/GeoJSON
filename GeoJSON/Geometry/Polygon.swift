// Polygon.swift
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

public final class Polygon {
	
	/// Private linearRings
	private var _linearRings: [LineString] = []
	
	/// Public linearRings
	public var linearRings: [LineString] { return _linearRings }
	
	public init?(json: JSON) {
		if let jsonLineStrings =  json.array {
			for jsonLineString in jsonLineStrings {
				if let lineString = LineString(json: jsonLineString) {
					if lineString.isLinearRing {
						_linearRings.append(lineString)
					} else {
						return nil
					}
				} else {
					return nil
				}
			}
		} else {
			return nil
		}
	}
}

public extension GeoJSON {
	
	/// Optional Polygon
	public var polygon: Polygon? {
		get {
			switch type {
			case .Polygon:
				return object as? Polygon
			default:
				return nil
			}
		}
		set {
			_object = newValue ?? NSNull()
		}
	}
}