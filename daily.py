#!/usr/bin/python2.7
# -*- coding: big5-*-
'''
2013-08-21
retrieve daily weather chart from South Africa Weather Service
and surface wind plot from weather-forecast.com
'''
from urllib import urlretrieve
from time import localtime
import os

today = localtime()
y = today[0]
m = today[1]
d = today[2]
j = '%s' %(today[-2]-1)
jj = '%s' %(today[-2]-2)
if m < 10:
    td= '%s0%s%s' % (y, m, d)

# Modify paths.
par= '/Users/yucheng/Desktop/cruise/'
share='/Users/yucheng/Dropbox/cruise/'

# download plots and nc files.
path = par+'images/'
path2= par+'data/'
www = 'http://www.weathersa.co.za/web/images/Articles/ma_sy.gif'
www2= 'http://assets.weather-forecast.com/maps/static/SouthAfrica.wind.6.cc23.jpg'
img = 'SA_synoptic-%s-%s-%s-12Z.gif' % (y, m, d)
img2= 'SA_wind-%s-%s-%s-12Z.jpg' % (y, m, d)
urlretrieve(www, path + img)
urlretrieve(www2,path + img2)

os.chdir(par)
domodis='/usr/local/bin/wget -P ./data/ ftp://podaac-ftp.jpl.nasa.gov/allData/modis/L3/aqua/11um/4km/daily//2013/'+j+'/A2013'+j+'.L3m_DAY_SST_4.bz2'
os.system(domodis)
os.chdir(path2)
unzip1='bunzip2 A2013'+j+'.L3m_DAY_SST_4.bz2'
os.system(unzip1)

os.chdir(par)
doghr='/usr/local/bin/wget -P ./data/ ftp://podaac-ftp.jpl.nasa.gov/allData/ghrsst/data/L4/GLOB/REMSS/mw_ir_OI//2013/'+jj+'/'+td+'-REMSS-L4HRfnd-GLOB-v01-fv03-mw_ir_rt_OI.nc.gz'
os.system(doghr)
os.chdir(path2)
unzip2='gunzip '+td+'-REMSS-L4HRfnd-GLOB-v01-fv03-mw_ir_rt_OI.nc.gz'
os.system(unzip2)

os.chdir(par)
prog='/usr/local/bin/wget -P ./data/ http://nomads.ncep.noaa.gov/pub/data/nccf/com/rtofs/prod/rtofs.'+td+'/rtofs_glo_2ds_f024_daily_prog.nc'
os.system(prog)

os.chdir(par)
diag='/usr/local/bin/wget -P ./data/ http://nomads.ncep.noaa.gov/pub/data/nccf/com/rtofs/prod/rtofs.'+td+'/rtofs_glo_2ds_f024_daily_diag.nc'
os.system(diag)

# # execute ncl scripts
os.chdir(par)
os.system('/Users/yucheng/Documents/app/ncl/bin/ncl modis_sst.ncl')        # Plot Daily MODIS SST
os.system('/Users/yucheng/Documents/app/ncl/bin/ncl meteor_daily_final.ncl')  # Plot GHRSST and RTOFS 


# Tar and zip all images into one files
os.chdir(par)
tar='tar zcvf '+td+'.tar.gz images'
os.system(tar)

# Move tar file to shared directory
os.chdir(par)
mov='mv '+td+'.tar.gz '+share
os.system(mov)


os.chdir(path)
os.system('rm *')

os.chdir(path2)
os.system('rm *')
