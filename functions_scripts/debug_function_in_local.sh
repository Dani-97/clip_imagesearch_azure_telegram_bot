export PROJECT_NAME=SearchImages

cd $PROJECT_NAME
python3 -m venv $PROJECT_NAME
source ./$PROJECT_NAME/bin/activate
pip install -r requirements.txt
func start
