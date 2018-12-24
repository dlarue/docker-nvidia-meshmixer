#!/bin/bash
cd /opt/meshmixer/bin
export LD_LIBRARY_PATH=/opt/meshmixer/lib:$LD_LIBRARY_PATH
./meshmixer "$@"

