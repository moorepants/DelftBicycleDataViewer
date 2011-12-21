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

- Matlab
- videoIO r531 by Gerald Dalley http://sourceforge.net/projects/videoio/

Data
----

The data, including video, can be downloaded from:

Other
-----

The strip chart fundamentals were modeled after:
http://www.mathworks.com/matlabcentral/fileexchange/3356-strip-chart
