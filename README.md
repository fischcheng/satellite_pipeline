### Surface Ocean conditions routine

This is an automated routine to download [RTOFS](http://polar.ncep.noaa.gov/global/) ocean forecast and [MODIS](https://podaac.jpl.nasa.gov) satellite SST observations, to plot these near-real-time data using NCL(NCAR Command Language), and to compress the figures before moving them into a shared Dropbox folder that is accessible on board. Due to a restricted internet connection, it is not practical to download large dataset and plot them on board of research vessels.

#### Steps (daily.py)
* Download regional weather map from South African weather service, satellite observed Sea Surface Temperature (SST) from PO.DAAC, and Sea Surface Height (SSH), current speed (U, V), and SST from RTOFS real-time ocean forecasts. 
* Use two NCL scripts to generate panel plots. 
* Pack these plots into .tar and move to the Dropbox shared folder.

#### Schedule (launchd.conf, com.meteor.daily.plist)
* Setup the environment (for netcdf, cdo and python)
* `com.meteor.daily.plist` set the time and frequency to run the `daily.py`
* put the com.meteor.daily.plist to /Library/LaunchAgents (works only on OSX), but same thing can be done through crontab on Linux. 
