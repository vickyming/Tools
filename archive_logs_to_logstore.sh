#!/bin/bash -x
if [ -z "$JENKINS_JOB_BASE_NAME" ] || [ -z "$JENKINS_BUILD_NUMBER" ]; then
  echo "JENKINS_JOB_BASE_NAME: \"${JENKINS_JOB_BASE_NAME}\" and JENKINS_BUILD_NUMBER: \"${JENKINS_BUILD_NUMBER}\" should not be empty"
  exit 1
fi
# The root folder name of log archive. It defines how the root path of log archive url is.
LOG_ARCHIVE_NAME="${LOG_ARCHIVE_NAME:-smeet-systest}"
LOG_DIR="${LOG_DIR:-/opt/acer/smeet/logs}"
ARCHIVE_HOST="${ARCHIVE_HOST:-logstore-smeet.ctbg.acer.com}"
ARCHIVE_URI_PATH="${LOG_ARCHIVE_NAME}/${JENKINS_JOB_BASE_NAME}/${JENKINS_BUILD_NUMBER}"
ARCHIVE_RSYNC_DEST_DIR="/a/${ARCHIVE_URI_PATH}"
ARCHIVE_RSYNC_DEST_REMOTE="build@${ARCHIVE_HOST}"
ARCHIVE_RSYNC_DEST="${ARCHIVE_RSYNC_DEST_REMOTE}:${ARCHIVE_RSYNC_DEST_DIR}"
echo "Copying container logs:"
echo "  * HttpDest(https://${ARCHIVE_HOST}/${ARCHIVE_URI_PATH})"
echo "  * RsyncDestination(${ARCHIVE_RSYNC_DEST})"
ssh ${ARCHIVE_RSYNC_DEST_REMOTE} "mkdir -p ${ARCHIVE_RSYNC_DEST_DIR}"
find $LOG_DIR -mindepth 2 -maxdepth 2 -type f | xargs -I {} rsync -aRqz {} ${ARCHIVE_RSYNC_DEST}
