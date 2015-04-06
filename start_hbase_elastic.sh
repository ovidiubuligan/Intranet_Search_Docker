#!/bin/bash
cd /
mkdir -p /appdata/elastic/data
mkdir -p /appdata/elastic/logs
mkdir -p /appdata/hbase/data
mkdir -p /appdata/hbase/logs
./apps/hbase-0.94.26/bin/start-hbase.sh
elasticsearch -Des.config=$CFG/elasticsearch.yml
