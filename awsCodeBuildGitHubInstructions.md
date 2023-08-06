
# Practical MLOps: A Step-By-Step Guide for creating a AWS codebuild project connecting to a public github repository

Create a new GitHub repository with necessary Python scaffolding using a Makefile, linting, and testing. Then, perform additional steps such as code formatting in your Makefile. Finally, create a AWS codebuild project connection to github repositroy.




## Introduction

Welcome to the "Practical MLOps" tutorial repository! This repository offers a detailed, step-by-step guide to an exercise from the book "Practical MLOps" by Noah Gift and Alfredo Deza.

In this tutorial, you will:

-   Use a cloud-native build server, specifically AWS CodeBuild, to perform continuous integration for your project.
-   Set up a building container inside a private subnet.
-   Ensure that the running container can access the Internet by routing its traffic through a NAT Gateway located in a public subnet.
-   Understand that the public subnet has an associated Internet Gateway, which serves as a conduit for internet access.
-   Implement a cost-saving measure by using a VPC endpoint connected to an S3 bucket.

![image](https://github.com/juliuschou/aws-code-build-exercise/assets/4725611/8c5e554a-7984-4b02-9e5c-37ac00f49cc4)

## Prerequisite

Please refer to the Medium article titled "[Create a VPC in AWS with Public and Private Subnets & NAT Gateway](https://quileswest.medium.com/create-a-vpc-in-aws-with-public-and-private-subnets-nat-gateway-8c45ca371a82)" by Christopher Quiles. The article provides detailed, step-by-step instructions, accompanied by screenshots, on how to set up a VPC in AWS with both public and private subnets as well as a NAT gateway.

## Setup: Upgrading Python & Installing Required Tools

The first step is to ensure that you have Python 3.6 and pip installed. Follow the steps below for a CentOS 7 system:

### Installing Development Tools

1.  Open your terminal and run the following command to install necessary development tools:
        
    `sudo yum groupinstall 'Development Tools'` 
    

### Enabling Software Collections (SCL)

-  Run this command to install the CentOS SCL release file:
    
    `sudo yum install centos-release-scl` 
    

### Installing Python 3.6

- To install Python 3.6, use the following command:
    
    `sudo yum install rh-python36` 
    

### Using Python 3.6

1.  After installing Python 3.6, check your Python version:

    `python --version` 
    
    This will likely return Python 2.7 as the default version.
2.  To switch to Python 3.6, launch a new shell instance with the SCL tool:
    
    `scl enable rh-python36 bash` 
    
3.  Check your Python version again, Python 3.6 should now be the default version.

### Installing pip

-  Finally, install python-pip and any required packages with this command:
    
    `sudo yum -y install python-pip` 
    

## Setting Up Your IDE: PyCharm & JetBrains Toolbox

Now that you have Python and pip ready, you can set up your Integrated Development Environment (IDE). Here we use PyCharm as our IDE, and JetBrains Toolbox to manage JetBrains apps.

### Installing JetBrains Toolbox & PyCharm

1.  Download the script using `curl`:
    
    
    `curl -L -o jetbrains-toolbox.sh https://raw.githubusercontent.com/nagygergo/jetbrains-toolbox-install/master/jetbrains-toolbox.sh` 
    
2.  Make the downloaded script executable:
        
    `chmod +x jetbrains-toolbox.sh` 
    
3.  Run the script:
        
    `./jetbrains-toolbox.sh`
     
4. Install PyCharm Community

### Creating a Virtual Environment in PyCharm

1.  Open PyCharm and create a new project.
2.  In the setup screen, select the option "New environment using" and choose "Virtualenv" from the dropdown.
3.  Choose a location for the virtual environment and select the base interpreter.
4.  Check the checkbox labelled "Inherit global site-packages" if you want your project’s virtual environment to inherit all globally installed libraries and packages.
5.  Click on "Create" to create the virtual environment.


## Installing Required Packages

Having set up the virtual environment, we will now install some required packages. Run the following command in your virtual environment:

`pip install pytest pytest-cov coverage` 

## Implementing DevOps

In this section, we'll develop a simple Python program and create a `Makefile` to automate some development tasks.

![image](https://github.com/juliuschou/PracticalMLOpsNoahChapter1-01/assets/4725611/44304074-2ae9-4078-9b6e-837984bda4ce)

Source: Practical MLOps by Noah Gift, Alfredo Deza

### Create hello.py

- In your project directory, create a new file named `hello.py` with the following content:
    ```
    def add(x, y):
        #This is an add function
        return x + y
    
    print(add(1, 1))
	 ```

### Create a Test File

-  Create a new file named `test_hello.py` in the same directory as `hello.py`. The content of the file should be:
    ```
    from hello import add
    
    def test_add():
        assert 2 == add(1, 1)` 
    ```

### Create requirements.txt

-  Create a `requirements.txt` file in the same directory. This file should include:
 
    ```
    coverage==6.2
    pylint==2.13.9
    pytest==7.0.1
    pytest-cov==4.0.0
    ```
    

### Create a Makefile

-  Create a `Makefile` in the same directory with the following recipes:

    ```
    install:
        pip install --upgrade pip &&\
            pip install -r requirements.txt
    lint:
        pylint --disable=R,C hello.py
    
    test:
        python -m pytest -vv --cov=hello test_hello.py
    ```

Now, you can use `make install`, `make lint`, and `make test` to automatically install requirements, perform linting, and run tests respectively.

## Configuring GitHub to Avoid Using Username and Password

To interact with GitHub without the need for entering a username and password every time, you can configure SSH authentication. Here are the steps:

### Generate SSH Key

- Open a terminal on your CentOS 7 machine and run the following command to generate an SSH key pair:
    
    `ssh-keygen -t ed25519 -C "your_email@example.com"` 
    

### Add SSH Key to GitHub Account

1.  Log into your GitHub account.
2.  Click on your profile picture → Settings → SSH and GPG keys → New SSH key.
3.  Paste the contents of your `id_ed25519.pub` file into the "Key" field, give your key a descriptive title, and click "Add SSH key".

### Install Git

- Install Git with the following command:
    
    `sudo yum install git` 
    

### Configure Git to Use SSH

- Set your Git username and email address, and configure Git to use SSH. Use the following commands:
    ```
    git config --global user.name "Your GitHub Username"
    git config --global user.email "your_email@example.com"
    ```
## Create an Empty Repository on GitHub    
Before you can push your code, you need to create an empty repository on GitHub:
1. Log in to your GitHub account.
2. Click on the "+" sign in the top right corner of the GitHub website.
3. Select "New repository" from the dropdown menu.
4. Give your repository a name and, optionally, a description.
5. Choose if you want your repository to be public or private (private repositories may require a paid GitHub plan).
6. Do not select any checkboxes for initializing the repository with README, .gitignore, or a license, as we'll push an existing repository.
7. Click on the "Create repository" button.

## Push Code to GitHub
Now that you have generated an SSH key, added it to your GitHub account, configured Git to use SSH, and created an empty repository on GitHub, you can push your code to GitHub:
```
# Navigate to your project directory (the directory where your code is located) 
cd /path/to/your/project # Initialize Git (if not already initialized) 
git init

# Add the files you want to commit to the staging area 
git add . 

# Commit the changes with a meaningful message 
git commit -m "Your commit message here" 

# set remote github repository
git remote add origin git@github.com:YourUsername/YourRepository.git

# Push the committed changes to the master branch of your GitHub repository 
git push origin master
```


## creating an AWS CodeBuild project with a GitHub repository as the source, saving logs and outputs to an S3 bucket, using a VPC endpoint to access the S3 bucket, and using an IAM role for S3 access.
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


## Conclusion


I utilized ChatGPT to enhance this article, as English is my second language.
