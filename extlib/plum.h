//
//! \file plum.h
//!  Extra libplum stuff
//!  (adapted from original FreeImage wrappers)
//! \date 20070226 - 20070226
//! \author cearn
//! \author asie

#ifndef __FI_PLUM_H__
#define __FI_PLUM_H__

#include <cldib.h>

#include "libplum.h"

/**
 * @brief Initialize the CLDIB <-> libplum translation layer.
 */
void plumInit();

/**
 * @brief Convert a libplum image struct to a CLDIB image struct.
 * The original libplum image struct is NOT destroyed.
 * 
 * @param fi libplum image struct.
 * @return CLDIB* CLDIB image struct, or NULL if error occured.
 */
CLDIB *plum2dib(struct plum_image *fi);

/**
 * @brief Convert a CLDIB image struct to a libplum image struct.
 * The original CLDIB image struct is NOT destroyed.
 * 
 * @param dib CLDIB image struct.
 * @return struct plum_image* libplum image struct, or NULL if error occured.
 */
struct plum_image *dib2plum(CLDIB *dib);

/**
 * @brief Load CLDIB image using libplum's image I/O facilities.
 * 
 * @param fpath Path to image file.
 * @return CLDIB* CLDIB image struct, or NULL if error occured.
 */
CLDIB *cldib_load(const char *fpath, void *extra);

/**
 * @brief Save CLDIB image using libplum's image I/O facilities.
 * 
 * @param dib CLDIB image struct.
 * @param fpath Path to image file.
 * @return true Image saved successfully.
 * @return false Error occured.
 */
bool cldib_save(const CLDIB *dib, const char *fpath, void *extra);

/*!	\}	*/

#endif	// __FI_EX_H__
