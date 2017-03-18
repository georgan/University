This README provides an overview of the MATLAB Code that was developed during the thsis. For a more detailed description of the functions, place the folder on the MATLAB path and type "help function_name" on MATLAB's command prompt. The MATLAB Code is devided into folders and subfolders as follows:

- AudioFeatures: contains the code of the features that are extracted from audio and are described in thesis text. The main functions that are used to compute each feature are:
	- stnrg.m computes short time energy of signal.
	- loudness.m computes the loudness of the signal.
	- roughness.m computes the roughness of the signal.
	- frdim1.m computes the fractal dimension of 1D signal.
	- extractMFCC.m extracts MFCC features from the signal.

Functions that extract features that are not described in the thesis and were not used at the experiments are:
	- zeroCrossingRate computes zero crossing rate of the signal.
	- specflux computes the spectral flux of a signal.

Also, a function for the computation of histograms is provided.


- dataVisualization: contains functions for the visualization of data in two and three dimensions.


- nsltools: this is a toolbox that is used to compute the auditory spectrum of a sound signal (Shamma's model), and it was used in this thesis. The folder contains many functions that perform various utilities, and most of them were not used here. The function that was mainly used is wav2aud.m that computes the auditory spectrum of the signal. This function gets two mandatory input arguments. The first one is the sound signal, and the second is a vector of parameters. The parameters vector that was used in the thesis is [8 16 -2 0]. This function also depends on the following files: loadload.m, sigmoid, aud24, and aud24_old.

For the visualization of the auditory spectrum, aud_plot.m function can be used (not mandatory), which is based on imagesc.m (MATLAB's function). This function depends on isa1pam.m and a1map_a.m.

The functions that were used from the nsltools folder are the following:
	- a1map_a
	- aud24
	- aud24_old
	- aud_plot
	- isa1map
	- loadload
	- sigmoid
	- wav2aud


- SalMap_frontend: contains functions for the computation of Saliency Map and Temporal Saliency Map. The main functions are feature_Map.m for Saliency Map, and tempsalmap.m for the computation of Temporal Saliency Map.


-utilities: this folder contains functions to perform post-processing of the data, as well as functions to measure the performance of the algorithms (evaluationMeasures subfolder).


At the machine learning part of the thesis, kmeans.m and knnclassify.m were used (MATLAB's functions). Also, for SVM classification, LIBSVM and LIBLINEAR packages were used and can be found at the following URLs, respectively:

https://www.csie.ntu.edu.tw/~cjlin/libsvm/

http://www.csie.ntu.edu.tw/~cjlin/liblinear/
