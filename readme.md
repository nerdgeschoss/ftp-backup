# Automated Backups with FTP and MySQL

## Install

```bash
git clone git@github.com:nerdgeschoss/ftp-backup.git
cd ftp-backup
bundle
```

Update your settings in the `.env` file.

## Manual backup

```bash
rake backup
```

## Automated Backups

Automatically run the backup every 12 hours via cron.

```bash
whenever --update-crontab
```
