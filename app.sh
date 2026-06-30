#!/bin/bash

declare -a bloatArray
declare -a packageArray

packageSubstring="package:"
bloat=bloat.txt
packageTemp=temp.txt

#Taking and storing Package Names
adb=$(adb shell pm list packages)
echo "$adb" >> "$packageTemp"

  #Comparator
  echo Bloatwares :
  while IFS= read -r line; 
      do 
        search=$(grep -l "$line" $bloat)
          if [ "$search" = "$bloat" ]; then
              #Remove Substring
              packageNoSubstring=${line/$packageSubstring/}
              echo $packageNoSubstring
          fi
  done < $packageTemp

  #Delete temporary file
  rm $packageTemp


