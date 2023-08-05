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

1.  Create a GitHub personal access token:
    
    -   Sign in to GitHub.
    -   In the upper-right corner of any page, click your profile photo, then click `Settings`.
    -   In the left sidebar, click `Developer settings`.
    -   In the left sidebar, click `Personal access tokens`.
    -   Click `Generate new token`.
    -   Give your token a descriptive name.
    -   Under `Select scopes`, select the scopes for this token. For fetching source code for your build, you'll usually need `repo`.
    -   Click `Generate token`.
    -   Copy the token and keep it secure. Once you leave the page, you will not be able to see the token again.
2.  Create a CodeBuild project:
    
    -   Open the AWS CodeBuild console at [https://console.aws.amazon.com/codesuite/codebuild/home](https://console.aws.amazon.com/codesuite/codebuild/home).
    -   In the navigation pane, choose `Create build project`.
    -   For `Project name`, enter a name for this build project. Build project names must be unique across each AWS account. You can also include an optional description of the build project.
    -   For `Source`, for `Source provider`, choose `GitHub`.
    -   Choose the `Connect with GitHub personal access token` option.
    -   Enter your GitHub personal access token in the `Token` box, and click `Connect to GitHub`.
    -   ![image](https://github.com/juliuschou/aws-code-build-exercise/assets/4725611/061bc467-6b10-43a2-9703-4efbfd6ccbb4)

    -   In the `Repository URL` box, type the HTTPS clone URL to the GitHub repository for this build project.
3.  Configure the remaining settings:
    
    -   Under `Environment`, specify the information required for your build project to build the source code.
    -   Under `Buildspec`, you can provide the build specification directly in the console, or you can use a buildspec file that's included in the source code root directory.
    -   Under `Artifacts`, specify the settings required for your build project to store the build output.
    -   Under `Logs`, you can choose to create logs in Amazon CloudWatch Logs or Amazon S3, or both.
4.  Create the build project:
    
    -   After you've finished configuring your build project, choose `Create build project`.
    

Now you have created an AWS CodeBuild project linked to a GitHub repository, and it's configured to save the logs and outputs to an S3 bucket using a VPC endpoint for access. The CodeBuild project uses the IAM role you created for S3 bucket access.# PracticalMLOpsNoahChapter1-01

![image](https://github.com/juliuschou/aws-code-build-exercise/assets/4725611/f9e46022-adb5-46bd-95da-b7125a5be355)



