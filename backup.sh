#!/bin/bash

# This checks if the number of arguments is correct
# If the number of arguments is incorrect ( $# != 2) print error message and exit
if [[ $# != 2 ]]
then
  echo "Usage: backup.sh target_directory_name destination_directory_name"
  exit
fi

# This checks if argument 1 and argument 2 are valid directory paths
if [[ ! -d $1 ]] || [[ ! -d $2 ]]
then
  echo "Invalid directory path provided"
  exit
fi

# [TASK 1] Assign arguments to variables
targetDirectory=$1
destinationDirectory=$2

# [TASK 2] Print input paths for confirmation
echo "Target Directory: $targetDirectory"
echo "Destination Directory: $destinationDirectory"

# [TASK 3] Get current timestamp
currentTS=`date +%s`

# [TASK 4] Create backup filename with timestamp
backupFileName="backup-$currentTS.tar.gz"

# [TASK 5] Get absolute path of target directory
origAbsPath=`realpath $targetDirectory`

# [TASK 6] Go to destination directory and get its absolute path
cd $destinationDirectory
destDirAbsPath=`pwd`

# [TASK 7] Go back to the original script location
cd $origAbsPath
cd ..

# [TASK 8] Get timestamp for 24 hours ago
yesterdayTS=$(($currentTS - 86400))

# [TASK 9] Iterate over files in target directory
declare -a toBackup
for file in $(ls $origAbsPath)
do
  # [TASK 10] Get last modified time of file
  fileTS=`date -r $origAbsPath/$file +%s`

  if (( $fileTS > $yesterdayTS ))
  then
    # [TASK 11] Add file to backup list
    toBackup+=($file)
  fi
done

# [TASK 12] Create the tar archive from the list of updated files
tar -czf $backupFileName ${toBackup[@]}

# [TASK 13] Move the backup archive to the destination directory
mv $backupFileName $destDirAbsPath

# Done!
echo "Backup complete. File saved to $destDirAbsPath/$backupFileName"
