#!/bin/bash

dry_run=false
param_error=false

if [ "$#" -eq 1 ] && [ "$1" = "-dryrun" ]; then
	dry_run=true
	PROJECT="TEMPLATE"
elif [ "$#" -ne 2 ]; then
	echo "Usage: $0 -dryrun"
	echo "Usage: $0 [REPO] [PROJECT-NAME]"
	param_error=true
fi

if [ "$param_error" = false ]; then

	if [ "$dry_run" = false ]; then
		LIB_REMOTE=$(git remote -v | grep fetch | awk '{ print $2 }')
		SCRIPT_BRANCH=$(git branch | grep '*' | awk '{ print $2 }')

		REMOTE=$1
		PROJECT="$2"
	
		echo "create a new remote branch called project-dev"
		DEV_LIB_BRANCH=$(echo "${PROJECT}" | awk '{ b=tolower($0)"-dev"; print b }')
	
		git checkout master
		git checkout -b ${DEV_LIB_BRANCH}
		git push origin ${DEV_LIB_BRANCH}
	
		git checkout ${SCRIPT_BRANCH}

		echo "remove all reference to the original repository"
		rm -rf .git/

		echo "init a new repository and push to new remote"
		git init
		git add --all
		git commit -m 'Initial commit'
		git remote add origin ${REMOTE}
	
		echo "install code from lib repository as subtree"
		git subtree add --prefix MASLib ${LIB_REMOTE} ${DEV_LIB_BRANCH} --squash
		ALIASFILE=".subtree-alias"
		/bin/cat <<EOF >$ALIASFILE
[alias]
    pull-lib = !git subtree pull --prefix MASLib ${LIB_REMOTE} ${DEV_LIB_BRANCH} --squash
    push-lib = !git subtree push --prefix MASLib ${LIB_REMOTE} ${DEV_LIB_BRANCH} --squash
EOF
		git config --local include.path ../${ALIASFILE}
	else
		echo "linking lib to subfolder"
		git checkout master
		cd ..
		mkdir temp-dir
		cd temp-dir
		ln -s ../MASLib MASLib
		
		echo "writing update-template.sh to update template after your changes"
		/bin/cat <<EOF >update-template.sh
#!/bin/bash
find . | grep -E "xcuserdata$" | xargs rm -rf 
tar -zcvf MASLib/.TEMPLATE/template.tar.gz MASClientProject/ TEMPLATE.xcworkspace/
cp *.txt MASLib/.TEMPLATE/
cd MASLib
git add --all
git commit -e
git push
EOF
		chmod +x update-template.sh
	fi

	echo "copy default project template"
	tar -zxvf MASLib/.TEMPLATE/template.tar.gz -C .
	cp MASLib/.TEMPLATE/*.txt .
	cp MASLib/.gitignore .

	if [ "$dry_run" = false ]; then
		mv TEMPLATE.xcworkspace ${PROJECT}.xcworkspace

		#push all to project repository
		git add --all
	
		git commit -F- <<EOF
${PROJECT} ready.
!!!!!!!
If you cloned after this commit you should run this command

git config --local include.path ../${ALIASFILE}

to have pull-lib push-lib aliases.
!!!!!!!
EOF
		git push -u origin master
	fi
fi

