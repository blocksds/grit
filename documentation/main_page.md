Grit: GBA Image Transmogrifier {#mainpage}
==============================

## 1. Introduction

The GBA Image Transmogrifier (“grit” for short) is a bitmap conversion tool for
GBA/NDS development. It accepts a multitude of file types (bmp, pcx, png, gif,
etc) at any bitdepth and can convert them to palette, graphics and/or map data
that can be used directly in GBA code. The output formats are C/asm arrays, raw
binary files GBFS files, and a RIFF-format I call GRF. The data can be
compressed to fit the BIOS decompression routines.

Grit can do more than simply turn bitmap into arrays. It allows you to crop or
enlarge the original work area, convert between bitdepths, break the images up
into tiles or metatiles and supports NDS bitmaps with transparency. It also has
a number of tile-mapping options: it can take the bitmap and turn it into a
tilemap (and metamap) and a set of unique tiles. It can also merge the palettes
or tilesets from multiple files.

If you need more, feel free to add your own code. This is an open-source project
and the code should compile on all platforms, though you'll have to write your
own makefiles for non-Windows environments.

## 2. List of options

### 2.1 Graphics options

- `-g`: Include graphics in output.
- `-g!`: Exclude graphics from output.
- `-gb`: Bitmapped graphics output. NOTE: without an `-gT` option, this data
  will have a clear bit 15.
- `-gt`: Tiled graphics output (default).
- `-ga <n>`: Pixel offset for non-zero pixels. Useful if the associated palette
  is at an offset.
- `-gB <n>`: Bit depth of the output. Can be 1, 2, 4, 8 or 16. 16 bpp is a
  truecolor mode, the rest are paletted. If the source image is not of this
  bitdepth yet, it will be converted.
- `-gS`: Shared graphics. Build up a shared tileset for the multiple images. See
  also `-fx`, `-S` and `-O`.
- `-gT [ <h> ]`: Transparent color. The color should be a 16bit BGR color or
  24bit RGB color in hex. For truecolor output, all pixels will have the
  alpha-bit set except this color. For paletted output, this color will be
  transferred into index 0.
- `-gT!`: No transparent pixels / set the alpha-bit of the pixels. Only has
  effect for NDS bitmaps.
- `-gu8`: Graphics data is in byte arrays.
- `-gu16`: Graphics data is in halfword arrays.
- `-gu32`: Graphics data is in word arrays (default).
- `-gz!`: Graphics data is not compressed. (default)
- `-gz0`: As `-gz!`, but with a 32-bit compression header similar to the ones
  used by the GBA/NDS BIOS. Byte 0: 0x00. Bytes 1-3: size of data.
- `-gzh`: Graphics data is 8-bit Huffman compressed.
- `-gzl`: Graphics data is LZ77 compressed.
- `-gzr`: Graphics data is RLE compressed.

### 2.2 Area options

- `-ab <n>`: Bottom side of the work bitmap's rectangle. If this falls outside
  of the source bitmap, the latter will be extended.
- `-ah <n>`: Height side of the work bitmap's rectangle. If this makes the
  bottom fall outside of the source bitmap, the latter will be extended.
- `-al <n>`: Left side of the work bitmap's rectangle. If this falls outside of
  the source bitmap, the latter will be extended.
- `-ar <n>`: Right side of the work bitmap's rectangle. If this falls outside of
  the source bitmap, the latter will be extended.
- `-at <n>`: Top side of the work bitmap's rectangle. If this falls outside of
  the source bitmap, the latter will be extended.
- `-aw <n>`: Width of the work bitmap's rectangle. If this makes the right side
  fall outside of the source bitmap, the latter will be extended.

### 2.3 Map options

- `-m`: Include map in output. Enables tile-mapping of the image.
- `-m!`: Exclude map from output (default).
- `-ma <n>`: Tile index offset (non-zero indices only). Useful if you intend to
  load the tiles at an offset.
- `-mB...`: Custom mapsel (map('s?) element) bitformat. The regexp format for it
  is `"-mB((\d+):)([iphv_]\d*)+"`, that is, `"-mB"`, followed by the bitdepth of
  the mapsel, a colon and a character-number pattern indicating the big-endian
  order and size of the bitfields. Available fields and their indicators:

  - `i`: tile-index
  - `p`: palette-bank index
  - `h`: horizontal flip
  - `v`: vertical flip
  - `_`: empty field

  For example, the Text-BG mapsel format is: `"16:p4vhi10"`

- `-mLa`: Map layout for affine tilemaps: 8-bit screen entries and a flat map.
- `-mLf`: Map layout for regular backgrounds. 16-bit entries, but a flat map
  (i.e., not broken down into screenblocks).
- `-mLs`: Map layout for regular backgrounds. 16-bit entries, broken down into
  screenblocks.
- `-mp <n>`: Forces the palette-bank index to `n`.
- `-mR!`: Disable tile reduction for tilemaps.
- `-mR4`: Tile reduction combo for regular backgrounds with 4bpp tiles: tile,
  palette and flip reduction.
- `-mR8`: Tile reduction combo for regular backgrounds with 8bpp tiles: tile and
  flip reduction.
- `-mRa`: Tile reduction combo for affine backgrounds: tile reduction only.
- `-mRf`: Tile reduction option: reduce for flipped tiles. Can be combined with
  `t` and `p` reduction options (example: `-mRtpf`).
- `-mRp`: Tile reduction option: reduce for 16-color palette banks. Can be
  combined with t and f reduction options (example: `-mRtpf`). Do not use this
  for 8bpp tiles, you'll regret it.
- `-mRt`: Tile reduction option: reduce for unique tiles. Can be combined with p
  and f reduction options (example: `-mRtpf`).
- `-mu8`: Map data is in byte arrays.
- `-mu16`: Map data is in halfword arrays (default).
- `-mu32`: Map data is in word arrays.
- `-mz!`: Map data is not compressed. (default)
- `-mz0`: As `-mz!`, but with a 32-bit compression header similar to the ones
  used by the GBA/NDS BIOS. Byte 0: 0x00. Bytes 1-3: size of data.
- `-mzh`: Map data is 8-bit Huffman compressed.
- `-mzl`: Map data is LZ77 compressed.
- `-mzr`: Map data is RLE compressed.

### 2.4. Metamap/object options

- `-Mh`: Metatile height. Useful for keeping the tiles in a metatile/object
  together. If tile-mapping is enabled, this will enable metamapping. Works
  together with `-Mw`.
- `-Mw`: Metatile width. Useful for keeping the tiles in a metatile/object
  together. If tile-mapping is enabled, this will enable metamapping. Works
  together with `-Mh`.
- `-MRp`: Metatile palette reduction.

### 2.5. Palette options

- `-p`: Include palette in output (default).
- `-p!`: Exclude palette from output.
- `-pe <n>`: End' palette entry. For example, `-pe` 32 would output the palette
  up to, but not including, color 32. Works together with `-ps`.
- `-pn <n>`: Number of palette entries. Works together with `-ps`; overrules
  `-pe`.
- `-ps <n>`: Starting palette entry. `-ps` 16 would start the export at color
  16. Works together with `-pe` and `-pn`.
- `-pS`: Shared palette data. The colors of the source bitmaps are merged into a
  single palette. See also `-O` and `-S`. NOTE: will alter the order of the
  original palette (unless the first bitmap happened to have all the colors in
  it (hint, hint)).
- `-pT <n>`: Transparent palette index. Only works if the input or output is
  paletted. For paletted output, it'll swap the transparent index with index 0
  so that that becomes the transparent index. For paletted to truecolor
  conversion, the color of the transparent index will be used for transparency,
  working as a `-gT` option.
- `-pu8`: Palette data is in byte arrays.
- `-pu16`: Palette data is in halfword arrays (default).
- `-pu32`: Palette data is in word arrays.
- `-pz!`: Palette data is not compressed. (default)
- `-pz0`: As `-pz!`, but with a 32-bit compression header similar to the ones
  used by the GBA/NDS BIOS. Byte 0: 0x00. Bytes 1-3: size of data.
- `-pzh`: Palette data is 8-bit Huffman compressed.
- `-pzl`: Palette data is LZ77 compressed.
- `-pzr`: Palette data is RLE compressed.

### 2.6. Input/output options

- `-fa`: Append to output file instead of overwriting. If data with the symbol
  name already exists in the file, it will be replaced. Has no effect for binary
  output.
- `-ff <path>`: Flag file for additional options. Instead of adding all the
  options to the makefile, you can use an external file to store and modify
  them.
- `-fh`: Create header file with declarations and array length definitions
  (using array-name + Len).
- `-fh!`: Do not create header file with declarations.
- `-fr`: Group the separate arrays into a GRF-formatted array. See also `-ftr`.
- `-ftb`: Export to binary files. Each array will have its own file: palettes
  will go into `*.pal.bin`; graphics data into `*.img.bin`; map data into
  `*.map.bin`; metamap data into `*.meta.bin`.
- `-ftc`: Export to C arrays.
- `-ftg`: Export to [PinEight GBFS](http://www.pineight.com) format. Note that
  the GBFS entry names are limited to 24 characters, 6 of which are already used
  for data affixes.
- `-ftr`: Export to GRF (Grit RIFF).
- `-fts`: Export to GNU assembly arrays. Default output filetype.
- `-fx <path>`: External tileset bitmap which can then be shared between
  different tilemaps. Implies `-gS`. **NOTE**. This is still a little fickle.
  The file must already be in the correct format: a column or reduced tiles with
  8bpp. If the file-type does not support 8bpp, a `.bmp` of the same name will
  be used.
- `-o <path>`: Output file path.
- `-O <path>`: Output file path for shared data.
- `-s <name>`: Base name for array symbols. Invalid identifier characters will
  be replaced by underscores. If this option is not given, then the name follows
  from the output title, or from the input title if `-fa` is given.
- `-S <path>`: Base name for symbols for shared data.

### 2.7. Misc options

- `-tc`: Tiling is done in column-major order, instead of row-major. This can be
  useful for horizontal scrollers, or efficient tile rendering.
- `-th <n>`: Set height of basic tile (default: 8).
- `-tw <n>`: Set width of basic tile (default: 8).
- `-U8`: Set all output to use byte arrays.
- `-U16`: Set all output to use halfword arrays.
- `-U32`: Set all output to use word arrays.
- `-Z!`: Set all output to use no compression.
- `-Z0`: As `-Z!`, but with a 32-bit compression header similar to the ones
  used by the GBA/NDS BIOS. Byte 0: 0x00. Bytes 1-3: size of data.
- `-Zh`: Set all output to use 8-bit Huffman compression.
- `-Zl`: Set all output to use LZ77 compression.
- `-Zr`: Set all output to use RLE compression.
- `-W1`: Log error messages.
- `-W2`: Log errors and warning messages.
- `-W3`: Log error, warning and status messages. There are a _lot_ of status
  messages, so this is mainly for debugging.
- `-We`: See `-W1`.
- `-Ws`: See `-W2`.
- `-Ww`: See `-W3`.

## 3. DWIM

For those who don't know, “DWIM” stands for “[Do What I
mean](http://en.wikipedia.org/wiki/DWIM)”, in the sense that grit attempts to
guess at options that aren't specified explicitly, or correct for options that
conflict, rather than quite and yell at you. In principle, this can be
considered a Good Thing, but it does make it harder to predict exactly what will
happen at times.

The list here covers the various defaults and overrides that Grit uses. I'll try
to make it as complete and accurate as possible, but it sometimes gets so
convoluted that even I don't know anymore ^\_^;;. If you find something that's
wring or missing here, please let me know.

### 3.1. Default settings

- **Exported data**: palette and graphics data is exported by default, tilemaps
  are not (`-p`/`-g`/`-m!` options). No compression.
- **Palette**: palette data will consist of the full palette of the input
  bitmap. What this actually means depends on the bitdepth.
- **Graphics format**. Tiled graphics in the input bitmap's bitdepth for
  paletted images (`-gt`). Or 16bpp bitmap for truecolor images (`gb`).
- **Bitmap transparency**. The alpha-bit will be clear if no `-gT` option is
  given. For a colorless `-gT`, magenta will be used to indicate the transparent
  color.
- **Area**: size of the input bitmap.
- **Mapping: tile reduction**: reduce for unique and flipped tiles (`-mR8`).
  _NOTE_: grit will always start a new tileset with an empty tile.
- **Mapping: layout**: regular screen entries, flat map (`-mLf`).
- **Meta-mapping**. A meta-map will be generated if mapping is enabled and `-Mw`
  and/or `-Mh` is greater than 1. If mapping is disabled, the meta-map settings
  indicate object tile groups.
- **Data formats**. The default output is asm arrays with a header file (`-fts`
  `-fh`). Graphics are word-arrays, Palette and map data are halfword arrays.
- **Append/replace**. Currently, the default is to overwrite the existing file,
  but it may make more sense to use append/replace instead (`-fa`).
- **Filenames**. If no output name is given, it will be based on the input name
  (which should always exist). The extension _will_ be one of the following:
  `.c`/`.s`/`.bin`/`.gbfs`. Anything else will be changed.
- **Symbol names**. If no symbol name is given (`-s`), it is based on the output
  name in overwrite mode, or the input name in append mode (`-fa`). Invalid
  characters for identifiers are replaced with underscores.
- **Directories**. Unless an absolute path is given, the base directory will be
  the current working directory. This means _no_ Drag&Drop over a grit shortcut,
  because the cwd there won't be what you'd want.
- **External tilefile**. `-fx` requires mapping, but does _not_ automatically
  set a `-m` option.

### 3.2. Overrides

- **Transparent color vs palette**. This is ... complicated. Use of `-pT` and
  `-gT` together is not advised.
- **Filetypes**. The `-ft` options override the filetype given by `-o`.
- **Global datatype/compression**. `-U` and `-Z` set the datatype and
  compression options for all arrays, but they can be overridden with
  data-specific options like `-pu` and `-gz`.

## 4. Examples

TODO

## 5. Additional information

### 5.1. GRF files

I made myself a [RIFF](http://en.wikipedia.org/wiki/RIFF_(File_format)) binary
format because a) different loose binaries are somewhat annoying and b) they
lose all context. A RIFF chunk looks like this:

```c
struct chunk_t {
    char id[4];
    u32  size;
    u8   data[1];
};
```

A 4-byte identifier, a 4-byte size field, indicating the size of the data (_not_
the size of the whole chunk!) and a variable-length data array. A `GRF` chunk
(pronounced “griff”) will look like this:

```
"RIFF" # {
    "GRF " # {
        "HDRX" # { header info }
        "HDR " # { deprecated header info }
        "GFX " # { gfx data }
        "MAP " # { map data }
        "MTIL" # { metatile data }
        "MMAP" # { metamap data }
        "PAL " # { palette data }
        "PIDX" # { tex4x4 palette indices data }
    }
}
```

The names are the (sub-)chunk identifiers, '#'s the size field, and the
accolades indicate the data arrays. Each of the chunks inside the `GRF` chunk is
actually optional, with the exception of the header. What goes into the header
is still tentative, but for now it looks like this:

```c
typedef struct
{
    uint16_t version;  ///< Version of the GRF format (currently 2)
    uint16_t gfxAttr;  ///< BPP of graphics (or GRFTextureTypes). 0 if not present.
    uint16_t mapAttr;  ///< BPP of map (16 or 8 for affine). 0 if not present.
    uint16_t mmapAttr; ///< BPP of metamap (16). 0 if not present.
    uint16_t palAttr;  ///< Number of colors of the palette. 0 if not present.
    uint8_t  tileWidth, tileHeight; ///< Size of tiles in pixels
    uint8_t  metaWidth, metaHeight; ///< Size of metamap in tiles
    uint16_t unused; ///< Currently unused
    uint32_t gfxWidth, gfxHeight;   ///< Size of graphics in pixels
} GRFHeader;
```

The attributes here are just the bitdepths for now, or 0 if the the item isn't
exported, but this behaviour may change later. The tileWidth and tileHeight are
the tile dimensions in pixels, and metaWidth/Height are the metatile dimensions
in **tile**-units.

GrfHeader is unfinished

I'm still considering what should go into the header here; things like
map/metamap sizes may be useful, as would offsets, formats and other niceties.
These may be added at a later date.

The following is a simple reader for GRF-formatted data.

```c
#define CHUNK_ID(a,b,c,d)   ((u32)((a) | (b) << 8 | (c) << 16 | (d) << 24))
#define ID_RIFF             CHUNK_ID('R', 'I', 'F', 'F')
#define ID_GRF              CHUNK_ID('G', 'R', 'F', ' ')

//! Decompress a GRF item.
bool grf_decomp(const void *src, void *dst)
{
    if (src == NULL || dst == NULL)
        return false;

    u32 header = *(u32*)src;
    u32 size = header >> 8;

    switch (header & 0xF0)
    {
        case 0x00: // No compression
            tonccpy(dst, (u8*)src + 4, size);
            return true;
        case 0x10: // LZ77
            LZ77UnCompVram(src, dst);
            return true;
        case 0x20: // Huffman
            HuffUnComp(src, dst);
            return true;
        case 0x30: // RLE
            RLUnCompVram(src, dst);
            return true;
        default:
            return false;
    }
}

//! Load grf data
bool grf_load(const void *src, void *gfxDst, void *mapDst, void *palDst)
{
    u32 *src32 = (u32*)src;

    // Must start with "RIFF" - "GRF "
    if ((src == NULL) || (src32[0] != ID_RIFF) || (src32[2] != ID_GRF))
        return false;

    u32 sizeMax = src32[1] - 4; // GRF size
    src32 += 3;                 // Skip GRF ID and size

    for(u32 i=0; i<sizeMax; i += size+8)
    {
        u32 id = src32[0];
        u32 size = src32[1];

        switch (id)
        {
            case CHUNK_ID('G', 'F', 'X', ' '):
                grf_decomp(&src32\[2\], gfxDst);
                break;

            case CHUNK_ID('M', 'A', 'P', ' '):
                grf_decomp(&src32\[2\], mapDst);
                break;

            case CHUNK_ID('P', 'A', 'L', ' '):
                grf_decomp(&src32\[2\], palDst);
                break;
        }
        src32 += (size + 8) / 4;
    }

    return true;
}
```

Note that the header and metamap chunks are ignored here for simplicity's sake.
Also note the decompression routine. I've made it a requirement that each item
**must** have a header word compatible with the BIOS functions, even if there is
no actual compression (hence the difference between `-Z0` vs `-Z!`). That way
you can get the compression-type from the data itself, even if there's no actual
compression. Another requirement is that each chunk must be word-aligned. This
is actually part of the RIFF-spec itself.

There is a reference to `tonccpy()` in `grf_decomp()`. This is a `memcpy()`
replacement that also works properly for GBA-VRAM. You can get it from
[coranac:tonccpy](http://www.coranac.com/2008/01/25/tonccpy/), or you can just
replace the call with `memcpy()` or any other copy routine if you're sure you
won't run into trouble with those.

You can export to GRF using `-ftr`. You can also get GRF arrays by using `-fr`,
but that presently only works for C and asm data. The extension used for the
arrays there is `.grf`.

### 5.2. Shared data

In previous versions, you could have build up shared tileset with the `-fx`
option. This would add new tiles to the tileset if they couldn't be found and
save it to a bitmap. This worked, but because the runs were still essentially
singular you ended up with intermediary palettes and tilesets unless you took
steps to prevent it. And you had to export the tileset separately afterwards.

As of v0.8 this is now different. If …

1. you have multiple source files, and
2. `-gS`, `-pS` or `-fx` is set

… grit will exclude the temporary palette and/or tileset (whatever is
appropriate) from the individual parts and only export the completed sets at the
end. The name of the shared data can be controlled with `-S` and that of the
shared output file with `-O` (uppercase for shared, versus lowercase for
individual). If you don't add these names, they will be taken from the lowercase
versions; if those are absent too, the name of the first source file will be
used as a basis.

### 5.3. Todo list

Here are a few things that I'd like to add at some point. If anyone want to help
flesh it out, that'd be great.

- The way the tile-file is handled now is kinda screwed up. Needs to be
  straightened out.
- PCX support for external tileset. FreeImage doesn't allow PCX writing.
- Better batch-run options. Possibly including the ability to clump the data
  together somehow in a matrix.
- Grouped data. For example, if you have a bitmap with several sprite animation
  frames, it's not useful to compress the whole thing because you might want to
  uncompress them separately into VRAM. It'd be nice to have the compression
  apply per frame and use a frame table.
- Long option names.

### 5.4. Last changes

Check the change log [here](documentation/changelog.md).
