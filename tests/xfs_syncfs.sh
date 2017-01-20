#!/bin/sh

[ -d "$1" ] || exit 1
cd "$1" || exit 1

SYNCFS=`which syncfs`
[ -n "$SYNCFS" ] || SYNCFS="sync -f"

FSYNC="sync"
XFS_IO=`which xfs_io`
[ -z "$XFS_IO" ] || FSYNC="xfs_io -x -c fsync"

xfs_sync_stats()
{
	echo $1
	echo -n "xfs_log_force = "
	grep log /proc/fs/xfs/stat  | awk '{ print $5 }'
}

xfs_sync_stats "before touch"
touch x
xfs_sync_stats "after touch"
$SYNCFS .
xfs_sync_stats "after syncfs"
$FSYNC x
xfs_sync_stats "after fsync"
$FSYNC x
xfs_sync_stats "after fsync #2"
