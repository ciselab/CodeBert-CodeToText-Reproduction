this file holds the changes applied to the existing project from CodeXGlue

- Changed cuda.Longtensor to longtensor where necessary (this must have disabled gpu support in total for validation and test)
- minimal dataset fukes 
- new git repo
- gitignored models and datasets
- make conda env add to git
- moved old readme to initial readme, started my own
- prepare.sh to run the download from initial readme and make minimal datasets
- Added a switch for model-loading in the entrypoint
- Moved to Cuda Container, removed conda environment.yml in favour of pip requirements.txt