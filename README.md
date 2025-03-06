# Azure Application: implementation of a Telegram Bot that performs an image search in a HuggingFace Space

This is the architecture of the Azure application that we have implemented:

<img src="./imgs/azure_architecture.png"></img>

The following README.md file addresses how to use the code of this repository to run the application described in the architecture above.

## Requirements:

Before following the instructions of this README to implement the application, you must have the following requirements installed:

- Python Virtual Environments.
- The Azure Client for CLI that you can install following <a href="https://learn.microsoft.com/en-us/cli/azure/install-azure-cli">this guide</a>.
- The Azure Functions Core Tools that you can install following <a href="https://learn.microsoft.com/en-us/azure/azure-functions/functions-run-local?tabs=linux%2Cisolated-process%2Cnode-v4%2Cpython-v2%2Chttp-trigger%2Ccontainer-apps&pivots=programming-language-python">this guide</a>

## First step: Creating a Telegram Bot

I will not explain how to do it here, because I have already done it <a href="https://github.com/Dani-97/clip_imagesearch_aws_telegram_bot">in this repo</a> and there are many tutorials available online of how to do it. All I can say is **"store the TOKEN of the bot you have created, because you will need it later"**.

## Second step: Creating and deploying the Azure Function to connect with HuggingFace

Once you have all the requirements installed, clone this repository and login to your Azure account if you have not done it yet. This can be easily done by typing the command <code>az login</code> or executing the script <code>az_login.sh</code> included in this repository.

Then, go to <code>clip_imagesearch_azure_telegram_bot/functions_scripts</code>. There, you will see several Bash scripts and a directory called <code>SearchImages</code>, which contains the code that will run our function (by this I mean that the Function App Project has been already created).

To create the function app, you need to run <code>create_function_app.sh</code>. This script will create a Resource Group and, within that Group, a Storage and the Function App. You can check the script and freely change anything from it to adapt to your particular circumstances. After doing this, you should see the Resource Group in your Azure Portal, as well as your Function App in the corresponding sections. During this process, some important variables will be stored locally in the file <code>necessary_variables.sh</code> that will be used for other scripts.

After this, you have two options. The **first option** is to test the application locally executing <code>debug_function_in_local.sh</code>. This will create a Virtual Environment, install the required packages and run the function locally with the Azure Functions Core Tools. The **second option** is to publish the code to the Function App. In such case, all you need to do is running <code>publish_function_to_azure.sh</code>. 

> You can proceed how you want, but I would recommend to first debug the function locally. This will create the needed Virtual Environment, making the process of publication a little bit easier (because the Azure Tools will know much better the kind of programming language you are using for your project).

Once the function has been successfuly published, go to the Azure Portal to see its domain name. In this particular case, if you want to test that the function is properly working, type <code>\<domain_name\>/api/search_image?query=\<text\></code> changing \<text\> with your desired query. If the browser returns a list of images' paths, congratulations, the function has been deployed successfuly!

## Third step: Creating the Virtual Machine and running a Docker container to manage the Telegram Bot.

The next step is to create and run a Virtual Machine, that will serve the Docker container and manage the behaviour of the Telegram Bot later. Within the files of this repository, go to the directory <code>vm_scripts</code>. The first thing you need to run is <code>setup_commands.sh</code>, that will create and run the Virtual Machine.

> NOTE: I have coded these scripts to include the Virtual Machine and the Function App in different Resource Groups, but this is not really necessary. Change everything you need to fit to your particular case. Anyway, I must say, the way I have done the scripting demonstrates that it does not matter to connect a Function App and a Virtual Machine that are deployed in different regions (the Function App is in UK South while the Virtual Machine is in Spain Central).

> NOTE: Be aware that, during the creation process of the Virtual Machine, a pair of SSH keys will be generated. Make sure that you are storing those keys in a safe and accessible place. Otherwise, you could not connect with the machine, making it necessary to delete and create once again. Just to let you know, <code>setup_commands.sh</code> is copying the content of your .ssh directory from your home to the current location. If that is an issue for you, make sure to change the scripts and remove that line.

Once the Virtual Machine has been successfuly created, you should see in the Azure Portal. The next step is executing the script <code>connect_vm_ssh_server.sh</code>. This script will not only connect to the Virtual Machine via SSH, but also will copy the content of that current parent directory (<code>vm_scripts</code>) via SCP. This has been done because some of the scripts stored in this parent directory must be used to run the code that will manage the Telegram Bot and this way, your life will be much easier.

If you connected successfuly with the Virtual Machine and listed the content of the home directory, you will see the same scripts that I was mentioning before. Once here, run <code>install_packages.sh</code>, that will install Docker in your Virtual Machine.

Now, we need the code that will be executed within the Virtual Machine. To that end, run <code>import_telebot_project.sh</code> to download the code from a public repository in which I already implemented a Telegram Bot using AWS. Given that this code is run using a Docker container, its execution should be easy to replicate in a different environment.

After the repository has been downloaded, go to <code>Projects/clip_imagesearch_aws_telegram_bot/telegram_bot</code>. There you have the code to run the bot but before running it, you need to configure the application changing some parameters in the <code>config.cfg</code> file. In particular, you will need to change <code>token</code> (filling this field with the corresponding token of the bot that you have initially created) and the <code>api_endpoint</code> (that corresponds with the API Endpoint you obtained in the second step and that allows to retrieve the output of the Azure Function).

Once you have modified the config.cfg to fit your needs, you can go to the root directory again and run either <code>debug_telebot_docker_cont.sh</code> or <code>run_telebot_docker_cont.sh</code>. Both of them will run the same Docker container, but the <code>debug_telebot_docker_cont.sh</code> script will not run in the background which may be easier for these debugging tasks. Nevertheless, once you are done with debugging, execute <code>run_telebot_docker_cont.sh</code>, so you can be able to exit the Virtual Machine and allow the Telegram Bot to still be running.

**If everything is OK, this should be the end of this tutorial for you.**

> SUGGESTION: if, for whatever reason, you want to remove the copy of the repository that has been downloaded, run <code>clean_project_files.sh</code>.












