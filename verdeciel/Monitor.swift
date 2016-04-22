//  Created by Devine Lu Linvega on 2015-09-21.
//  Copyright © 2015 XXIIVV. All rights reserved.

import UIKit
import QuartzCore
import SceneKit
import Foundation

class Monitor : Panel
{
	let label = SCNLabel(text: "", scale: 0.08, align: alignment.center)
	let details = SCNLabel(text: "", scale: 0.04, align: alignment.center, color: grey)
	
	override init()
	{
		super.init()
		
		name = ""
		
		root.position = SCNVector3(0,0,templates.radius)
		
		label.position = SCNVector3(0,0,0)
		root.addChildNode(label)
		
		details.position = SCNVector3(0,0.2,0)
		root.addChildNode(details)
		
		label.hide()
		details.hide()
		
		details.update("")
		label.update("--")
	}
	
	// MARK: Installation -
	
	var installNode:Empty = Empty()
	var installProgressBar = SCNProgressBar(width: 1)
	
	override func onInstallationBegin()
	{
		installNode = Empty()
		installNode.position = SCNVector3(0,0,0)
		installProgressBar = SCNProgressBar(width: 0.5)
		installProgressBar.position = SCNVector3(-0.25,-0.2,0)
		installProgressBar.hide()
		installNode.addChildNode(installProgressBar)
		root.addChildNode(installNode)
	}
	
	override func installProgress()
	{
		super.installProgress()
	}
	
	override func onInstallationComplete()
	{
		super.onInstallationComplete()
		
		SCNTransaction.begin()
		SCNTransaction.setAnimationDuration(0.5)
		label.show()
		details.show()
		SCNTransaction.setCompletionBlock({ self.refresh() })
		SCNTransaction.commit()
		
		installNode.removeFromParentNode()
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}
}