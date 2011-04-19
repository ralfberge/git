/*
 *  MyFunction.cpp
 *  PlugInTemplate
 *
 *  Created by Ralf Berge on 12.04.11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#include "stdafx.h"
#include <stdio.h>
#include "cTle.h"
#include "cEci.h"
#include "cOrbit.h"
#include "cSite.h"

#include "FMPlugin.h"
#include "FMTemplate/FMTemplate.h"

using namespace Zeptomoby::OrbitTools;

FMX_PROC(fmx::errcode) MyFunction(       short          funcId,
								  const fmx::ExprEnv&  environment,
								  const fmx::DataVect& dataVect,
								  fmx::Data&     result )
{

	#pragma unused(funcId,environment)
	
	fmx::errcode        err = 0;
    fmx::TextAutoPtr    tempText;
    fmx::TextAutoPtr    resultText;

	char buffer[40]; 
	
	const fmx::Text& parameter1 = dataVect.AtAsText(0);
	buffer = *parameter1;
	
	
	fmx::LocaleAutoPtr locale;
	
	// Test SGP4
	string str1 = "SGP4 Test";
	string str2 = "1 88888U          80275.98708465  .00073094  13844-3  66816-4 0    8";
	string str3 = "2 88888  72.8435 115.9689 0086731  52.6988 110.5714 16.05824518  105";
	
	cTle tleSGP4(str1, str2, str3);
	
	//PrintPosVel(tleSGP4);
	printf("\n");
	
	// Test SDP4
	str1 = "SDP4 Test";
	str2 = "1 11801U          80230.29629788  .01431103  00000-0  14311-1       8";
	str3 = "2 11801  46.7916 230.4354 7318036  47.4722  10.4117  2.28537848     6";
	
	cTle tleSDP4(str1, str2, str3);
	
	//PrintPosVel(tleSDP4);
	//printf("\nExample output:\n");
	
	
	// Example: Define a location on the earth, then determine the look-angle
	// to the SDP4 satellite defined above.
	
	// Create an Orbit object using the SDP4 Tle object.
	cOrbit orbitSDP4(tleSDP4);
	
	// Get the location of the satellite from the Orbit object. The 
	// earth-centered inertial information is placed into eciSDP4.
	// Here we ask for the location of the satellite 90 minutes after
	// the TLE epoch.
	cEci eciSDP4 = orbitSDP4.GetPosition(90.0);
	
	// Now create a site object. Site objects represent a location on the 
	// surface of the earth. Here we arbitrarily select a point on the
	// equator.
	cSite siteEquator(0.0, -100.0, 0); // 0.00 N, 100.00 W, 0 km altitude
	
	// Now get the "look angle" from the site to the satellite. 
	// Note that the ECI object "eciSDP4" contains a time associated
	// with the coordinates it contains; this is the time at which
	// the look angle is valid.
	cCoordTopo topoLook = siteEquator.GetLookAngle(eciSDP4);
	
	// Print out the results. Note that the Azimuth and Elevation are
	// stored in the cCoordTopo object as radians. Here we convert
	// to degrees using rad2deg()
	
	//printf("AZ: %.3f  EL: %.3f\n", 
	//	   rad2deg(topoLook.m_Az), 
	//	   rad2deg(topoLook.m_El));
	
	

		   
					 //  rad2deg(topoLook.m_Az), 
					 //  rad2deg(topoLook.m_El));	
					   

    sprintf(buffer,"AZ: %f EL: %f : ",  rad2deg(topoLook.m_Az), rad2deg(topoLook.m_El) ); 
	
	tempText->Assign("so: ");
	resultText->AppendText(*tempText);
	
	//resultText->Assign(buffer);
	
	
	err = result.SetAsText( *resultText, *locale );

	return err;
}



