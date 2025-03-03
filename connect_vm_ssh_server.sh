# Load all the variables that were created after executing setup_commands.sh
source necessary_variables.sh

# Sending the script that will automate the process of running the docker
# container in the Virtual Machine.
scp -r ./vm_scripts $MY_USERNAME@$IP_ADDRESS:/home/azureuser

# Then, we connect to the VM itself using ssh.
ssh -o StrictHostKeyChecking=no $MY_USERNAME@$IP_ADDRESS

