# k8s-cron

- Automatic deployment of defined cronjobs into the cluster.
- Any required secrets must be created in advance, in the `cron` namespace:

## Pre-defined Backup Secrets

- name: rclone-config

  - file: rclone.conf
  - contents:

    ```markdown
    [switch]
    type = s3
    env_auth = false
    access_key_id = <key_id>
    region = zhdk
    secret_access_key = <secret>
    endpoint = https://s3-zh.os.switch.ch
    [minio]
    type = s3
    env_auth = false
    access_key_id = <key_id>
    secret_access_key = <secret>
    endpoint = http://minio-s3.minio.svc.cluster.local:9000
    ```

- name: db-ckan-wsl-creds

  - key: BACKUP_DB_HOST
  - key: BACKUP_DB_PASS

- name: db-ckan-backup-creds

  - key: RESTORE_DB_HOST
  - key: RESTORE_DB_PG_PASS

## Backup Schedules

| Time  | Type | From                   | To                     | File                          |
| ----- | ---- | ---------------------- | ---------------------- | ----------------------------- |
| 24:00 | S3   | NFS CKAN Resources     | SWITCH/envidat         | s3-1-nfs-to-s3.yaml           |
| 00:05 | DB   | WSL                    | K8 Backup              | db-prod-to-backup.yaml        |
| 01:00 | S3   | SWITCH/envidat         | MINIO/envidat-backup   | s3-2-prod-to-backup.yaml      |
| 01:05 | DB   | K8 Backup              | S3 SQL Dump            | db-prod-s3-dump.yaml          |
| 02:00 | S3   | SWITCH/envidat         | SWITCH/envidat-staging | s3-3-prod-to-staging.yaml     |
| 02:30 | S3   | SWITCH/envidat-staging | SWITCH/envidat-dev     | s3-4-staging-to-dev.yaml      |
| 03:00 | S3   | NFS CKAN Uploads       | SWITCH/envicloud       | s3-5-nfs-envicloud-to-s3.yaml |
| 04:00 | S3   | SWITCH/drone-data      | NFS /vol_dronedata     | s3-6-drone-s3-to-nfs.yaml     |

## Other Schedules

| Day | Time  | Type       | File               |
| --- | ----- | ---------- | ------------------ |
| 1,4 | 03:15 | Open data  | nasa-gcmd.yaml     |
| 1,4 | 03:15 | Open data  | opendataswiss.yaml |
| All | 19:00 | Monitoring | s3-monitoring.yaml |
