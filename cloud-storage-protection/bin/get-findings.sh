#!/bin/sh
echo -e "Output from Cloud Functions logs:"
gcloud functions logs read FUNCTION --min-log-level=info | egrep 'Threat|Verdict'
