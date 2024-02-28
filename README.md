# Convert Codemeta files to Jerico metadata

Jerico uses json files to record software metadata. This is similar to what Codemeta does. This repository contains a script that transforms a `codemeta.json` file into a `jerico.json` file.

1. Open the script at `./R/codemeta2jerico.R`
2. Add the url of the new codemeta.json file to the list `files`
   https://github.com/salvafern/codemeta2jerico/blob/4f94d87a2573b769081c2c4363f09e09973893d8/R/codemeta2jerico.R#L48
3. Run the script using R
   `$ R ./R/codemeta2jerico.R`
4. Resulting files are saved at `./output`

## Requirements
The software MUST HAVE a `codemeta.json` file. To create a `codemeta.json` file you may:
* R: All R packages must have a `DESCRIPTION` file with information about the project. Use [codemetar](https://github.com/ropensci/codemetar ) to generate `codemeta.json`
* Python: All python extensions have a setup.py file. Use codemetapy [codemetapy](https://github.com/proycon/codemetapy)
* Java: Software in Java MAY have a pom.xml file with information about the project. This file can be transformed into codemeta.json using [codemetapy](https://github.com/proycon/codemetapy) as `$ codemetapy pom.xml`. If this file is not available, it can be generated with [maven](https://maven.apache.org/)
