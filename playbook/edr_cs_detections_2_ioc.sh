# get IOC DOMAINS
prefix=$1
infile=$2

cat $infile | jq -r '.result."DnsRequests{}.DomainName"' | sed '/^\[$/d' | sed '/^\]$/d' | sed '/^null$/d' | tr -d \" | tr -d , | sed 's/^[[:space:]]*//g' > $prefix"_ioc_doms.txt"
cut -f2,3 -d. $prefix"_ioc_doms.txt" | sort -u > $prefix"_ioc_top_doms.txt"

# get IOC PUBLIC IPs
cat $infile | jq -r '.result."NetworkAccesses{}.RemoteAddress"' | sed '/^\[$/d' | sed '/^\]$/d' | sed '/^null$/d' | tr -d \" | tr -d , | sed 's/^[[:space:]]*//g' | sort -u > $prefix"_ioc_ip.txt"

# get IOC MD5 hashes
cat $infile | jq -r '.result.MD5String' | sed '/^\[$/d' | sed '/^\]$/d' | sed '/^null$/d' | tr -d \" | tr -d , | sed 's/^[[:space:]]*//g' | sort -u > $prefix"_ioc_md5sums.txt"

# get IOC Malware Filenames
cat $infile | jq -r '.result.MD5String,.result.AssociatedFiles' | sort -u > $prefix_"ioc_filenames.txt"

# get IOC Documents Accessed Filenames
cat $infile | jq -r '.result.MD5String,.result."DocumentsAccessed{}.FileName"' | grep '.*".*' | cut -d\" -f2 | sort -u > $prefix"_ioc_docs_accessed.txt"
                                                                                                                                  
# get IOC Documents Accessed Paths                                                                                                
cat $infile | jq -r '.result.MD5String,.result."DocumentsAccessed{}.FilePath"' | grep '.*".*' | cut -d\" -f2 | sort -u > $prefix"_ioc_docs_paths.txt"

# get IOC Executable Written Filenames
cat $infile | jq -r '.result.MD5String,.result."ExecutablesWritten{}.FileName"' | grep '.*".*' | cut -d\" -f2 | sort -u > $prefix"_ioc_exes_written.txt"
                                                                                                                                   
# get IOC Executable Written Paths                                                                                                 
cat $infile | jq -r '.result.MD5String,.result."ExecutablesWritten{}.FilePath"' | grep '.*".*' | cut -d\" -f2 | sort -u > $prefix"_ioc_exes_paths.txt"
