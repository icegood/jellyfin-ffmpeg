#!/bin/bash
set -e
docker start jellyfin_ffmpeg_runner
docker exec jellyfin_ffmpeg_runner bash -c 'cd /workspaces/jellyfin-ffmpeg && ./run_config.sh'
docker rmi jellyfin_ffmpeg_runner_stage:ice_master-amd64 || true
docker commit jellyfin_ffmpeg_runner jellyfin_ffmpeg_runner_stage:ice_master-amd64