#!/bin/bash
echo "Uploading test files, please wait..."
for i in $(ls TESTS_DIR)
do
    gsutil cp TESTS_DIR/$i BUCKET/$i
done
echo "Upload complete. Check Cloud Functions logs or use the get-findings command for scan results."
