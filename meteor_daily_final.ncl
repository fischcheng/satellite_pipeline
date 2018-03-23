;*************************************************
; meteor_daily.ncl        
;************************************************
load "/Users/yucheng/Documents/app/ncl/lib/ncarg/nclscripts/csm/gsn_code.ncl" 
load "/Users/yucheng/Documents/app/ncl/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "/Users/yucheng/Documents/app/ncl/lib/ncarg/nclscripts/csm/contributed.ncl"   
;************************************************
begin
wcStrt = systemfunc("date")
;************************************************
; read in netCDF file
;************************************************
  diri="./data/"
  dout="./images/"
  fout="RTOFS_GHRSST_"+systemfunc("date +%Y%m%d")

  day    = stringtoint(systemfunc("date +%j"))-2
  dd= systemfunc("date +%Y%m%d")
  f1=dd+"-REMSS-L4HRfnd-GLOB-v01-fv03-mw_ir_rt_OI.nc"
  f2="rtofs_glo_2ds_f024_daily_diag.nc"
  f3="rtofs_glo_2ds_f024_daily_prog.nc"

  ghr = addfile(diri+f1,"r")
  diag = addfile(diri+f2,"r")
  prog = addfile(diri+f3,"r")
;************************************************
; read in GHRSST and RTOFS
;************************************************
  ghrsst=short2flt(ghr->analysed_sst(0,::5,::5))
  rtofs_ssh=diag->ssh(0,:,:)
  rtofs_sst=prog->sst(0,:,:)
  rtofs_u=prog->u_velocity(0,0,:,:)
  rtofs_v=prog->v_velocity(0,0,:,:)
  ghrsst=ghrsst-273.15
  ghrsst@units="degC"

  lon2d=prog->Longitude
  lat2d=prog->Latitude
  
  sst = rtofs_sst(::5,::5)
  sst@lon2d = lon2d(::5,::5)
  sst@lat2d = lat2d(::5,::5)

  ssh = rtofs_ssh(::5,::5)
  ssh@lon2d = lon2d(::5,::5)
  ssh@lat2d = lat2d(::5,::5)
  ssh@long_name = "SSH"

  u = rtofs_u(::5,::5)
  u@lon2d = lon2d(::5,::5)
  u@lat2d = lat2d(::5,::5)

  v = rtofs_v(::5,::5)
  v@lon2d = lon2d(::5,::5)
  v@lat2d = lat2d(::5,::5)

  speed=u
  speed=sqrt(u*u+v*v)
  speed@lon2d = lon2d(::5,::5)
  speed@lat2d = lat2d(::5,::5)
  speed@long_name = "current speed"

;************************************************
; create each plot
;************************************************
  wks = gsn_open_wks("ps",dout+fout)              
  gsn_define_colormap(wks,"matlab_jet")               
  plot = new(4,graphic)                  
setvalues NhlGetWorkspaceObjectId()
  "wsMaximumSize": 500000000      ; need some extra workspace
end setvalues

;************************************************
; draw polylines:
;************************************************

 acty = (/-33.3438,-34.4000,-34.6730,-34.9580,-35.3460,-35.7338/)
 actx = (/27.4808,28.0944,28.2566,28.4274,28.6622,28.9000/)
 bengx = (/12.5,14.8/)
 bengy = (/-26.0,-26.0/)
 emcx = (/48.13,49.17/)
 emcy = (/-22.72,-22.97/)
  resp                  = True                      ; polyline mods desired
  resp@gsLineColor      = "black"                     ; color of lines
  resp@gsLineThicknessF = 3.0                       ; thickness of lines
; resp@gsLineLabelString= "ACT"                    ; adds a line label string

; create array of dummy graphic variables. This is required, b/c each line
; must be associated with a unique dummy variable.
  dum = new(12,graphic)

;************************************************
; resources for the SST plots
;************************************************
  res = True
  res@gsnDraw              = False        ; do not draw picture
  res@gsnFrame             = False        ; do not advance frame   
                                
  res@cnLevelSelectionMode = "ManualLevels"     
  res@cnMinLevelValF       = 0.               
  res@cnMaxLevelValF       = 30.               
  res@cnLevelSpacingF      =   0.5             
  res@gsnSpreadColors= True 
  res@cnFillOn              = True    
  res@cnLinesOn             = False   
  res@cnFillOpacityF = 0.8
  res@gsnLeftString = "SST"

  res@mpDataBaseVersion = "Ncarg4_1"  
  res@mpOutlineBoundarySets = "National" 
  res@mpMinLatF            = -50     
  res@mpMaxLatF            = -0.
  res@mpMinLonF            =  0.
  res@mpMaxLonF            = 60.
     
  res@lbOrientation        = "Vertical"   ; vertical label bar

