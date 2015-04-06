
This docker image is built uppon : https://gist.github.com/xrstf/b48a970098a8e76943b9
This is a fat image for an pre alpha version of a  local intranet search with elasticsearch, hbase and  nutch.
Configuring this image is verry limited one should create a derived image which overwrites the config files.
It crawls http and file protocols for web pages pdfs xls  (what apache ticka supports)


Download hbase-0.94.26.tar.gz and place it in /apps/hbase-0.94.26.tar.gz
Download nutch-release-2.3 compile it in some temp directory and place it in /apps/nutch-release-2.3 as nutch-release-2.3.tar.gz

edit files in conf as you with 



mount a shared volume where hbase and elasticsearch will hold data and logs
local container paths will be  (dirs inside appdata will be created automatically)
`/appdata/elastic/data ,
/appdata/elastic/logs ,
/appdata/hbase/data ,
/appdata/hbase/logs`

Use CFG environment variable to overwrite default  configuration where urls.txt and elasticsearch.yml  behaviour. (todo make more files available here)
 The files present inside cfg should be:
 -urls.txt
 -elasticsearch.yml
 -run_crawler.sh (see default run_crawler_default.sh for what should be there)



Run container with `--privileged` and expose port 9200 and 9300 for elasticsearch and a volume for the mentioned dirs

`docker run --privileged --name hella_search_service -it -p 9200:9200 -p 9300:9300 -v /share/hella_google/data/:/appdata  intranet_search:0.1   --entrypoint=/bin/bash`

In order to crawl intranet shares of word, xls file  you have 2 possibilities : 1: run the container with `--privileged` and use `mount -t cifs` like bellow  , or use -v option.
To mount filesystem (You have to map it to windowsshare, see nutch config ):
`sudo mkdir /windowsshare/myshare`
`mount -t cifs "//server/path/to/folder" /windowsshare/myshare -o username=username,password=pass,domain=mydomain,sec=ntlm`
Nutch config is edited so it allows `file://` url crawls only in `file:///windowsshare.*+`


Run run_crawler_default.sh from time to time. You should edit run_crawler_default.sh with -topN option as you wish. Or create a separate run_crawler.sh inside $CFG 
To run the crawler currently you have to execute a bin/bash inside the container like  `docker exec -it hella_search_service /bin/bash` and inside the bin bash 

You can further customize urlfiltering and paths in :
 1. Edit regex-urlfilter.txt and remove any occurence of "pdf"
 2. Edit suffix-urlfilter.txt and remove any occurence of "pdf"
 3. Edit nutch-site.xml, add "parse-tika" and "parse-html" in the plugin.includes section. this should look like this


Indexed documents are stored in elasticsearch inside `nutch` index with type `doc`.

Search with `http://localhost:9200/nutch/doc/_search?q=content:mytext`

Elasticsearch plugins available at :
 http://localhost:9200/_plugin/head/
 http://localhost:9200/_plugin/marvel/kibana/index.html
See elastic.txt for som scethup on how to use elasticearch. rest api.


 Vagrantfile requires proxyconf plugn.
