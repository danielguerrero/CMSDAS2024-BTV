mkdir -p plots/noSF/ plots/fixedWP/ plots/ReShape/

for var in {"allJetsDeepFlavB","firstJetDeepFlavB","secondJetDeepFlavB","nJets","nTags"}; do
    for ind in {0,1,2}; do
        root -l -q "make_plot.C+(\"$var\",$ind)";
    done
done