;************************************************
; resources for different sections
;************************************************  

  res@gsnLeftString         = "GHRSST" 
  plot(0) = gsn_csm_contour_map(wks,ghrsst,res)  ;
    dum(0)=gsn_add_polyline(wks,plot(0),actx,acty,resp)       
    dum(1)=gsn_add_polyline(wks,plot(0),bengx,bengy,resp) 
    dum(2)=gsn_add_polyline(wks,plot(0),emcx,emcy,resp) 

  res@gsnLeftString         = "RTOFS SST" 
  plot(1) = gsn_csm_contour_map(wks,sst,res)
    dum(3)=gsn_add_polyline(wks,plot(1),actx,acty,resp)       
    dum(4)=gsn_add_polyline(wks,plot(1),bengx,bengy,resp) 
    dum(5)=gsn_add_polyline(wks,plot(1),emcx,emcy,resp)
;************************************************
; resources for the SSH plot
;************************************************
  res2 = True
  res2@gsnDraw              = False        ; do not draw picture
  res2@gsnFrame             = False        ; do not advance frame                                   
  
  res2@cnLevelSelectionMode = "ManualLevels"     
  res2@cnMinLevelValF       = -1.5               
  res2@cnMaxLevelValF       = 1.5               
  res2@cnLevelSpacingF      =   0.05             
  
  res2@gsnSpreadColors= True 
  res2@cnFillOn              = True    
  res2@cnLinesOn             = False   
  res2@cnFillOpacityF = 0.8

  res2@mpDataBaseVersion = "Ncarg4_1"  
  res2@mpOutlineBoundarySets = "National" 
  res2@mpMinLatF            = -50     
  res2@mpMaxLatF            = -0.
  res2@mpMinLonF            =  0.
  res2@mpMaxLonF            = 60.
     
  res2@lbOrientation        = "Vertical"   ; vertical label bar
  res2@gsnLeftString         = "RTOFS SSH" 
  plot(2) = gsn_csm_contour_map(wks,ssh,res2)
    dum(6)=gsn_add_polyline(wks,plot(2),actx,acty,resp)       
    dum(7)=gsn_add_polyline(wks,plot(2),bengx,bengy,resp) 
    dum(8)=gsn_add_polyline(wks,plot(2),emcx,emcy,resp)
;************************************************
; resources for the Current plot
;************************************************
  res3 = True
  res3@gsnDraw              = False        ; do not draw picture
  res3@gsnFrame             = False        ; do not advance frame       
  res3@cnFillOn             = True               ; turn on color for contours
  res3@cnLinesOn            = False              ; turn off contour lines
  res3@cnLineLabelsOn       = False              ; turn off contour line labels
  res3@gsnSpreadColors      = True               ; use full color map

  res3@mpDataBaseVersion = "Ncarg4_1"  
  res3@mpOutlineBoundarySets = "National" 
  res3@mpMinLatF            = -50     
  res3@mpMaxLatF            = -0.
  res3@mpMinLonF            =  0.
  res3@mpMaxLonF            = 60.
     

  res3@lbOrientation            = "Vertical"     ; vertical label bar
 ; res@pmLabelBarOrthogonalPosF = -0.01          ; move label bar closer
 ; res@lbLabelStride            = 4

   res3@cnLevelSelectionMode = "ManualLevels"     ; set manual contour levels
   res3@cnMinLevelValF       = 0.0               ; set min contour level
   res3@cnMaxLevelValF       = 1.5                 ; set max contour level
   res3@cnLevelSpacingF      = 0.05               ; set contour spacing

  
  res3@gsnLeftString         = "RTOFS Surface Current"  
  plot(3)=gsn_csm_contour_map(wks,speed,res3)
    dum(9)=gsn_add_polyline(wks,plot(3),actx,acty,resp)       
    dum(10)=gsn_add_polyline(wks,plot(3),bengx,bengy,resp) 
    dum(11)=gsn_add_polyline(wks,plot(3),emcx,emcy,resp)

;************************************************
; panel plot
;************************************************
 resP                 = True
 resP@gsnMaximize = True
 resP@txString = systemfunc("date +%x")
 gsn_panel(wks,plot,(/2,2/),resP)
 wallClockElapseTime(wcStrt, fout , 0)
end
