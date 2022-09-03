## Submission details

- This is a submission to correct HTML Tidy problems as described in Kurt Hornik's email.

```
Result: NOTE
    Found the following HTML validation problems:
    gt_plt_summary.html:62:1: Warning: <img> lacks "alt" attribute
    gt_plt_winloss.html:99:1: Warning: <img> lacks "alt" attribute
```

- I have corrected those issues by providing an alt attribute.

## R CMD check results

There were no ERRORs, WARNINGs or NOTEs

Checked against automated test environments, RHub, MacBuilder, and WinBuilder (oldrel/devel/release)

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
