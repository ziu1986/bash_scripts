#! /bin/bash
srcdir=${1}
leapyear=( 1904 1908 1912 1916 1920 1924 1928 1932 1936 1940 1944
           1948 1952 1956 1960 1964 1968 1972 1976 1980 1984 1988
           1992 1996 2000 2004 2008 2012 2016 2020 2024 2028 2032
           2036 2040 2044 2048 2052 2056 2060 2064 2068 2072 2076
           2080 2084 2088 2092 2096 2104 )

year=(2004)
var=PPFD
cd ${srcdir}
for iyear in ${year[@]}; do
    if [[ " ${leapyear[@]} " =~ " ${iyear} " ]]; then
        days=( 31 29 31 30 31 30 31 31 30 31 30 31 )
    else
        days=( 31 28 31 30 31 30 31 31 30 31 30 31 )
    fi
    imonth=1
    echo ${imonth}
    while [[ ${imonth} -le 12 ]]; do
        if [ ${imonth} -lt 10 ]; then
            smonth=0${imonth}
        else
            smonth=${imonth}
        fi
        iday=1
        while [[ ${iday} -le ${days[`let ${imonth}-1`]} ]]; do
            if [ ${iday} -lt 10 ]; then
                sday=0${iday}
            else
                sday=${iday}
            fi
            its=0
            while [[ ${its} -lt 8 ]]; do
                let sts=${its}*3
                if [ ${its} -lt 4 ]; then
                    sts=0${sts}
                else
                    sts=${sts}
                fi
                outfile="ECopenIFSc38r1_y${year}m${smonth}d${sday}h${sts}_T159N80L60.nc"
                subdir=${smonth}
                if [ ! -d ${smonth} ]; then
                    echo 'Make dir '${smonth}
                    mkdir ${subdir}
                fi
                let timestep=${its}+${iday}*8-8
                ncks -v ${var} -d time,${timestep} ${var}_${year}-${smonth}.nc ${subdir}/${outfile}
                echo $timestep
                echo $outfile
               
                let its=${its}+1
            done
            let iday=${iday}+1
        done
        let imonth=${imonth}+1
    done
done
             

