import boto3
import os
import sys

s3 = boto3.client('s3')
bucket_name = sys.argv[1]
directory = sys.argv[2]
path_length = len(directory)

website_files = []
for root, dirs, files in os.walk(directory):
  for file in files:
    website_files.append(os.path.join(root, file))

print(website_files)

for x in range(0, len(website_files)):
  print "Uploading file %s to %s, file number %s" % (website_files[x],website_files[x][path_length:], x + 1)

  # if website_files[x][-8:] == "html":
  #   s3.upload_file(website_files[x], bucket_name, website_files[x][path_length:], ExtraArgs={'ContentType': "text/html", 'ACL': "public-read"})
  # elif website_files[x][-5:] == "css":
  #   s3.upload_file(website_files[x], bucket_name, website_files[x][path_length:], ExtraArgs={'ContentType': "text/css", 'ACL': "public-read"})
  # elif website_files[x][-3:] == "js":
  # 	s3.upload_file(website_files[x], bucket_name, website_files[x][path_length:], ExtraArgs={'ContentType': "application/js", 'ACL': "public-read"})

s3.upload_file(website_files[0], bucket_name, website_files[0][path_length:])
s3.upload_file(website_files[1], bucket_name, website_files[1][path_length:])
s3.upload_file(website_files[2], bucket_name, website_files[2][path_length:])
s3.upload_file(website_files[3], bucket_name, website_files[3][path_length:])
s3.upload_file(website_files[4], bucket_name, website_files[4][path_length:])
s3.upload_file(website_files[5], bucket_name, website_files[5][path_length:])
s3.upload_file(website_files[6], bucket_name, website_files[6][path_length:])
s3.upload_file(website_files[7], bucket_name, website_files[7][path_length:])
s3.upload_file(website_files[8], bucket_name, website_files[8][path_length:])
s3.upload_file(website_files[9], bucket_name, website_files[9][path_length:])
