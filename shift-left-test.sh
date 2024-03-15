#!/bin/bash

base_directory="./templates"
thread_count=16

# Array of original files of applicable type
declare -a files=("ec2.json" "rds.json" "s3.yaml")

echo "Cleaning up old files..."
rm -Rf thread*

# Create directories and copy files for thread queues.
setup_directories_and_copy() {
    # Create directories named thread1, thread2, and thread3.
    for (( t = 0; t < ${thread_count}; t++ )); do
        thread="thread$t"
        mkdir -p "${thread}"

        # Loop through each file and make 10 copies with random names in the thread directory.
        for file in "${files[@]}"; do
            local extension="${file##*.}"
            for i in {1..10}; do
                # Generate a random base filename.
                local random_name=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)
                local new_filename="${random_name}.${extension}"
                cp "${base_directory}/${file}" "${thread}/${new_filename}"
            done
        done
    done
}

echo "Creating queues..."
setup_directories_and_copy

for (( i=0; i<${thread_count}; i++ )); do
  thread="thread$i"
  find ./$thread -type f \( -iname "*.yaml" -o -iname "*.yml" -o -iname "*.tf" -o -iname "*.json" \) > $thread.txt # -printf '%f\n'
done

SKYHIGH_ENV="https://www.myshn.net"
IAAS_PROVIDER="aws" # Tells Skyhigh which set of active CSPM policies to execute against.  Valid options are aws, gcp, or azure.

for (( i=0; i<${thread_count}; i++ )); do
  THREAD_DATA=$(cat "thread$i.txt" | while read line; do echo $line; done)
  THREAD_DATA=$(echo $THREAD_DATA  | tr ' ' ',')
  echo "Starting docker instance $i..."
  docker run -v $PWD:/data shiftleftdockerimage:latest $THREAD_DATA $SKYHIGH_USERNAME $SKYHIGH_PASSWORD "/data" $IAAS_PROVIDER $SKYHIGH_ENV &
  sleep 5
done

echo "Waiting for docker instances to finish..."
wait
echo "Cleaning up files..."
rm -Rf thread*
echo "Done."



