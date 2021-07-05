#! /bin/bash
#--------------------------------------------------------------------
# Script to loop through a set of file and concatenate them
#
# Author: Stefanie Falk
# Date:   January 2020
# Update: 
#
#--------------------------------------------------------------------
##### Functions
usage()
{
    echo "Usage: ./cat_noaa_ozone_data.sh [[ -s | --start_year start_year ] [ -e | --end_year end_year][ -o | --output output_name] [--station station_identifier]]"
}

check_null()
{
    if [ $# -eq 0 ]; then
        echo "No arguments provided!"
        usage
        exit 1
    fi
}

options()
{
    while [ "${1}" != "" ]; do
        case $1 in
            -s | --start_year )           
                shift
                start_year=${1}
                echo "Start year: ${start_year}"
                ;;
            -e | --end_year )                
                shift
                end_year=${1}
                echo "End year: ${end_year}"
                ;;
            -o | --output_dir )                
                shift
                output=${1}
                echo "output: ${output}"
                ;;
            -h | --help )           
                usage
                exit
                ;;
            * )                     
                usage
                exit 1
        esac
        shift
    done
}

cycle_years() {
    year=${start_year}
    
    if [[ $start_year > 0 ]]; then
        while [ $year -le $end_year ]; do
            # Download data from ftp
            concat_files $year
            # Update counter
            year=$(($year + 1))
        done
    fi

}

concat_files() {
    year=$1
    echo "Concatenating files " $year
    #for each in `ls brw_o3*`; do cat $each >> BRW_Ozone_Hourly_2013; done
}

### MAIN
# Check if arguments were provided
check_null $@
# Cycle through options
options $@
# Cycle through years
cycle_years
