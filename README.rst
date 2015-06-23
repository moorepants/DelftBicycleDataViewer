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

http://dx.doi.org/10.5281/zenodo.18862 (1 GB)

Note that the yaw rate, lean rate and steer rate columns are for the body fixed
angular rates about these axes. See my dissertation for details:
http://moorepants.github.com/dissertation/delftbicycle.html#rate-gyros

The rates you probably want are the ones defined in the for the benchmark
bicycle in [Meijaard]2007]_ and they can be computed as such:

yaw rate = yaw rate column

roll rate = -roll rate column

steer rate = steer rate colum + roll rate colum * sin(lambda) - yaw rate column * cos(lambda)

Where lambda = 0.4276 for the Batavus Browser bicycle which we used in the
experiments.

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
