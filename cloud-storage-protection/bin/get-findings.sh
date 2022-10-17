#!/bin/sh
echo -e "Output from Cloud Functions logs:"
gcloud functions logs read FUNCTION --limit=10 --min-log-level=info
