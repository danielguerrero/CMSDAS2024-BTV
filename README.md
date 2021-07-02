# HATS 2021
Repository for BTaggingExercise for HATS 2021

## Installation
```
export SCRAM_ARCH=slc7_amd64_gcc700

cmsrel CMSSW_10_6_16
cd CMSSW_10_6_16/src/
cmsenv

git clone https://github.com/mondalspandan/HATS2021/

scram b -j8

cd HATS2021/BTaggingExercise/
voms-proxy-init -voms cms
```
## Running
The b-tagging calibration SF is calculated via the `BTagWeight` class defined in `BTagWeight.cc` using the pre-calculated efficiency histograms from `EffHistos/`. `Selection.C` runs selection criteria on the input samples while using the `BTagWeight` class to calculate the b-tag weight for each event.

### Step 1:

You would first need to get the input files required for this exercise. They are located at FNAL EOS and can be copied via XRootD to your local working directory. Execute:
```
xrdcp -r root://cmseos.fnal.gov//store/user/cmsdas/2021/short_exercises/BTag/ .
```

This will require ~850 MB of free space. Alternatively, you can read the inputs directly from FNAL EOS over XRootD, e.g., when you do not have sufficient local disk space. To do so, you can skip the above command and instead edit `Selection.C` to uncomment L135:
```
std::string inputDirPath="root://cmseos.fnal.gov//store/user/cmsdas/2021/short_exercises/BTag/";
```
and comment out L136 instead. This has, however, been observed to run slower, especially outside the FNAL/LPC network. 

### Step 2:
Out of the box, both `Selection.C` and `BTagWeight.cc` are incomplete. The exercise requires you to understand what the `BTagWeight` class does and complete it accordingly. Please refer to the twiki for instructions.

### Step 3:
Once you are satisfied with your code, you can test it on one input sample. But first, it is necessary to create a library using ROOT as follows.
```
root -l -b
root [0] .L Selection.C+g
root [1] .q

```
If there are no errors in your code, this will create a shared object `Selection_C.so`  and related dictionaries.

### Step 4:
To test the code on one sample, try:
```
mkdir -p Output
root -b -q 'Selection.C+(5)'
```
This runs the selection on sample #5, for example. Likewise, it needs to be run on all samples numbered -1 (data) and 1 through 10 (MC).

### Step 5:
To run on all processes now type the following command.
```
source process_all.sh
```
It takes around 20-25 minutes for all the jobs to complete. For information regarding the overall progress refer to the individual job logs stored in the `logs/` directory. The logs can be followed, for example, using `tail -f logs/*`.

*Note: This step might take longer than expected, depending on your local computer's capacity. While most jobs finish in a few seconds, sample index #1 a.k.a. dileptonic ttbar MC has the highest stats and takes the longest. You can play around with the `maxEvents` variable inside `Selection.C` to get it to process only a fraction of the full stats.*

### Step 5:
`make_plot.C` script can be used to check Data-MC comparison plots with two different b-tagging calibration methods, namely (1a) fixed WP-based (index=1) and (2b) discriminant reshaping (index=2) from https://twiki.cern.ch/twiki/bin/viewauth/CMS/BTagSFMethods . Also the plots w/o  applying the SFs can be obtained by switching to index=0.     

```
mkdir -p plots/noSF/ plots/fixedWP/ plots/ReShape/
root -l -q "make_plot.C+(\"allJetsDeepFlavB\",1)"
```
One can replace the variable and the index in the above line to get plots for other observables and calibration methods. Compare the DeepJet score for the leading (first) jet using the SFs due to the two calibration methods mentioned above and also w/o any calibration SFs.