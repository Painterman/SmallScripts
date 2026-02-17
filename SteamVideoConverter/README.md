# Steam Video Converter

A small script used to convert the default steam recordings format m4s to a more usable format using ffmpeg.

## Requisites

-   bash
-   ffmpeg
-   execution permissions
-   read the script before using

In windows i use wsl2 to run it.

## How it works

This script takes all of the recordings from the provided steam_recordings/clips folder, navigates to the video/fg_xxxx_xxx_xxx folder, takes the session.md and transforms it to the desired output format and saves to the provided output folder.

As a nice trick it also navigates to steamcharts and extracs from there the name of the game you are recording. In case you didn´t know, the default folder format created by steam is clip_appid_date_timestamp, i take the appid from there.

The output file name is the appname_appid_date_timestamp, so they also stay nice and organized by chronological order.

## Usage

Download the script to your local computer, check that it does what it supposed to do, and then either edit the script to use you folder structure/format or do a quick run with overriden parameter. For that you can use the following arguments:

-   -f: Output format. eg: .mp4
-   -h: Help menu, just in case you are lost.
-   -i: Input directory. The directory where clips are stored.
-   -o: Output directory. The destination where converted clips are saved.
