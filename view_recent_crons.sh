#!/bin/bash

for cronjob_name in $(kubectl get cronjobs -n cron --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}'); do
    echo "===== CRONJOB_NAME: ${cronjob_name} ==========="

    printf "%-15s %-15s %-15s %-15s %-15s\n" "DATE" "START_TIME" "COMPLETION_TIME" "DURATION" "JOB_NAME"
    for job_name in $(kubectl get jobs -n cron --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}' | grep -w "${cronjob_name}-[0-9]*$"); do

        startTime="$(kubectl get job ${job_name} -n cron --template '{{.status.startTime}}')"
        completionTime="$(kubectl get job ${job_name} -n cron --template '{{.status.completionTime}}')"
        if [[ "$completionTime"  == "<no value>" ]]; then
            continue
        fi
        duration=$[ $(date -d "$completionTime" +%s) - $(date -d "$startTime" +%s) ]
        printf "%-15s %-15s %-15s %-15s %-15s\n" "$(date -d ${startTime} +%x)" "$(date -d ${startTime} +%X)" "$(date -d ${completionTime} +%X)" "${duration} s" "$job_name"
    done
done
