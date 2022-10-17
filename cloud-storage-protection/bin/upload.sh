#!/bin/bash
echo "Uploading test files, please wait..."
for i in $(ls TESTS_DIR)
do
    echo "Uploading $i to BUCKET..."
    gsutil -q cp TESTS_DIR/$i BUCKET
done
echo "Upload complete. Check Cloud Functions logs or use the get-findings command for scan results."
