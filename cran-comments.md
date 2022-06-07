## Resubmission

This is a resubmission based on notes in the automated test phase. In this version I have:
- Added a more strict temp-file removal to avoid note on temp files left behind.
- Updated license to 2022
- Removed LazyData since I don't have package data
- Removed VignetteBuilder: knitr since I do not have vignettes at this time

Checked against test environments and WinBuilder (oldrel/devel/release) with 1 expected note (new submission)

## Automated Test environments

on Github Actions:
* ubuntu 20.04.04 (devel, release, oldrel)
* windows (release)
* macOS (release)

on R-universe
* Windows (devel, release, oldrel)
* MacOS (release, oldrel)

## R CMD check results

0 errors | 0 warnings | 0 note

* This is a new release.
