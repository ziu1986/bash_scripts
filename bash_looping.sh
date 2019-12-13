#!/bin/bash
#--------------------------------------------------------------------
# Script to loop through a given range of years
#
# Author: Stefanie Falk
# Date:   December 2019
# Update: 
#
#--------------------------------------------------------------------
##### Functions
usage()
{
    echo "Usage: ./bash_looping [[ -s | --start_year start_year ] [ -e | --end_year end_year][ -o | --output_dir output_directory]]"
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
                output_dir=${1}
                echo "output_dir: ${output_dir}"
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
            download_from_ftp $year
            # Update counter
            year=$(($year + 1))
        done
    fi

}

download_from_ftp() {
    year=$1
    echo "Download data for " $year
    #wget --ftp-user=nbrown  --ftp-password='Stedman5!' ftp://<serveradress to be put>/$year/* ${output_dir}
}

### MAIN
# Check if arguments were provided
check_null $@
# Cycle through options
options $@
# Cycle through years
cycle_years
