# Change log

### v0.8.4 (20100204)

- I have **completely replaced** the tilemapping core for something more general
  and versatile. The new mapping options should allow any tile-size and
  bitdepths 8 and over. This should make it easier to use grit for other
  purposes as well. NOTE: I have tested this with a number of methods, but I'm
  sure I missed a few things. Notably, how it will work on big-endian systems.
  If your tilemaps are screwed up now, this is the likely cause.
- One consequence of the new mapping core is that external-tiles can now work on
  a meta-tile basis instead of just 8×8 tiles.
- Another consequence is that you can now create custom bitformats for the map
  entries (`-mB`). This can be used to create 1bpp collision maps or use a
  larger range or tile-indices, for example.
- Added `-tw` and `-th` options for custom tile dimensions.
- Added `-tc` for column-major tiling.
- Added `-mp` option, which should be useful for NDS ext-pal modes.
- The `-Len` identifiers are now proper constants instead of `#define`.
- The `vector.insert` problem on non-MSVC systems should be gone now.

### v0.8.3 (20081207)

- Fixed ... well let's call it a clash of arguments regarding names for shared
  data names if `-S` or `-O` wasn't supplied (thanks dovoto)
- grit files can now be used to add more input-files (thanks dovoto)
- mapsel offset `-ma` should work for the whole mapsel now, not just the
  tile-index part.

### v0.8.2 (20081129)

- The GRF format didn't quite follow IFF standards, it should work with standard
  readers now.
- When creating a meta-map, the meta-tiles now have the affix "MetaTiles"
  instead of "Map". Yes, it does mean things may break, but it simply makes more
  sense this way.
- The C-exported arrays now have `__attribute__(aligned(4))`, so you don't have
  to worry about alignment in C anymore either.

### v0.8 (20080212)

- Added `-gS` and `-pS` for shared tileset and palettes and `-O` and `-S` for
  shared symbol/output names. Also fixed the way shared runs were done: it
  excludes the parts to be shared from the individual export, and do an
  additional run with just the shared data afterwards.
- Added GRF format and the options that go with it (`-ftr`, `-fr`)
- Added "fake" compression options (`-Z0`, etc) for symmetry with the
  compression options. Like the other compression options, the size will be in
  the upper 24 bits of the first word.
- Exit codes. Grit returns 1 on failure.
- Some internal refactoring. Hope I didn't screw up things too badly.

### v0.7 (20070414)

- Added batch file grind.bat for drag/drop conversion. (Yes, Dave, it's a
  batchfile, but sometimes you just want a quick sample without fussing.)
- Project rename. git's now grit.
- Changed the way directories work. All relative paths start from the current
  working directory, whatever that may be. This also fixes a bug when for
  dir-less `-fx` options (thanks dovoto).
- Default filetype is now assembly (`-fts`). If you're using DKP or tonc
  template makefiles, this should not be a problem.
- Added `-We`, `-Ww`, `-Ws` aliases for `-W<n>`.
- Added no converted output option `-ft!`.

### v0.7b (20070317)

- Batchrun: Multiple bitmaps in one go (no wildcards though).
- Dwimming for transparency options (i.e., `-gT` and `-pT` interaction)
- Error/warning/status logging functions (`-W`).
- External tilefile support (`-fx`).

The batchrun and external tilefile support is still experimental. YHBW.
