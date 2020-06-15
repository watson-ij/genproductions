#!/bin/sh

source /cvmfs/cms.cern.ch/cmsset_default.sh

# genproductions should be setup as below

# git clone https://github.com/cms-sw/genproductions.git # doesn't seem to work in slc6 in the chroot
# cd genproductions
# git checkout -b mg242legacy origin/mg242legacy
# cd bin/MadGraph5_aMCatNLO/
# # Fix up the web address since the model isn't in the usual place for some reason.
# sed -i -e 's:cms-project-generators.web.cern.ch/cms-project-generators/$model:cms-project-generators.web.cern.ch/cms-project-generators/ZprimeToMuMu/$model:' gridpack_generation.sh

MASS=$1

#cd prod
mkdir -p BFF_ZprimeToTauTau_M${MASS}_dbs0p5_InputCards
cp cards/production/2017/13TeV/BFF_ZprimeToTauTau/BFF_ZprimeToTauTau_customizecards.dat BFF_ZprimeToTauTau_M${MASS}_dbs0p5_InputCards/BFF_ZprimeToTauTau_M${MASS}_dbs0p5_customizecards.dat
cp cards/production/2017/13TeV/BFF_ZprimeToTauTau/BFF_ZprimeToTauTau_extramodels.dat BFF_ZprimeToTauTau_M${MASS}_dbs0p5_InputCards/BFF_ZprimeToTauTau_M${MASS}_dbs0p5_extramodels.dat
cp cards/production/2017/13TeV/BFF_ZprimeToTauTau/BFF_ZprimeToTauTau_proc_card.dat BFF_ZprimeToTauTau_M${MASS}_dbs0p5_InputCards/BFF_ZprimeToTauTau_M${MASS}_dbs0p5_proc_card.dat
cp cards/production/2017/13TeV/BFF_ZprimeToTauTau/BFF_ZprimeToTauTau_run_card.dat BFF_ZprimeToTauTau_M${MASS}_dbs0p5_InputCards/BFF_ZprimeToTauTau_M${MASS}_dbs0p5_run_card.dat

sed -i -e "s/set param_card MASS 32 200.0/set param_card MASS 32 ${MASS}.0/" BFF_ZprimeToTauTau_M${MASS}_dbs0p5_InputCards/BFF_ZprimeToTauTau_M${MASS}_dbs0p5_customizecards.dat
sed -i -e "s/set param_card Zprime_Couplings 4 4.000000e-02/set param_card Zprime_Couplings 4 0.5/" BFF_ZprimeToTauTau_M${MASS}_dbs0p5_InputCards/BFF_ZprimeToTauTau_M${MASS}_dbs0p5_customizecards.dat
#sed -i -e "s/set param_card Zprime_Couplings 4 4.000000e-02/set param_card Zprime_Couplings 4 ${DBS}/" BFF_ZprimeToTauTau_M${MASS}_dbs0p5_InputCards/BFF_ZprimeToTauTau_M${MASS}_dbs0p5_customizecards.dat
sed -i -e "s/output BFF_ZprimeToTauTau_M200 -nojpeg/output BFF_ZprimeToTauTau_M${MASS}_dbs0p5 -nojpeg/" BFF_ZprimeToTauTau_M${MASS}_dbs0p5_InputCards/BFF_ZprimeToTauTau_M${MASS}_dbs0p5_proc_card.dat
# issue with the cards in the genproduction directory, this should"ve been commented out
sed -i -e "s/average =  event_norm/!average =  event_norm/" BFF_ZprimeToTauTau_M${MASS}_dbs0p5_InputCards/BFF_ZprimeToTauTau_M${MASS}_dbs0p5_run_card.dat

sh gridpack_generation.sh BFF_ZprimeToTauTau_M${MASS}_dbs0p5 BFF_ZprimeToTauTau_M${MASS}_dbs0p5_InputCards/ local ALL

mkdir -p prod
mkdir -p tarballs
mv BFF_ZprimeToTauTau_M${MASS}_dbs0p5_InputCards prod
mv BFF_ZprimeToTauTau_M${MASS}_dbs0p5 prod
mv BFF_ZprimeToTauTau_M${MASS}_dbs0p5.log prod/BFF_ZprimeToTauTau_M${MASS}_dbs0p5
mv BFF_ZprimeToTauTau_M${MASS}_dbs0p5_*tarball.tar.xz tarballs
