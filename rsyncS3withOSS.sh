#!/bin/bash

#1- list buckets of s3 
ListOfS3Bucket="$(aws s3api list-buckets --query "Buckets[].Name")"
echo $ListOfS3Bucket  | python reads3buckets.py

cd buckets
#if user select a bucket or not
if [ ! $# -eq 0 ]; then
    bucket_name_from_args=$1
    if [ -d "$bucket_name_from_args" ]; then
        cd $bucket_name_from_args
        echo "Syncing in bucket: ${PWD##*/}"
        #3- open each dir and sync a bucket with each folder
        #aws s3 cp s3://$bucket_name_from_args . --recursive
        aws s3 sync s3://$bucket_name_from_args . --delete
        #4- make oss bucket with eachfolder with if condation to check if the bucket is exist or not
        aliyun oss mb oss://$bucket_name_from_args --acl=public-read
        #5- sync each folder with a oss bucket
        aliyun oss cp . oss://$bucket_name_from_args -r --force
        cd ..
    else
        echo "ERR: the bucket does not exist in S3"    
    fi
else
    #2 - mkdir with same name as buckets name
    for bucket in `ls .`
    do
        cd $bucket
        echo "Syncing in bucket: ${PWD##*/}"
        #3- open each dir and sync a bucket with each folder
        #aws s3 cp s3://$bucket . --recursive
        aws s3 sync s3://$bucket . --delete
        #4- make oss bucket with eachfolder with if condation to check if the bucket is exist or not
        aliyun oss mb oss://$bucket --acl=public-read
        #5- sync each folder with a oss bucket
        aliyun oss cp . oss://$bucket -r --force
        cd ..
    done
fi    

ListOfOSSBuckets="$(aliyun oss ls)"
echo "List of OSS buckets>>"
echo $ListOfOSSBuckets
