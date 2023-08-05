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

Source: [AWS CodeBuild Setup](https://docs.aws.amazon.com/codebuild/latest/userguide/setting-up.html)
1. ###### To create a CodeBuild service role (console)

1.  Open the IAM console at [https://console.aws.amazon.com/iam/](https://console.aws.amazon.com/iam/).
    
    You should have already signed in to the console by using one of the following:
    
    -   Your AWS root account. This is not recommended. For more information, see [The AWS account root user](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_root-user.html) in the *user Guide*.
        
    -   An administrator user in your AWS account. For more information, see [Creating Your First AWS account root user and Group](https://docs.aws.amazon.com/IAM/latest/UserGuide/getting-started_create-admin-group.html) in the *user Guide*.
        
    -   An user in your AWS account with permission to perform the following minimum set of actions:
        
        ```iam:AddRoleToInstanceProfile
        iam:AttachRolePolicy
        iam:CreateInstanceProfile
        iam:CreatePolicy
        iam:CreateRole
        iam:GetRole
        iam:ListAttachedRolePolicies
        iam:ListPolicies
        iam:ListRoles
        iam:PassRole
        iam:PutRolePolicy
        iam:UpdateAssumeRolePolicy```
        
        For more information, see [Overview of IAM Policies](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies.html) in the *user Guide*.
        
    
2.  In the navigation pane, choose Policies.
    
3.  Choose Create Policy.
    
4.  On the Create Policy page, choose JSON.
    
5.  For the JSON policy, enter the following, and then choose Review Policy:
    ```
     {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Sid": "CloudWatchLogsPolicy",
          "Effect": "Allow",
          "Action": [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          "Resource": "*"
        },
        {
          "Sid": "CodeCommitPolicy",
          "Effect": "Allow",
          "Action": [
            "codecommit:GitPull"
          ],
          "Resource": "*"
        },
        {
          "Sid": "S3GetObjectPolicy",
          "Effect": "Allow",
          "Action": [
            "s3:GetObject",
            "s3:GetObjectVersion"
          ],
          "Resource": "*"
        },
        {
          "Sid": "S3PutObjectPolicy",
          "Effect": "Allow",
          "Action": [
            "s3:PutObject"
          ],
          "Resource": "*"
        },
        {
          "Sid": "ECRPullPolicy",
          "Effect": "Allow",
          "Action": [
            "ecr:BatchCheckLayerAvailability",
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage"
          ],
          "Resource": "*"
        },
        {
          "Sid": "ECRAuthPolicy",
          "Effect": "Allow",
          "Action": [
            "ecr:GetAuthorizationToken"
          ],
          "Resource": "*"
        },
        {
          "Sid": "S3BucketIdentity",
          "Effect": "Allow",
          "Action": [
            "s3:GetBucketAcl",
            "s3:GetBucketLocation"
          ],
          "Resource": "*"
        }
      ]
    }```
    
    ###### Note
    
    This policy contains statements that allow access to a potentially large number of AWS resources. To restrict AWS CodeBuild to access specific AWS resources, change the value of the `Resource` array. For more information, see the security documentation for the AWS service.
    
6.  On the Review Policy page, for Policy Name, enter a name for the policy (for example, **CodeBuildServiceRolePolicy**), and then choose Create policy.
    
    ###### Note
    
    If you use a different name, be sure to use it throughout this procedure.
    
7.  In the navigation pane, choose Roles.
    
8.  Choose Create role.
    
9.  On the Create role page, with AWS Service already selected, choose CodeBuild, and then choose Next:Permissions.
    
10.  On the Attach permissions policies page, select CodeBuildServiceRolePolicy, and then choose Next: Review.
    
11.  On the Create role and review page, for Role name, enter a name for the role (for example, **CodeBuildServiceRole**), and then choose Create role.
    

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

![image](https://github.com/juliuschou/aws-code-build-exercise/assets/4725611/f9e46022-adb5-46bd-95da-b7125a5be355)

![image](https://github.com/juliuschou/aws-code-build-exercise/assets/4725611/f39e3c95-fc74-4756-a652-d1812a454076)

