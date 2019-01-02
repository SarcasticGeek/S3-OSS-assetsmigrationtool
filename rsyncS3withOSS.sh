#!/bin/bash

#1- list buckets of s3 
ListOfS3Bucket="$(aws s3api list-buckets --query "Buckets[].Name")"
echo $ListOfS3Bucket  | python reads3buckets.py

cd buckets

#2 - mkdir with same name as buckets name
for bucket in `ls .`
do
    cd $bucket
    echo "Syncing in bucket: ${PWD##*/}"
    #3- open each dir and sync a bucket with each folder
    aws s3 sync . s3://$bucket

    #4- make oss bucket with eachfolder with if condation to check if the bucket is exist or not
    aliyun oss mb oss://$bucket --acl=public-read
    #5- sync each folder with a oss bucket
    aliyun oss cp . oss://$bucket -r 
    cd ..
done

ListOfOSSBuckets="$(aliyun oss ls)"
echo "List of OSS buckets>>"
echo $ListOfOSSBuckets
