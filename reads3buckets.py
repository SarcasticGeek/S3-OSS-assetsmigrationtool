import json,sys,os

buckets_names = json.load(sys.stdin)

for bucket_name in buckets_names:
    if not os.path.exists('buckets/'+bucket_name):
        os.makedirs('buckets/'+bucket_name)