# Pull base image.
#IMPORTANT!!!! should run in privileged mode  in order to mount network shares inside  docker run --privileged
FROM elasticsearch:1.5.0

ENV JAVA_HOME /usr/lib/jvm/java-1.7.0-openjdk-amd64
ENV ES_HOME /usr/share/elasticsearch
# Install Marvel plugin for leasticsearch and head plugin
COPY /plugins/marvel-latest.zip /tmp/
COPY /plugins/elasticsearch-head-master.zip /tmp/
RUN \
  echo "Acquire::http::proxy \"http://foo:b\$r@myproxy.com:3128\";" >> /etc/apt/apt.conf \
	&& echo "Acquire::https::proxy \"http://foo:b\$r@myproxy.com:3128\";" >> /etc/apt/apt.conf \
	#&& echo "deb http://nginx.org/packages/ubuntu/ lucid nginx" >> /etc/apt/sources.list \
	&& export HTTP_PROXY="http://foo:b\$r@myproxy.com:3128" \
	&& export HTTPS_PROXY="http://foo:b\$r@myproxy.com:3128" \
	&& apt-get update \
	 # used for mounting windows shares to shares to winshares
	 #TODO check why this package is not installed
	&& apt-get install -y --force-yes cifs-utils \
	&& apt-get install -y --force-yes openssh-client \
	#&& apt-get install -y --force-yes keyutils   //kerberos utils
	#&& apt-get install -y --force-yes openjdk-7-jdk \
    && cd $ES_HOME  \
	&& bin/plugin  -u  "file:///tmp/elasticsearch-head-master.zip" -i "mobz/elasticsearch-head" \ 
    && bin/plugin  -u  file:///tmp/marvel-latest.zip  -i elasticsearch/marvel/latest \
    && cd /  \
    # used for samba shares
    && mkdir windowsshare   \  
    && mkdir apps \
    && rm -f -r /tmp/marvel-latest.zip  \
    && rm -f -r /tmp/elasticsearch-head-master.zip

# config for elasticsearch node
COPY /configs/elastic/node01/elasticsearch.yml /apps/ 

#hbase setup
ENV $HBASE_ROOT /apps/hbase-0.94.26
ADD /apps/hbase-0.94.26.tar.gz /apps/
#COPY /apps/hbase-0.94.26.tar.gz /tmp/ 
COPY /configs/hbase/hbase-site.xml /apps/hbase-0.94.26/conf/
COPY /configs/hbase/hbase-env.sh /apps/hbase-0.94.26/conf/

#nutch setup
ENV $NUTCH_ROOT /apps/nutch-release-2.3
ADD /apps/nutch-release-2.3.tar.gz /apps/nutch-release-2.3/
COPY /configs/nutch/conf/gora.properties    /apps/nutch-release-2.3/runtime/local/conf/
COPY /configs/nutch/conf/nutch-site.xml    /apps/nutch-release-2.3/runtime/local/conf/
COPY /configs/nutch/conf/regex-urlfilter.txt /apps/nutch-release-2.3/runtime/local/conf/
COPY /configs/nutch/conf/suffix-urlfilter.txt /apps/nutch-release-2.3/runtime/local/conf/
#todo this should be injected by application
COPY /configs/nutch/urls.txt /apps/


# used for urls.txt and elasticsearch.yml 
ENV CFG /apps
#TODO use this for all components/apps  (elasticsearch, nutch)
COPY start_hbase_elastic.sh /apps/
COPY run_crawler_default.sh /apps/

#ENTRYPOINT ["/apps/start_hbase_elastic.sh"]
CMD [ "/apps/start_hbase_elastic.sh" ]

VOLUME /appdata   #/appdata/hbase

# zookeeper
EXPOSE 2181
# HBase Master API port
EXPOSE 60000
# HBase Master Web UI
EXPOSE 60010
# Regionserver API port
EXPOSE 60020
# HBase Regionserver web UI
EXPOSE 60030

#elasticsearch ports
EXPOSE 9200
EXPOSE 9300