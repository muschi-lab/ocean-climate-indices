############################################################################
# This script calculates climate indices (ENSO, PDO, and AMO) from surface 
# 2D ocean temperature data in CMIP output and climate reanalysis.
############################################################################

# Load libraries for handling NetCDF data
import numpy as np
import xarray as xr

############################################################################
# Define the name of the NetCDF file and the variable of interest
ncname = "my_netcdf_file"
ncfname = ncname + ".nc"
dname = "tos"  # Surface ocean temperature variable
############################################################################

# Open the NetCDF file
ds = xr.open_dataset(ncfname)

############################################################################
# Extract coordinates and the surface ocean temperature (TOS) variable
lo = ds['lon'].values      # Longitudes
la = ds['lat'].values      # Latitudes
time = ds['time'].values   # Time dimension
ts_array = ds[dname].values  # Temperature data (assumed to be lon x lat x time)

# Time vector (assuming 3D data with time as third dimension)
time_vector = np.arange(1, ts_array.shape[2] + 1)
############################################################################

############################################################################
# Calculate El Niño–Southern Oscillation (ENSO)
############################################################################
# Define grid coordinates over which ENSO will be estimated
lon1, lon2 = 150, 270
lat1, lat2 = -5, 5

# Get indices of nearest lon/lat values
lon1a = np.abs(lo - lon1).argmin()
lon2a = np.abs(lo - lon2).argmin()
lat1a = np.abs(la - lat1).argmin()
lat2a = np.abs(la - lat2).argmin()

# Calculate mean across all the selected grid cells for each time step
ENSO = np.array([np.nanmean(ts_array[lon1a:lon2a, lat1a:lat2a, i]) for i in range(ts_array.shape[2])])
############################################################################

############################################################################
# Calculate Pacific Decadal Oscillation (PDO)
############################################################################
# Define grid coordinates over which PDO will be estimated
lon1, lon2 = 120, 250
lat1, lat2 = 20, 65

# Get indices of nearest lon/lat values
lon1a = np.abs(lo - lon1).argmin()
lon2a = np.abs(lo - lon2).argmin()
lat1a = np.abs(la - lat1).argmin()
lat2a = np.abs(la - lat2).argmin()

# Calculate mean across all the selected grid cells for each time step
PDO = np.array([np.nanmean(ts_array[lon1a:lon2a, lat1a:lat2a, i]) for i in range(ts_array.shape[2])])
############################################################################

############################################################################
# Calculate Atlantic Multidecadal Oscillation (AMO)
############################################################################
# Define grid coordinates over which AMO will be estimated
lon1, lon2 = 280, 360
lat1, lat2 = 0, 60

# Get indices of nearest lon/lat values
lon1a = np.abs(lo - lon1).argmin()
lon2a = np.abs(lo - lon2).argmin()
lat1a = np.abs(la - lat1).argmin()
lat2a = np.abs(la - lat2).argmin()

# Calculate mean across all the selected grid cells for each time step
AMO = np.array([np.nanmean(ts_array[lon1a:lon2a, lat1a:lat2a, i]) for i in range(ts_array.shape[2])])
############################################################################

############################################################################
# Write results to a text file
with open("my_results.txt", "w") as f:
    f.write("model_yr, ENSO, PDO, AMO\n")
    for i in range(len(time_vector)):
        f.write(f"{time_vector[i]}, {ENSO[i]}, {PDO[i]}, {AMO[i]}\n")
############################################################################
