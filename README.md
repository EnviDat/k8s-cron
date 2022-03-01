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

  - key: PROD_DB_HOST
  - key: PROD_DB_PASS

- name: db-ckan-backup-creds

  - key: BACKUP_DB_HOST
  - key: BACKUP_DB_PG_PASS
