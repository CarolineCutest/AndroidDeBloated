#!/bin/sh

declare -a bloatArray
declare -a packageArray

packageSubstring="package:"
bloat=bloat.txt
packageTemp=temp.txt

#Verify if the device si connected
adbDevices=$(adb devices | grep -w "device")
if ! [[ $adbDevices ]]; then
        echo "Device not plugged in"
        continue
else
  #Taking and storing Package Names
  adbPackages=$(adb shell pm list packages)
  echo "$adbPackages" >> "$packageTemp"

  #Option value for the operation mode 
  option=0

  while [ $option -le 0 ]; do
      echo "Do you want to :
        1.debloat  
        2.reinstall bloats
        3.use a bloat list"
      read -p "Enter choice :" option_input
    # the if statement contain a regex expression
    # ^ is to verify that the caracter match at the begening of the string
    #[1-3] is an inclusive array of single numbers that can match
    #+ can be used to accept more than one number matching
    #$ is used to verify than the caracter match at the end of the string
      if ! [[ $option_input =~ ^[1-3]$ ]]; then
          echo "Error: Please enter a valid option"
          continue
      fi
      ((option = option_input))  # update the condition variable 'option '
  done
  if [[ $option =~ ^[1]$ ]]; then
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
  elif [[ $option =~ ^[2]$ ]]; then
    echo "work in progress"
  elif [[ $option =~ ^[3]$ ]]; then
    read -p "Enter bloatlist path :" pathDeleteList
    while IFS= read -r line; 
        do 
          search=$(grep -l "$line" $pathDeleteList)
            if [ "$search" = "$pathDeleteList" ]; then
                #Remove Substring
                packageNoSubstring=${line/$packageSubstring/}
                adb shell pm uninstall --user 0 $packageNoSubstring
                echo "$packageNoSubstring uninstalled"
            fi
    done < $packageTemp
  fi
    #Delete temporary file
    rm $packageTemp
fi
