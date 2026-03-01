#!/bin/bash

#Basic script for converting steam recordings to usable video formats.
#Help menu
help() {
   echo "This is a basic script for converting steam recordings to useable formats."
   echo "By default Steam records in stream format, multiple files and a master sesion.md."
   echo "Using ffmpg we can transform it into more traditional video formats."
   echo "Some video players may play the sesion.md without a problem, but for sharing not so much."
   echo "The options override the defaults, for recurrent executions i strongly recomend to edit the script."
   echo
   echo "Syntax: scriptTemplate [-f|h|i|o]"
   echo "options:"
   echo "f     Output format"
   echo "h     Print this Help."
   echo "i     Imput directory"
   echo "o     Output directory"
   echo
}

#Imput directory
idir="/mnt/c/Users/*********/Videos/Steam Recordings/clips"
ifile=""

#Output directory
odir="/mnt/c/Users/*********/Videos/captures"
ofile=""

#Format
f=".mp4"

#Game id
appid=""
tappid=""

#Timestamp
time=""

#Game name
appname=""

#Folder list
folders=""
sfolders=""


#Gets the appid from the folder name and saves the timestamp information.
getappid(){
    time=${i#*_}
    appid=${time%%_*}
}

#Fetch the app name from the internet, from steam charts.
#Curl outputs the raw html and the using regx we can extract the name.
getappname(){
    appname=$(curl -s https://steamcharts.com/app/$appid | grep -Po "(?<=app.{19}).*(?=<\/a)")
    appname=${appname// /_}
    tappid=$appid
}

#Uses ffmpeg to process the video, we take advantage of the fixed structure of the capture folders
#By default it overrides the output file and does the work silently, preserving the original framerate and resolution.
#If you need other options when using ffmpeg please check the documentation and modify accordingly the command
processvideo(){
    ifile="$idir/$i/video/$o/session.mpd"
    ofile="$odir/$appname"_"$time$f"

    #ffmpeg command
    #Minor update, added -c copy to maintain same codec, found out the slow way.
    ffmpeg -y -loglevel error -stats -i  "$ifile" -c copy "$ofile"

}

#Get the list of folders 
folderlist(){
    folders=$(ls "$idir")
}


#Proccess the options for quick execution
while getopts "f:hi:o:" option; do
    case $option in
    #Format
        f)  
            f=$OPTARG
            ;;
    #Help
        h) 
            help
            exit;;
    #Imput directory
        i)
            idir=$OPTARG
            ;;
    #Output directory
        o)
            odir=$OPTARG
            ;;
    #Rest of cases
        \?)
            echo "Invalid option, exiting"
            exit
            ;;
   esac
done


#Main loop of the script, gets folders, gets name from the id, and then transforms then using ffmpep

folderlist

for i in ${folders[@]}; do

    getappid
    #Check if we are working on the same game, to not call multiple times to steamcharts.
    if [[ $appid != $tappid ]]; then
        getappname
        echo "Processing the game $appname"
    fi

    #gets subfolders of video, should only be one
    sfolders=$(ls "$idir/$i/video")
    
    for o in ${sfolders[@]}; do
        processvideo
    done
    
    echo "Done :D"


done
