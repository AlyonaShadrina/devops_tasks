# Watch free disk space
The script checks if there is enough free disks space in % in watch mode (re-check happens every 5s). 

The default definition of "enough" space is 10%, but you can provide your own value. 

Will run on Windows and Linux.
```
./watchdf.sh <number>
```

# Count files in provided directories
The script counts the number of files that exist in each given directory and its subdirectories. 

The default directory is current directory. 

Will run on Windows and Linux.
```
./count_files.sh <path_to_directory> <path_to_directory>
```