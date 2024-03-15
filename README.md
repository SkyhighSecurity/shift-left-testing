# Shift Left Testing Script Bundle
  Load / stability testing bundle for Skyhigh Shift-Left CSPM

## Prerequisites
  You must have docker installed and be running as a user with permissions to access the docker daemon.
  
## Running the script
  1.  Clone this repository
  2.  Chance directory into the repository (with the shift-left-test.sh)
  3.  Set the SKYHIGH_USERNAME and SKYHIGH_PASSWORD environment variables e.g. ```export SKYHIGH_USERNAME='username'```
  4.  Run the script ./shift-left-test.sh

## Notes
  - If you break/ctrl+c the script, the docker containers will continue to run. Restarting the docker daemon is the easiest way to kill these (```sudo systemctl restart docker```)
  - You can adjust the thread count (simultaneous dockers) by editing the thread_count variable in the script.
