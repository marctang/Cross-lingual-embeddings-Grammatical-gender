## Cross-lingual-embeddings-Grammatical-gender

This is a repository for the paper: Cross-lingual Embeddings Reveal Universal and Lineage-SpecificPatterns in Grammatical Gender Assignment.
Further details will be added later on.

The repository contains the following files and folders:
* Predictions: gender predictions for every source-target pair (10 per pair), see section 2.3
* Phylodist.csv: MARC, CAN YOU DESCRIBE THIS ONE?
* kappa_voting.rb: this script can either create the datafiles necessary for calculating Fleiss' kappas (see 2.3) or perform the softmax voting necessary for the word-level analysis (see section 4). It uses "Predictions" as input and fills either the folder Kappas or Voted. Within the script set either kappa = false, voting = true or vice versa (but not both to true).
* kappas.r: this script calculates the Fleiss' kappas based on the contents of the Voted folder (which has to be chosen as the source directory in R). Use R with the preinstalled "irr" package. It will create kappas.tsv in the same folder.
* for_regression.rb: this script uses the contents of the "Voted" folder to fill the "Regression" folder. It also requires all relevant UD treebanks (with all treebanks for the same language merged into a single file) as input, change path to the treebank folder at the beginning of the script. You may use ud_merge_perlang.rb to merge the UD treebanks.
* ud_merge_perlang.rb: a script that goes through all UD 2.6 treebanks and merges all treebanks for the same language into a single file. Set the IN and OUT paths at the beginning of the script.
* regression_distance.rb: this script integrates the contents of the Regression folder with that of the Phylodist.csv file (see section 4). By default, it uses Indo-European languages as source, comment out line 2 and comment in line 3 to opt for Afro-Asiatic. It outputs a single file with the default name fullregr.tsv
* regression_distance.r: this script performs the statistical analysis described in Tables 3 and 4 in section 4. Make sure the lmerTest package is installed.
* inanimate.rb: this script performs the statistical test described at the end of section 4. It uses "Voted" as input and outputs the file "inanimate.tsv". It also requires all relevant UD treebanks (with all treebanks for the same language merged into a single file) as input, change path to the treebank folder at the beginning of the script.
* Kappas: data files for the kappa analysis (section 2.3), output of kappa_voting.rb, input for kappas.rb
* kappas.tsv: output of kappas.r
* Voted: single predictions per language pair, necessary for word-level analysis (section 4), output of kappa_voting.rb, input for for_regression.rb and inanimate.rb
* Regression: interim data files for regression analysis (section 4). Output of for_regression.rb, input for regression_distance.rb
* fullregr_ie.tsv, fullregr_semitic.tsv: final data files for regression analysis (section 4). Output of regression_distance.rb, input for regression_distance.rb
* inanimate.tsv: output of inanimate.rb