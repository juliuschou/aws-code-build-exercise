Sure, the following steps cover your requirements: creating an AWS CodeBuild project with a GitHub repository as the source, saving logs and outputs to an S3 bucket, using a VPC endpoint to access the S3 bucket, and using an IAM role for S3 access.

Step 1: Create an S3 Bucket

1.  Navigate to the AWS S3 console, click "Create bucket".
    
2.  Name your bucket and select the region you desire.
    
3.  Leave the rest as default or configure as you desire, then click "Create".
    

Step 2: Create a VPC Endpoint for S3

![image](https://github.com/juliuschou/aws-code-build-exercise/assets/4725611/4762577b-4df2-4639-b27e-d4784a6b0494)

Source: [Gateway Endpoints for Amazon S3](https://docs.aws.amazon.com/vpc/latest/privatelink/vpc-endpoints-s3.html)


1.  Open the Amazon VPC console at [https://console.aws.amazon.com/vpc/](https://console.aws.amazon.com/vpc/).
    
2.  In the navigation pane, choose Endpoints.
    
3.  Choose Create endpoint.
    
4.  For Service category, choose AWS services.
    
5.  For Services, add the filter Type: Gateway and select com.amazonaws.*region*.s3.
    
6.  For VPC, select the VPC in which to create the endpoint.
    
7.  For Route tables, select the route tables to be used by the endpoint. We automatically add a route that points traffic destined for the service to the endpoint network interface.
    
8.  For Policy, select Full access to allow all operations by all principals on all resources over the VPC endpoint. Otherwise, select Custom to attach a VPC endpoint policy that controls the permissions that principals have to perform actions on resources over the VPC endpoint.
    
9.  (Optional) To add a tag, choose Add new tag and enter the tag key and the tag value.
    
10.  Choose Create endpoint.
    

Step 3: Create an IAM Role for CodeBuild

1.  Navigate to the IAM console, click "Roles" on the left, then click "Create role".
    
2.  Select "AWS service" as the trusted entity type, then select "CodeBuild".
    
3.  Click "Next: Permissions". In the policy list, find and select "AmazonS3FullAccess", which gives CodeBuild the permission to access S3.
    
4.  Click "Next: Tags" then "Next: Review". Name your role, give it a description if you want, then click "Create role".
    

Step 4: Create a CodeBuild Project

1.  Navigate to the CodeBuild console and click "Create build project".
    
2.  Name your project.
    
3.  For "Source", choose "GitHub", then connect to your GitHub account and choose your repository.
    
4.  For "Environment", choose "Managed image", select the operating system, runtime, image, and environment type you desire.
    
5.  For the "Service role", choose the role you created in Step 3.
    
6.  In the "Additional configuration" section, select the VPC, subnets, and security groups that include the VPC endpoint you created in Step 2.
    
7.  For "Buildspec", choose "Use a buildspec file" if you have one in your repository, otherwise, you can choose "Insert build commands" to provide the build commands manually.
    
8.  For "Artifacts", choose "Amazon S3", select the bucket you created in Step 1 as the "Bucket name", and name your output artifact if you have one.
    
9.  For "Logs", choose "CloudWatch Logs" and "S3 Logs", then choose the bucket you created in Step 1 as the "S3 bucket name".
    
10.  Click "Create build project".
    

Now you have created an AWS CodeBuild project linked to a GitHub repository, and it's configured to save the logs and outputs to an S3 bucket using a VPC endpoint for access. The CodeBuild project uses the IAM role you created for S3 bucket access.# PracticalMLOpsNoahChapter1-01
