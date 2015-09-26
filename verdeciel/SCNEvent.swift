//
//  SCNRadarEvent.swift
//  Verreciel
//
//  Created by Devine Lu Linvega on 2015-06-26.
//  Copyright (c) 2015 XXIIVV. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit
import Foundation

class SCNEvent : SCNNode
{
	var isKnown:Bool = false
	var isTargetted:Bool = false
	
	var targetNode:SCNNode!
	
	var location = CGPoint()
	var size:Float = 1
	var type:eventTypes!
	var details:String
	var note = String()
	var content:Array<SCNEvent>!
	
	var angleFromCapsule:CGFloat!
	var distanceFromCapsule:CGFloat!
	var isVisible:Bool = false
	
	init(newName:String = "",location:CGPoint = CGPoint(),size:Float = 1,type:eventTypes,details:String = "", note:String = "")
	{
		self.content = []
		self.details = details

		super.init()
		
		self.name = newName
		self.location = location
		self.type = type
		self.size = size
		self.note = note
		
		addInterface()
		addTrigger()
		
		update()
	}
	
	func addInterface()
	{
		let displaySize = self.size/10
	
		self.addChildNode(SCNLine(nodeA: SCNVector3(x:0,y:displaySize,z:0),nodeB: SCNVector3(x:displaySize,y:0,z:0),color: grey))
		self.addChildNode(SCNLine(nodeA: SCNVector3(x:-displaySize,y:0,z:0),nodeB: SCNVector3(x:0,y:-displaySize,z:0),color: grey))
		self.addChildNode(SCNLine(nodeA: SCNVector3(x:0,y:displaySize,z:0),nodeB: SCNVector3(x:-displaySize,y:0,z:0),color: grey))
		self.addChildNode(SCNLine(nodeA: SCNVector3(x:displaySize,y:0,z:0),nodeB: SCNVector3(x:0,y:-displaySize,z:0),color: grey))
	}
	
	func addTrigger()
	{
		let displaySize:CGFloat = CGFloat(self.size/2.5)
		
		self.geometry = SCNPlane(width: displaySize, height: displaySize)
		self.geometry?.firstMaterial?.diffuse.contents = clear
	}
	
	override func update()
	{
		if capsule == nil { return }
		
		position = SCNVector3(location.x,location.y,0)
		distanceFromCapsule = distanceBetweenTwoPoints(capsule.location, point2: self.location)

		angleFromCapsule = capsule.direction - ((angleBetweenTwoPoints(capsule.location, point2: self.location, center: self.location) + 270) % 360)
		
		discover()
		instance()
		radarCulling()
		
		clean()
	}
	
	func discover()
	{
		if self.isKnown == false && distanceFromCapsule < 0.3 {
			isKnown = true
			self.color(white)
		}
	}
	
	func instance()
	{
		if distanceFromCapsule < 0.9 && capsule.instance == nil {
			capsule.instance = self
			space.startInstance(self)
		}
	}
	
	func radarCulling()
	{
		if capsule != nil {
			if distanceFromCapsule < 1.3 {
				self.opacity = 1
			}
			else {
				self.opacity = 0
			}
		}
	}
	
	func clean()
	{
		if self.size < 0 {
			self.removeFromParentNode()
		}
	}
	
	func color(targetColor:UIColor)
	{
		for node in self.childNodes
		{
			let line = node as! SCNLine
			line.color(targetColor)
		}
	}
	
	override func touch()
	{
		radar.addTarget(self)
	}
	
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}