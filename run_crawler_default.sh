#!/bin/bash
if [ -f "$CFG/run_crawler.sh" ] ; then
   #"File $CFG exists"
   ./$CFG/run_crawler.sh
else
	# Shell Parameter Expansion problem
	uri=file://$CFG/urls.txt
    uri=${uri%file:/} 
   /apps/nutch-release-2.3/runtime/local/bin/nutch inject $uri 
   /apps/nutch-release-2.3/runtime/local/bin/nutch generate -topN 100 -depth 25
   /apps/nutch-release-2.3/runtime/local/bin/nutch fetch -all
   /apps/nutch-release-2.3/runtime/local/bin/nutch parse -all
   /apps/nutch-release-2.3/runtime/local/bin/nutch index -all
   /apps/nutch-release-2.3/runtime/local/bin/nutch updatedb -all
fi



