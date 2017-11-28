#!/bin/sh

[ -d "$1" ] || exit 1
cd "$1" || exit 1

# prefer xfs_io
if xfs_io -c help 2>/dev/null | grep fsync; then
	FSYNC="xfs_io -c fsync"
fi
if xfs_io -c help 2>/dev/null | grep syncfs; then
	SYNCFS="xfs_io -c syncfs"
fi

# second best syncfs tool
[ -n "$SYNCFS" ] || SYNCFS=`which syncfs`

# fall back to sync tool
[ -n "$SYNCFS" ] || SYNCFS="sync -f"
[ -n "$FSYNC" ] || FSYNC="sync"

xfs_sync_stats()
{
	echo $1
	echo -n "xfs_log_force = "
	grep log /proc/fs/xfs/stat  | awk '{ print $5 }'
	! test -f x || filefrag -e x | grep delalloc
}

rm x
xfs_sync_stats "before write"
echo 123 > x
xfs_sync_stats "after write"
$SYNCFS .
xfs_sync_stats "after syncfs"
$FSYNC x
xfs_sync_stats "after fsync"
$FSYNC x
xfs_sync_stats "after fsync #2"
