/*
 *  MyFunction.cpp
 *  PlugInTemplate
 *
 *  Created by Ralf Berge on 12.04.11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */


#include "FMPlugin.h"
#include "FMTemplate/FMTemplate.h"

FMX_PROC(fmx::errcode) MyFunction(       short          funcId,
								  const fmx::ExprEnv&  environment,
								  const fmx::DataVect& dataVect,
								  fmx::Data&     result )
{
	fmx::errcode        err = 0;


    fmx::TextAutoPtr    tempText;
    fmx::TextAutoPtr    resultText;
	
	
	fmx::LocaleAutoPtr locale;
	
	resultText->Assign("Mac OS X");
	
	err = result.SetAsText( *resultText, *locale );

	return err;
}



