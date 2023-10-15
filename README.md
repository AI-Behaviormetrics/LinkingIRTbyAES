This repository includes programs, sample data, and the complete experimental results related to the following paper:

> Masaki Uto, Kota Aramaki (under review) "Linking Essay Writing Tests Using Many-Facet Rasch Models and Neural Automated Essay Scoring," Behavior Research Methods, Springer.

If you utilize this source code or dataset in your work, please cite the paper mentioned above. 

The following are the procedures for running our code.

## Data Preparation

1. Prepare datasets for two groups consisting of (essay_id, essay_text, rater_id, score), where essay_id, rater_id, and scores must be continuous integer values starting from 1.

2. Place these datasets into the folders: "data/1_for_IRT/focal/" and "data/1_for_IRT/reference/"

3. Include files describing the number of essays and raters in the above folders. The file name should be "settings.csv."

*Please refer to the sample files located in the folders for detailed file formats.*

## Running Procedures

1. Execute "run_mcmc.R" and verify that the parameter estimates are outputted to files in the "2_res_IRT/entire_data/" folder.

2. Run "run_aes.ipynb" on Google Colaboratory and confirm the creation of several files in the "3_for_AES" folder and "4_res_BERT_pred" folder.

3. Execute "run_equating.R," which outputs the linked parameters into the "5_result" folder.
