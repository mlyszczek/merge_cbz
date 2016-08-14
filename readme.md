Script to merge multiple cbz files into one big cbz.

1. Installation

copy merge_cbz.sh file into /usr/local/bin and update $PATH if needed.

2. Dependency

* unzip and zip for uncompressing and compressing cbz files
* pv - optionally for displaying progress of creating new cbz file

3. Usage

Just cd into directory with cbz files and run merge_cbz.sh, output file
'merged.cbz' will be created, no source cbz files will be modified nor deleted.

4. License

BSD-3-Clause, see license file

