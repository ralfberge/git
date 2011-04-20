//
// cSite.h: interface for the cSite class.
//
// Copyright 2002-2003 Michael F. Henry
//
//////////////////////////////////////////////////////////////////////

#pragma once

#include "coord.h"
#include "cEci.h"

namespace Zeptomoby 
{
namespace OrbitTools
{

//////////////////////////////////////////////////////////////////////
// class cSite
// This class represents a location (ground site) on the earth.
class cSite  
{
public:
   cSite(double degLat, double degLon, double kmAlt);
   cSite(const cCoordGeo &geo);
   virtual ~cSite();

   void      SetGeo(const cCoordGeo &geo);       // Set new coordinates
   cCoordGeo GetGeo() const { return m_geo; }

   cEci       GetPosition(const cJulian&) const; // calc ECI of geo location.
   cCoordTopo GetLookAngle(const cEci&)   const; // calc topo coords to ECI object

   double GetLat() const { return m_geo.m_Lat; }
   double GetLon() const { return m_geo.m_Lon; }
   double GetAlt() const { return m_geo.m_Alt; }

   string ToString() const;

protected:
   cCoordGeo m_geo;  // lat, lon, alt of Earth site

};
}
}