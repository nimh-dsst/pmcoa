#!/bin/bash

lftp  https://ftp.ncbi.nlm.nih.gov <<EOF
cd /pub/pmc/oa_bulk/oa_comm/xml/
mget *.csv
mget *.tar.gz
bye
EOF

lftp  https://ftp.ncbi.nlm.nih.gov <<EOF
cd /pub/pmc/oa_bulk/oa_noncomm/xml/
mget *.csv
mget *.tar.gz
bye
EOF

