# grit changelog

- 20080304, v0.8

  - Added shared palette and graphics options (`-pS` and `-gS`).
  - Added a separate run for shared data; this also disables items from earlier
    exports if they're supposed to be shared.
  - New filetype: GRF (`-ftr`). GRF is a RIFF with chunks for graphics, map,
    metamap and palete data and a header with additiona information. A reader
    for it can be found in the docs. GRFs are also available for array-data
    using `-fr`.
  - Added a "fake" compression option (`-Z0`) to make non-compresssed data
    follow the same format as compressed data so that a uniform loader can be
    made.
  - Put the version and completion info under the logging to keep the shell
    clean.
  - Exit code for main (0 for OK, 1 for FAIL).
  - Fixed stupid RGB/BGR bug in the conversion code.

- 20070403, v0.7

  - Name change to "grit".
  - Changed the way directories work. All relative paths start from the current
    working directory, whatever that may be. This also fixes a bug when for
    dir-less `-fx` options (thanks dovoto).
  - Default filetype is now assembly.
  - Added `-We`, `-Ww`, `-Ws` aliases for `-W<n>`.
  - Added no converted output option `-ft!`.
  - Added batchfile 'grind.bat' for desktop Drag & Drop runs, for when you want
    a simple & quick conversion.

- 20070317, v0.7b

  - Batchrun: Multiple bitmaps in one go (no wildcards though).
  - Dwimming for transparency options (i.e., `-gT` and `-pT` interaction)
  - Error/warning/status logging functions (`-W`).
  - external tilefile support (`-fx`).
  - The batchrun and external tilefile support is still experimental. YHBW.

- 20070103, v0.6.2

  - true -> pal resulted in a zero-entry palette. This is now fixed. Thanks
    wintermute.

- 20061208, v0.6.1

  - Fixed `-gT` use, which was very, very broken. There should be some
    interaction between `-gT` and `-pT`, but not sure which yet.
  - The append modes for C and asm should work properly now, i.e., if the array
    already exists the new ones will replace it.

- 20060803, v0.6

  - Thanks to wintermute, the code should be fully multiplatform now.
  - Added `-pT`, `-gT`, `-ff` options. See usage.

- 20050915

  - Project started.
