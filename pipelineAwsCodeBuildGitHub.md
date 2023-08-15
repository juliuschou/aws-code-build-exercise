

## 1. Prerequisite
### Understand how to install the AWS Elastic Benastalk on Linux from the link below:

[Install the EB CLI on Linux](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/eb-cli3-install-linux.html)

This document describes how to install the EB CLI (Elastic Beanstalk Command Line Interface) on Linux. The EB CLI is a tool that you can use to manage your Elastic Beanstalk environments from the command line.

To install the EB CLI, you can use the following steps:

1. Install Python 3.7 and pip.
2. Install the EB CLI using the installation script.
3. Add the path to the EB CLI executable to your PATH environment variable.

Once the EB CLI is installed, you can use it to create, manage, and deploy your Elastic Beanstalk environments.

### Understand how to manage multiple version on the same machine from the link below:

[Introducing pyenv: A Simple Way to Manage Python Versions](https://realpython.com/intro-to-pyenv/)

Pyenv is a tool that allows you to easily install and manage multiple versions of Python on your system. This can be useful for a variety of reasons, such as:

* Testing different versions of Python
* Developing projects that require specific versions of Python
* Creating isolated Python environments for different projects

## 2. set up the AWS Command Line Interface (CLI) properly before you can execute aws eb create or any other AWS CLI command 

### Here are the steps you should follow:

1.  Install the AWS CLI:
    
    If you haven't already, you can install the AWS CLI on Ubuntu using `pip`:
    
    ```
    sudo apt-get install python3-pip
    pip3 install awscli --upgrade --user 
    ```
    Ensure the AWS CLI binary is in your path. You might need to add `$HOME/.local/bin` to your `PATH`.
    
3.  Configure AWS CLI:
    
    After you've installed the AWS CLI, you need to configure it with your AWS credentials and default settings. You can do this by running:
    
    
    `aws configure` 
    
    This command will prompt you to provide the following:
    
    -   `AWS Access Key ID`
    -   `AWS Secret Access Key`
    -   `Default region name` (e.g., `us-west-1`, `eu-west-1`)
    -   `Default output format` (e.g., `json`, `text`)
    
    The access key and secret key are provided to you when you create an IAM (Identity and Access Management) user in the AWS Management Console. Ensure that the IAM user has necessary permissions for Elastic Beanstalk operations.
