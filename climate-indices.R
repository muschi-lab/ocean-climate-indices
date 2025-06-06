############################################################################
# This script calculates climate indeces (ENSO, PDO and AMO) from surface 
# 2D ocean temperature data in CMIP output and climate reanalysis.
############################################################################

# load library for reading netcdf files
require(ncdf4)

############################################################################
# name of the nc.file and variable 
ncname <- "my_netcdf_file"
ncfname <- paste(ncname, ".nc", sep = "")
dname <- "tos"  # note: tmp means temperature (not temporary)
ncin <- nc_open(ncfname)
# # obtain some basic info
print(ncin)
############################################################################

############################################################################
# extract coordinates and the surface ocean temperature (TOS) variable
lo <- ncvar_get(ncin, "lon"); nlo <- dim(lo)
la <- ncvar_get(ncin,"lat"); nla <- dim(la)
time <- ncvar_get(ncin, "time")
ts_array <- ncvar_get(ncin, dname)
dim(ts_array) # check dimension

# time vector
time <- seq(1:dim(ts_array)[3])
############################################################################

############################################################################
# Calculate El Nino Southern Oscillation (ENSO)
############################################################################
# define grid coordinates over which ENSO will be estimated
lon1 = 150
lon2 = 270
lat1 = -5
lat2 = 5

# get index of nearest lon/lat values
lon1a = which.min(abs(lon1 - lo))
lon2a = which.min(abs(lon2 - lo)) 
lat1a = which.min(abs(lat1 - la)) 
lat2a = which.min(abs(lat2 - la)) 

# calculate mean across all the selected grid cells
ENSO <- sapply(1:length(time), function(i){ 
  mean(ts_array[lon1a:lon2a,lat1a:lat2a,i], na.rm=T)
})

ENSO <- cbind(time, ENSO)
############################################################################

############################################################################
# Calculate Pacific Decadal Oscillation (PDO)
############################################################################
# define grid coordinates over which PDO will be estimated
lon1 = 120
lon2 = 250
lat1 = 20
lat2 = 65

# get index of nearest lon/lat values
lon1a = which.min(abs(lon1 - lo))
lon2a = which.min(abs(lon2 - lo)) 
lat1a = which.min(abs(lat1 - la)) 
lat2a = which.min(abs(lat2 - la)) 

# calculate mean across all the selected grid cells
PDO <- sapply(1:length(time_sub), function(i){ 
  mean(ts_array[lon1a:lon2a,lat1a:lat2a,i], na.rm=T)
})

PDO <- cbind(time_sub, PDO)
############################################################################

############################################################################
# Calculate Atlantic Multidecadal Oscillation (AMO)
############################################################################
# define grid coordinates over which AMO will be estimated
lon1 = 280
lon2 = 360
lat1 = 0
lat2 = 60

# get index of nearest lon/lat values
lon1a = which.min(abs(lon1 - lo))
lon2a = which.min(abs(lon2 - lo)) 
lat1a = which.min(abs(lat1 - la)) 
lat2a = which.min(abs(lat2 - la)) 

# calculate mean across all the selected grid cells
AMO <- sapply(1:length(time), function(i){ 
  mean(ts_array[lon1a:lon2a,lat1a:lat2a,i], na.rm=T)
})

AMO <- cbind(time, AMO)
############################################################################

############################################################################
# write results
write.table(time, ENSO[,2], PDO[,2], AMO[,2], file="my_results.txt",
            row.names = FALSE, col.names = c("model_yr", "ENSO", "PDO", "AMO"))
############################################################################
