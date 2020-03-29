TODO List:

The basic mechanics are there now 
	- a method to decide if reinforcements should be dropped is coded 
	- logs show it drops paras 
	
Loggin is needed to better understand how/when it functions 
	- who is player target  
	- where is player target 
	- where is drop and what is distance to player 
	- That hunting waypoint logic was started 
	- show group debug marker 
	- that the group is being monitored for several endpoints 
		~ group empty, delete group, ( ? reset paratroop logic for that aircraft, would require the aircraft be tagged with group info, probably not practical )
		~ player target dead, search for other enemies, if none found switch to routine area patrol logic 
		~ no enemies AND none for whatever the timeout is -> delete group 
	The para spawn logic should link the group to the aircraft. As long as the group is alive, no further respawns from that aircraft. Cooldown begins once the group is gone. 

	Para logic should ignore other nearby groups from GMSAI or GMS 







