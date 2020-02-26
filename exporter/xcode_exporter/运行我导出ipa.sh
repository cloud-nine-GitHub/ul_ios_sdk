project_name=game12
project_path=$(pwd)
teamid=843UD8R9H8
scheme=template-mobile
version=1.0.0_1
channel=devtest

script=../../../../../prj.ulcocos2dx3.13/tools/xcode_exporter/exporter.py

python $script --project_name=$project_name --project_path=$project_path --teamid=$teamid --scheme=$scheme --version=$version --channel=$channel --appstore --adhoc