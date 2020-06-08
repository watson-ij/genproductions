import FWCore.ParameterSet.Config as cms
externalLHEProducer = cms.EDProducer("ExternalLHEProducer",
    args = cms.vstring('/cvmfs/cms.cern.ch/phys_generator/gridpacks/2017/13TeV/madgraph/V5_2.4.2/ZprimeToMuMu/ZprimeToMuMu_M_200_mg242new_slc6_amd64_gcc481_CMSSW_7_1_30_tarball.tar.xz'),
    nEvents = cms.untracked.uint32(5000),
    numberOfParameters = cms.uint32(1),
    outputFile = cms.string('cmsgrid_final.lhe'),
    scriptName = cms.FileInPath('GeneratorInterface/LHEInterface/data/run_generic_tarball_cvmfs.sh')
)
# Link to cards:
# https://github.com/watson-ij/genproductions/tree/39c8a63631613f24787f2a56d21c0c637479ef9f/bin/MadGraph5_aMCatNLO/cards/production/2017/13TeV/BFF_ZprimeToTauTau

import FWCore.ParameterSet.Config as cms 

from Configuration.Generator.Pythia8CommonSettings_cfi import * 
from Configuration.Generator.MCTunes2017.PythiaCP5Settings_cfi import * 

generator = cms.EDFilter("Pythia8HadronizerFilter", 
     maxEventsToPrint = cms.untracked.int32(1), 
     pythiaPylistVerbosity = cms.untracked.int32(1), 
     filterEfficiency = cms.untracked.double(1.0), 
      pythiaHepMCVerbosity = cms.untracked.bool(False), 
      comEnergy = cms.double(13000.), 
      PythiaParameters = cms.PSet( 
          pythia8CommonSettingsBlock, 
          pythia8CP5SettingsBlock, 
          processParameters = cms.vstring( 
              'JetMatching:setMad = off', 
              'JetMatching:scheme = 1', 
              'JetMatching:merge = on', 
              'JetMatching:jetAlgorithm = 2', 
              'JetMatching:etaJetMax = 5.', 
              'JetMatching:coneRadius = 1.', 
              'JetMatching:slowJetPower = 1', 
              'JetMatching:qCut = 60.', #this is the actual merging scale 
              'JetMatching:nQmatch = 5', #5 for 5-flavour scheme (matching of b-quarks) 
              'JetMatching:nJetMax = 2', #number of partons in born matrix element for highest multiplicity 
              'JetMatching:doShowerKt = off', #off for MLM matching, turn on for shower-kT matching 
          ), 
          parameterSets = cms.vstring('pythia8CommonSettings', 
                                      'pythia8CP5Settings', 
                                      'processParameters', 
                                      ) 
      ) 
) 


muelegenfilter = cms.EDFilter("MCSmartSingleParticleFilter",
                           MinPt = cms.untracked.vdouble(15.,15.,15.,15.),
                           MinEta = cms.untracked.vdouble(-10,-10,-10,-10),
                           MaxEta = cms.untracked.vdouble(10,10,10,10),
                           ParticleID = cms.untracked.vint32(13,-13,11,-11),
                           Status = cms.untracked.vint32(1,1,1,1),
                           # Decay cuts are in mm
                           MaxDecayRadius = cms.untracked.vdouble(2000.,2000.,2000.,2000.),
                           MinDecayZ = cms.untracked.vdouble(-4000.,-4000.,-4000.,-4000.),
                           MaxDecayZ = cms.untracked.vdouble(4000.,4000.,4000.,4000.)
)

ProductionFilterSequence = cms.Sequence(generator + muelegenfilter)
