export TELEBOT_ROOT_DIR=~/Projects/clip_imagesearch_aws_telegram_bot/telegram_bot
cd $TELEBOT_ROOT_DIR

sudo docker build -t telegram_bot .
sudo docker run -it --rm --mount type=bind,src=$TELEBOT_ROOT_DIR,dst=/home/user/app telegram_bot
