# CMSDAS@LPC2024
Repository for BTaggingExercise for CMSDAS@LPC2024. 

The exercise twiki: https://twiki.cern.ch/twiki/bin/view/CMS/SWGuideCMSDataAnalysisSchoolLPC2024TaggingExercise

## Installation

The installation has been tested on the FNAL LPC assuming the pre-exercises (https://twiki.cern.ch/twiki/bin/view/CMS/CMSDASAtLPC2024#PreExercises2024) have been done in advance.

```
export SCRAM_ARCH=slc7_amd64_gcc700

cmsrel CMSSW_10_2_24
cd CMSSW_10_2_24/src/
cmsenv

git clone https://github.com/danielguerrero/CMSDAS2024-BTV.git

scram b -j4

cd CMSDAS2024-BTV/BTaggingExercise/
voms-proxy-init -voms cms
```
## Running
The b-tagging calibration SF is calculated via the `BTagWeight` class defined in `BTagWeight.cc` using the pre-calculated efficiency histograms from `EffHistos/`. `Selection.C` runs selection criteria on the input samples while using the `BTagWeight` class to calculate the b-tag weight for each event.

### Step 1:

You would first need to make sure the input files required for this exercise are accessible. They are located in `/store/user/cmsdas/2024/short_exercises/BTag/`. You can find the path hardcoded in `Selection.C` in L144.

#### Only if files are not accessible

> *Only in case* you cannot access the directory directly, you can download the input files to your local space. They are located at FNAL EOS and can be copied via XRootD to your local working directory. Execute:
> ```
> mkdir -p BTag
> env -i X509_USER_PROXY=${X509_USER_PROXY} xrdcp -r root://cmseos.fnal.gov//store/user/cmsdas/2024/short_exercises/BTag BTag
> ```
> This will require ~850 MB of free space. Now you can comment out L144 in `Selection.C` and uncomment L145 instead.

### Step 2:
Out of the box, both `Selection.C` and `BTagWeight.cc` are incomplete. The exercise requires you to understand what the `BTagWeight` class does and complete it accordingly. Please refer to the twiki for instructions (Implementing BTagCalibration inside the macro): https://twiki.cern.ch/twiki/bin/view/CMS/SWGuideCMSDataAnalysisSchoolLPC2024TaggingExercise

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

### Step 6:
`make_plot.C` script can be used to check Data-MC comparison plots with two different b-tagging calibration methods, namely (1a) fixed WP-based (index=1) and (1d) discriminant reshaping (index=2) from https://twiki.cern.ch/twiki/bin/viewauth/CMS/BTagSFMethods . Also the plots w/o  applying the SFs can be obtained by switching to index=0.     

```
mkdir -p plots/noSF/ plots/fixedWP/ plots/ReShape/
root -l -b -q "make_plot.C+(\"allJetsDeepFlavB\",1)"
```
One can replace the variable and the index in the above line to get plots for other observables and calibration methods. Compare the DeepJet score for the leading (first) jet using the SFs due to the two calibration methods mentioned above and also w/o any calibration SFs.

**Tip:** Once you are comfortable running individual root commands, you can use the following bash script to automatically plot all the histograms for you:
```
source plotall.sh
```
Hint: on FNAL LPC you can use `display` to open `.png` files.
