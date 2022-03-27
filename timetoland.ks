// Script by PAPASID. Last modifed: 16/03/22
clearscreen.
set latestposn to 0.
set olderposn to 0.
set oldestposn to 0.
set RUNMODE to 1.
SET KSCCOORDINATES TO LATLNG(28.612856, -80.801158).
SET CANTAKEPOSN to 1.
SET timeoflastobs to TIME:SECONDS.
function circle_distance {
 parameter p1.     
 parameter p2.     
 parameter radius. 
 local A is sin((p1:lat-p2:lat)/2)^2 + cos(p1:lat)*cos(p2:lat)*sin((p1:lng-p2:lng)/2)^2.
 
 return radius*constant():PI*arctan2(sqrt(A),sqrt(1-A))/90.
}

global function timewarpto28
	{
		
		UNTIL SHIP:GEOPOSITION:LAT > 28.1 AND SHIP:GEOPOSITION:LAT < 29
		{
			WAIT 1.
			set warp to 3.
		}
		WAIT 1.
		set warp to 1.
		
		shipposnledger().
		SET CANTAKEPOSN to 1.
		
		timewarpto28().
		
	}

function shipposnledger
{	
//timewarp stop.

	//set kuniverse:timewarp:rate to 1.
	
	
	set warp to 0.
	WAIT 1.
	set obstimediff to TIME:SECONDS - timeoflastobs.
	if latestposn = 0 and olderposn = 0 and oldestposn = 0 AND CANTAKEPOSN = 1 AND obstimediff > 3600
		{
		set latestposn to SHIP:GEOPOSITION.
		SET CANTAKEPOSN to 0.
		PRINT "CURRENT POSITION: " + latestposn.
		PRINT "---SHIP POSITION REGISTERED. WARPING NOW.---".
		
		}
	else if olderposn = 0 AND oldestposn = 0 AND CANTAKEPOSN = 1 AND obstimediff > 3600
		{	
		set olderposn to latestposn.
		set latestposn to SHIP:GEOPOSITION.
		SET CANTAKEPOSN to 0.
		PRINT "CURRENT POSITION: " + latestposn.
		PRINT "PREVIOUS POSITION: " + olderposn.
		PRINT "---SHIP POSITION REGISTERED. WARPING NOW.---".
		
		}
	else if CANTAKEPOSN = 1 AND obstimediff > 3600
		{
		set oldestposn to olderposn.
		set olderposn to latestposn.
		set latestposn to SHIP:GEOPOSITION.
		SET CANTAKEPOSN to 0.
		set circlealt to SHIP:BODY:RADIUS + ALTITUDE.
		PRINT "CURRENT POSITION: " + latestposn.
		PRINT "PREVIOUS POSITION: " + olderposn.
		PRINT "OLDEST POSITION: " + oldestposn.
		set disttoksc to circle_distance(latestposn,KSCCOORDINATES,circlealt).
		PRINT "DISTANCE TO KSC: " + disttoksc.
		PRINT "---SHIP POSITION REGISTERED. WARPING NOW.---".
		set a to (circle_distance(olderposn,oldestposn,circlealt) + circle_distance(latestposn,olderposn,circlealt)) / 2.
		if disttoksc > 2000000 AND disttoksc < 3000000
			{
				PRINT "CONTINUE TO DEORBIT BURN. EXITING.".
				SET RUNMODE to 0.
				WAIT UNTIL FALSE.
			}
		}
		set timeoflastobs to TIME:SECONDS.
		//WAIT 1.
	
}
timewarpto28().


//disttoksc > a AND disttoksc < (1.33 * a)


// set warp to 3.
// UNTIL SHIP:GEOPOSITION:LAT > 28 AND SHIP:GEOPOSITION:LAT < 29
// {
	// set warp to 2.
// }
// set warp to 0.