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

I'm going to use docker image maintaining by BaGet.
https://hub.docker.com/r/loicsharma/baget

Install docker on our EC2 instance:
```
sudo amazon-linux-extras install docker -y
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -a -G docker ec2-user
```

Download image:
```
docker pull loicsharma/baget
```

Then create a file named baget.env to store BaGet's configurations:
```
# The following config is the API Key used to publish packages.
# You should change this to a secret value to secure your server.
ApiKey=NUGET-SERVER-API-KEY

Storage__Type=FileSystem
Storage__Path=/var/baget/packages
Database__Type=Sqlite
Database__ConnectionString=Data Source=/var/baget/baget.db
Search__Type=Database
```

Next step will be creating a folder named baget-data in the same directory as the baget.env file. This will be used by BaGet to persist its state.
Eventually you can start an image:
```
docker run --rm --name nuget-server -p 80:80 --env-file baget.env -v "$(pwd)/baget-data:/var/baget" loicsharma/baget:latest
```

That's it, our repository is installed and accessible throughout public IP address.
Now we can push our packages to the repository:
```
dotnet nuget push -s http://localhost:5555/v3/index.json -k NUGET-SERVER-API-KEY package.1.0.0.nupkg
```
