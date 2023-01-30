# Single Trial Detection of Error-related Potentials

This repository contains MATLAB code for the paper titled "Single trial detection of error-related potentials in brain–machine interfaces: a survey and comparison of methods," in Journal of Neural Engineering, vol. 20, 2023, doi: [10.1088/1741-2552/acabe9](https://doi.org/10.1088/1741-2552/acabe9).

## Preparation

First you need to download the data. The links for the datasets:

LSC Speller 
https://ieee-dataport.org/open-access/error-related-potentials-primary-and-secondary-errp-and-p300-event-related-potentials-%E2%80%93

BNCI Moving Cursor
http://bnci-horizon-2020.eu/database/data-sets  ->  22. Monitoring error-related potentials (013-2015) 

Kaggle P300 Speller
https://www.kaggle.com/competitions/inria-bci-challenge/data

HRI (cursor) & HRI (robot)
https://github.com/stefan-ehrlich/dataset-ErrP-HRI

Coadaptation
https://github.com/stefan-ehrlich/dataset-ErrP-coadaptation

Game Agent
https://ieee-dataport.org/documents/errp-dataset

Gaze Speller
https://doi.org/10.6084/m9.figshare.5938714.v1

Tactile Feedback (V) & Tactile Feedback (VT)
https://teep-sla.eu/index.php/results/40-smc2017-dataset

Virtual Cursor
https://github.com/flowersteam/self_calibration_BCI_plosOne_2015 


## Dependencies

The folder 'HelperFunctions' must be added to MATLAB path. You also need to add to the path the following packages.

Fisher criterion beamformer—statistical spatial filter for event related potentials (available at: https://github.com/gpiresML/FCB-spatial-filter)

Matlab toolboxes for EEG signal analysis—BCI calibration reduction toolbox (available at: https://sites.google.com/site/fabienlotte/research/codeand-softwares)

Matlab toolbox for classification and regression of multi-dimensional data(available at: https://github.com/treder/MVPA-Light)


## Preprocessing 
Run `Dataset*_savemat` files for each dataset. You can change the preprocessing parameters. By default, the signal is bandpass filtered between 1 and 10 Hz.

## Classification
 
Run `Dataset*_savemat` files for each dataset. You can change the preprocessing parameters. By default, the signal is bandpass filtered between 1 and 10 Hz.

Start App Designer (type appdesigner in MATLAB command window)
Open `ErrP_APP.mlapp`, choose Dataset and subject, and then click Run.

![alt text](https://github.com/mineysm/ErrP_APP/blob/main/ErrP_App.PNG)

## Project website

[B-RELIABLE] (https://sites.google.com/view/b-reliable/)
