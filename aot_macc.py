#!/usr/bin/env python
import os, glob, sys
import numpy as np
import xarray as xr
import matplotlib.pyplot as plt   # Plotting data
from optparse import OptionParser
#from argparse import ArgumentParser
from mytools.met_tools import print_all

def get_aot(data, **kwarg):
    trh = kwarg.pop('trh', 40)
    hour_begin = kwarg.pop('hbegin',8)
    hour_end = kwarg.pop('hend',20)
    test = 1e9*data.where((data.time.dt.hour>=hour_begin) & (data.time.dt.hour<=hour_end) & (data.go3 > trh*1e-9), drop=True)
    test = (test-trh).resample(time='1D').sum()
    test.attrs['units'] = 'ppb h-1'
    return(test)

def plot_data(data, title, show=False):
    plt.close('all')
    test40_820 = get_aot(data, trh=40)
    test30_820 = get_aot(data, trh=30)
    test40_123 = get_aot(data, trh=40, hbegin=1, hend=23)
    test30_123 = get_aot(data, trh=30, hbegin=1, hend=23)
    
    fig1 = plt.figure()
    fig1.canvas.set_window_title("%s" % (title))
    ax11 = plt.subplot(221)
    ax12 = plt.subplot(222)
    ax13 = plt.subplot(223)
    ax14 = plt.subplot(224)
    levels = np.arange(0,20001,1000)
    test40_820.go3.sum(dim='time').plot(ax=ax11,levels=levels[::2])
    test40_123.go3.sum(dim='time').plot(ax=ax12,levels=levels[::2])
    test30_820.go3.sum(dim='time').plot(ax=ax13,levels=levels[::2])
    test30_123.go3.sum(dim='time').plot(ax=ax14,levels=levels[::2])
    ax11.set_title("AOT40_8-20")
    ax12.set_title("AOT40_1-23")
    ax13.set_title("AOT30_8-20")
    ax14.set_title("AOT30_1-23")
    for ax in fig1.axes:
        ax.set_xlabel('')
        ax.set_ylabel('')
        
    ax13.set_xlabel("Latitude (deg)", x=1.25)
    ax13.set_ylabel("Longitude (deg)", y=1.25)
    if show:
        plt.show(block=False)
    print_all()

def write_data(data, outfile):
    test40_820 = (get_aot(data, trh=40)).go3
    test30_820 = (get_aot(data, trh=30)).go3
    test40_123 = (get_aot(data, trh=40, hbegin=1, hend=23)).go3
    test30_123 = (get_aot(data, trh=30, hbegin=1, hend=23)).go3
    dataset = xr.Dataset({'AOT40_8-20':test40_820, 'AOT40_1-23':test40_123, 'AOT30_1-23':test30_123, 'AOT30_8-20':test30_820})
    print("Writing: %s" % (outfile))
    dataset.to_netcdf(outfile)

def main():
       
    usage = "usage: %prog -p INPUTDIR --year YYYY  --end_year YYYY [--start_month MM] [--end_month MM] [--plot]"
    parser = OptionParser(usage=usage)
    parser.add_option("-y", "--start_year", dest="start_year",
                      help="year YYYY", metavar="start_year",type=int )
    parser.add_option("-e", "--end_year", dest="end_year",
                      help="end_year YYYY", metavar="end_year", type=int)
    parser.add_option("--start_month", dest="start_month",
                      help="start month MM", metavar="start_month", type=int)
    parser.add_option("--end_month", dest="end_month",
                      help="end month DD", metavar="end_month", type=int)
    parser.add_option("--plot", dest="plot",
                      help="plot True/False", metavar="plot")
    parser.add_option("-p", "--path", dest="path",
                      help="Path to source VMR ozone files", metavar="path")
    
    (options, args) = parser.parse_args()
    if not options.path:
        parser.error("input directory must be specified!")
    else:
        nc_src = options.path
    if not options.start_year:
        parser.error("start year must be specified!")
    else:
        start_year = options.start_year
    if not options.end_year:
        end_year = start_year+1
    else:
        end_year = options.end_year
    if not options.start_month:
        start_month = 1
    else:
        start_month = options.start_month
    if not options.end_month:
        end_month = 12
    else:
        end_month = options.end_month
    if not options.plot:
        bPlot = False
    else:
        bPlot = True

    #Data source
    #nc_src = os.environ['DATA']+"/astra_data/ECMWF/MACC_reanalysis/netcdf/VMR/tmp/"
    #file_name = "interp_macc_r_o3_ml60_200501.nc"
    for deltayear in range(end_year-start_year):
        for file_name in sorted(glob.glob(nc_src+'interp_*20%s*.nc' % (str(start_year+deltayear-2000).zfill(2)))):
            print(file_name)
            data = xr.open_dataset(file_name)
            if bPlot:
                plot_data(data, os.path.basename(file_name[7:-3]))
            write_data(data, file_name.replace('tmp', 'netcdf/aot').replace('interp', 'aot'))
            data.close()
    

if __name__ == "__main__":
    main()



