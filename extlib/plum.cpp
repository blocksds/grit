// SPDX-FileNotice: Modified from the original version by the BlocksDS project, starting from 2023.
//
//! \file plum.cpp
//!  Extra libplum stuff
//! \date 20070226 - 20070226
//! \author cearn

#include <stdint.h>
#include <stdio.h>

#include <cldib.h>

#include "cldib_core.h"
#include "cldib_tools.h"
#include "libplum.h"
#include "plum.h"

// ! Initialize libplum and related materials
void plumInit()
{
	dib_set_load_proc(cldib_load);
	dib_set_save_proc(cldib_save);
}

// === cldib -> LIBPLUM stuff ===

#define CLDIB_PLUM_COLOR_FORMAT (PLUM_COLOR_32 | PLUM_ALPHA_INVERT)

struct plum_image *dib2plum(CLDIB *dib)
{
	if(dib == NULL)
		return NULL;

	dib_convert(dib, dib_get_bpp(dib) < 8 ? 8 : 32, 0, false);

	struct plum_image *image = plum_new_image();
	if(image == NULL)
		return NULL;
	image->width = dib_get_width(dib);
	image->height = dib_get_height(dib);
	image->color_format = CLDIB_PLUM_COLOR_FORMAT;
	image->max_palette_index = 0;
	image->frames = 1;

	if (dib_get_bpp(dib) == 32) {
		image->data = plum_malloc(image, sizeof(uint32_t) * image->width * image->height);
		if (image->data == NULL) {
			plum_destroy_image(image);
			return NULL;
		}
		memcpy(image->data, dib_get_img(dib), sizeof(uint32_t) * image->width * image->height);
	} else if (dib_get_bpp(dib) == 8) {
		int nclrs = dib_get_nclrs(dib);
		image->max_palette_index = nclrs - 1;
		image->data = plum_malloc(image, sizeof(uint8_t) * image->width * image->height);
		image->palette = plum_malloc(image, sizeof(uint32_t) * nclrs);
		if (image->data == NULL || image->palette == NULL) {
			plum_destroy_image(image);
			return NULL;
		}
		memcpy(image->data, dib_get_img(dib), sizeof(uint8_t) * image->width * image->height);
		memcpy(image->palette, dib_get_pal(dib), sizeof(uint32_t) * nclrs);
	}

	return image;
}

// --------------------------------------------------------------------
// LIBPLUM - CLDIB WRAPPERS
// --------------------------------------------------------------------

CLDIB *plum2dib(struct plum_image *fi)
{
	if(fi == NULL)
		return NULL;

	CLDIB *dib;

	if (fi->palette != NULL) {
		int nclrs = ((int)fi->max_palette_index + 1);
		dib = dib_alloc(fi->width, fi->height, 8, (const BYTE*) fi->data);
		if (dib == NULL)
			return NULL;
		plum_convert_colors(dib_get_pal(dib), fi->palette, nclrs, CLDIB_PLUM_COLOR_FORMAT, fi->color_format);
	} else if (fi->color_format != CLDIB_PLUM_COLOR_FORMAT) {
		uint32_t *colors = (uint32_t*) malloc(sizeof(uint32_t) * fi->width * fi->height);
		if (colors == NULL)
			return NULL;
		plum_convert_colors(colors, fi->data, fi->width * fi->height, CLDIB_PLUM_COLOR_FORMAT, fi->color_format);
		dib = dib_alloc(fi->width, fi->height, 32, (const BYTE*) colors);
		free(colors);
	} else {
		dib = dib_alloc(fi->width, fi->height, 32, (const BYTE*) fi->data);
	}

	// flip for top down
	// dib_vflip(dib);

	return dib;
}

//! Loads an image
/*!	\param fpath	Full path of image file
*	\return	Valid CLDIB, or NULL on failure
*/
CLDIB *cldib_load(const char *fpath, void *extra)
{
	unsigned error;
	struct plum_image *image = plum_load_image_limited(fpath, PLUM_MODE_FILENAME, CLDIB_PLUM_COLOR_FORMAT | PLUM_PALETTE_LOAD,
		16384 * 16384, &error);

	if(image == NULL) {
		fprintf(stderr, "Error loading image '%s': %s (%u)\n", fpath, plum_get_error_text(error), error);
		return NULL;
	}

	CLDIB *dib = plum2dib(image);
	plum_destroy_image(image);
	return dib;
}

bool cldib_save(const CLDIB *dib, const char *fpath, void *extra)
{
	struct plum_image *image = dib2plum((CLDIB*) dib);

	if(image == NULL)
		return false;

	unsigned error;
	size_t len = plum_store_image(image, (void*) fpath, PLUM_MODE_FILENAME, &error);

	if(len == 0) {
		fprintf(stderr, "Error saving image '%s': %s (%u)\n", fpath, plum_get_error_text(error), error);
		return false;
	} else {
		return true;
	}
}

// EOF
