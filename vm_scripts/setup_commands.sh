export RANDOM_ID="$(openssl rand -hex 3)"
export MY_RESOURCE_GROUP_NAME="CLIPSearchResGroup$RANDOM_ID"
export REGION=spaincentral
az group create --name $MY_RESOURCE_GROUP_NAME --location $REGION

export MY_VM_NAME="telebotvm$RANDOM_ID"
export MY_USERNAME=azureuser
export MY_VM_IMAGE="Canonical:ubuntu-24_04-lts:server:latest"
az vm create \
    --resource-group $MY_RESOURCE_GROUP_NAME \
    --name $MY_VM_NAME \
    --image $MY_VM_IMAGE \
    --admin-username $MY_USERNAME \
    --assign-identity \
    --generate-ssh-keys \
    --public-ip-sku Standard

# Copy the ssh keys to the host machine directory.
cp -r ~/.ssh ./.ssh

export IP_ADDRESS=$(az vm show --show-details --resource-group $MY_RESOURCE_GROUP_NAME --name $MY_VM_NAME --query publicIps --output tsv)

# Storing the necessary variables.
echo 'export MY_RESOURCE_GROUP_NAME='$MY_RESOURCE_GROUP_NAME > necessary_variables.sh
echo 'export REGION='$REGION >> necessary_variables.sh
echo 'export MY_VM_NAME='$MY_VM_NAME >> necessary_variables.sh
echo 'export MY_VM_IMAGE='$MY_VM_IMAGE >> necessary_variables.sh
echo 'export MY_USERNAME='$MY_USERNAME >> necessary_variables.sh
echo 'export IP_ADDRESS='$IP_ADDRESS >> necessary_variables.sh
