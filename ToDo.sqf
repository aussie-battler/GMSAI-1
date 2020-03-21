TODO List:

1. revisit the deletion of debug markers to ensre this is done properly.
2. Add EH for vehicles, e.g., hit should change combat mode and behavior, killed should alert everything nearby.
3. Check code for detecting players and triggering paradrops. 
4. Write code to handle paradrops which would be quite similar to that for airdropping crates.
5. Write code to have a one-time instance of an area patrol; Perhaps, this could add the patrol the the activeStaticAreas list for infantry with respawns == 0;
6. Think about how to make vehicle patrols slow near players and sniff them out.
7. think about adding more perstance to the hunting mode.
8. Add unit Killed event handler that includes any checks for illeagal kills and sends players messages.
9. send messages to specific client-side message handlers; there may be greater flexibility to having several of these but the downside is more network traffic if we remoteExec to several of these per client per kill.
