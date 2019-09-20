#! /bin/bash
./cdo_vmr2.sh /home/sfalk/Data/abel/C3RUN_mOSaic_desert_ssp585ship2100/trop_tracer/
mv vmr_ozone200?.nc /home/sfalk/Data/abel/C3RUN_mOSaic_desert_ssp585ship2100/VMR/
rm VMR/*

./cdo_vmr2.sh /home/sfalk/Data/abel/C3RUN_mOSaic_desert2006_ssp585ship2050/trop_tracer/
mv vmr_ozone200?.nc /home/sfalk/Data/abel/C3RUN_mOSaic_desert2006_ssp585ship2050/VMR/
rm VMR/*

./cdo_vmr2.sh /home/sfalk/Data/abel/C3RUN_mOSaic_desert2006_ssp585ship2100/trop_tracer/
mv vmr_ozone200?.nc /home/sfalk/Data/abel/C3RUN_mOSaic_desert2006_ssp585ship2100/VMR/
rm VMR/*
