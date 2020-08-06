# Introduction
Bootstrapping TLS enabled OpenFaas on Openstack with Terraform.

# Prerequisites

1. You'll need an openstack project with the following resources available to consume:
    - One Instance (and enough VCPU's and RAM for it)
    - One Floating IP
    - One Security Group
    - One Network
    - One Router

    You'll also want to make sure that you are able to connect to your cloud's APIs via the CLI. Note that Terraform supports authentication using both the newer application credentials via [clouds.yaml](https://docs.openstack.org/python-openstackclient/ussuri/configuration/index.html) or [Environment Variables](https://docs.openstack.org/python-openstackclient/ussuri/cli/man/openstack.html#manpage).

2. [Download Terraform](https://www.terraform.io). It will need to be available on your `$PATH`.
3. Clone this repo
   ```bash
   git clone https://github.com/markopolo123/openstack-faasd.git
    # move into the repository directory:
   cd openstack-faasd
   ```
4. Define variables in `variables.tfvars`

    We'll need to create a file called `variables.tfvars` in the root of this project and populate with variables; required ones are shown below:

    ```bash
    cat variables.tfvars

    letsencrypt_email = "Your email here"
    public_url      = "faasd.url.here"
    static_fip      = "1.2.3.4" # preallocated Floating IP
    public_network  = "" # Public Network ID for your Floating IP
    image_name      = "CentOS-8-GenericCloud-8.1.1911-20200113.3" # Your image name here
    dns_nameservers = ["8.8.8.8", "8.8.4.4"] # DNS if needed
    flavor_name     = "C1.openstack.tiny" # Flavor type here
    ```
    > Note that here the Floating IP has been pre allocated to the project - this is due to limitations with DNS CNAME records in the cloud available to me.

    There are more variables we could define here, for instance, we could change the versions of *containerd* or *faasd*. Check out `variables.tf` for a full list of variables for this project.
5. Run commands in the `Makefile`

    The Terraform commands have been wrapped in a `Makefile` to *make* things easier for us. It's pretty simple, but saves us having to remember a few flags/options on our terraform commands.

    | Command      | Explanation                                 |
    | ------------ | ------------------------------------------- |
    | make help    | lists available commands                    |
    | make plan    | Generates a plan of action for Terraform    |
    | make apply   | Applies the plan generated in the last step |
    | make destroy | Destroys the cloud resources                |
    | make output  | Displays the output                         |

    > NOTE: The state file is local, which will probably not be what you want for a production instance. While we are at it - you will probably not want your OpenFaas password randomly generated and stored in your state file too. You have been warned ;)

6. Enjoy OpenFaas
   
    The Terraform run completes in a few seconds, however `cloud-init` will take a minute or two to run through the sequence of commands required to get us up and running.

    After the Terraform run is finished you will be presented with the output

    ```bash
    Outputs:

    gateway_url = https://your.url.here/
    login_cmd = faas-cli login -g https://your.url.here/ -p passwordhere
    password = passwordhere
    ```
