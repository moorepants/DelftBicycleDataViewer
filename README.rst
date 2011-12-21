This program was an attempt at simultaneously visualizing the motion data and
video data collected during experiments in 2008/2009 at the TU Delft bicycle
dynamics lab with an instrumented bicycle. It was also my first Matlab gui
design experience. The program allows you to load the data from a particular
run and play, pause, rewind the video with a running strip chart of the main
data alongside the video. We abandoned the effort due to the inability to time
synchronize the sensor data with the video data, but I post this simply as
sample code that may be useful to someone.

Dependencies
------------

- Matlab: At least version 6.5 for the videoIO dependency.
- videoIO r531 by Gerald Dalley http://sourceforge.net/projects/videoio/. If
  running on Windows, it is easiest to download the precompile binaries, and
  simply add the folder to your Matlab path.

Data
----

The data, including video, can be downloaded from:

Other
-----

The strip chart fundamentals were modeled after:
http://www.mathworks.com/matlabcentral/fileexchange/3356-strip-chart

Usage
-----

Download the source code and the data files. Place the videos in the
`videoFiles` directory and the sensor data in the `dataFiles` directory. Run
the `data_viewer` m-file and the GUI will load. Select a data file from the
`dataFiles` directory and load it with the GUI's buttons. Play the video.
