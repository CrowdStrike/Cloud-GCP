#!/bin/sh
echo -e "Output from Cloud Functions logs:"
gcloud functions logs read FUNCTION
