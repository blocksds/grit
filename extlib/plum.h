//
//! \file plum.h
//!  Extra libplum stuff
//! \date 20070226 - 20070226
//! \author cearn
// === NOTES ===
// * Now, why am I using CLDIB stuff when I could just as 
//	 well have use FreeImage all round? Well, historical reasons, I 
//	 guess. The FreeImage library is large, VERY large. And to use 
//	 a library that's bigger than the app itself seems strange.
//	 Aside from that, FI didn't quite have all I wanted when I 
//	 started this, so internally I'm using something that is.

#ifndef __FI_PLUM_H__
#define __FI_PLUM_H__

#include <cldib.h>

#include "libplum.h"

void plumInit();

// For converting between CLDIB and FIBITMAP
// and saving/loading. 
CLDIB *plum2dib(struct plum_image *fi);
struct plum_image *dib2plum(CLDIB *dib);
CLDIB *cldib_load(const char *fpath, void *extra);
bool cldib_save(const CLDIB *dib, const char *fpath, void *extra);

/*!	\}	*/

#endif	// __FI_EX_H__
