My goal is create nuget private repository on AWS cloud with public IP using Terraform and Docker.

# Installation
Manually create a new user on AWS account with full access permission to EC2.
Important: during creation you need to check the checkbox programmatic access and save csv in secure place.

We will need create EC2 instance for our repository, so let's do it:
```
git clone https://github.com/goolzerg/nuget-aws.git
```

Open nuget-to-aws.tf in simple text editor. At first here, you have to replace access_key an secret_key on yours.
Little below you can see Security group block. Here ports are opened 80 and 22 for everyone (just for convenience in this example).
Then SSH public key. The SSH key must be generated with 3rd party service, e.g puttygen.exe and replaced too.

If you've already installed Terraform, you should in the same folder where you've created .tf file, start CLI and type:
```
$ terraform init
$ terraform apply
```
Right now we have prepared EC2 instance for our nuget repository. Let's connect to it through SSH using our generated private key and IP address from output.

In this example was used docker image maintaining by BaGet.
https://hub.docker.com/r/loicsharma/baget

That's it, our repository is installed and accessible throughout public IP address.
Now we can push our packages to the repository:
```
dotnet nuget push -s http://localhost:5555/v3/index.json -k NUGET-SERVER-API-KEY package.1.0.0.nupkg
```
