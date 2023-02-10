#!/bin/bash
export DUMP_FILE=/backup_`date +%Y%m%d_%H%M%S`.pgdump
PGPASSWORD=$POSTGRES_PASSWORD pg_dump -d $POSTGRES_DB -U $POSTGRES_USER -h $POSTGRES_HOST -f $DUMP_FILE
aws s3 cp ${DUMP_FILE}.bz2.nc $S3_BACKUP_PATH