# 1D Life In Z80 Assembly for the Tatung Einstein
An implementation of Life in 1D in Z80 Assembly for the Tatung Einstein, based on BASIC from Nakazoto (thanks Nakazoto for the video and BASIC, it has reignited my retro programming enthusiasm) - see https://github.com/Nakazoto/CenturionComputer/blob/main/Software/New%20Software/1DLIFE.BAS

This is as direct a port of the 6502 as I can manage and was created, edited and debugged using the Tatung Bytes Assembly lab - https://www.tatungbytes.co.uk/assembly-lab.

Thanks to AI for converting the RNG section to Z80 for me! Seeding with R (the memory Refresh counter) makes for a good variety of starts when combined with the '--- Press Any Key To Start ---' message which waits for a key press before seeding the RNG. This eliminates the situation where the RNG always has the same seed.

You can run this by opening the Assembly Lab from above and pasting in the .asm text and then clicking Run. Alternatively use the self booting disc image 1DLifeZ80.dsk in MAME or via a Gotek on real hardware.
