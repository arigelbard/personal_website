####################################################################
# SET PERMISSIONS FOR ROOT SITE FILES
chmod 644 index.html
for i in $(find images -type f); do chmod 644 $i; done
chmod 755 images

# GITHUB SYNC
printf 'Would you like to sync with GITHUB? (y/n)? '
read answer
if [ "$answer" != "${answer#[Yy]}" ] ;then 

    git config http.postBuffer 20242880000

    # PULL CLOUD REPO TO LOCAL
    git pull 

    # SYNC TO LOCAL REPO TO CLOUD 
    read -p 'ENTER MESSAGE: ' message
    echo "commit message = "$message; 
    git add ./; 
    # MAIN BRANCH
    git commit -m "$message"; 

    # PUSH NON-MAIN BRANCH
    #git push  -u origin w05-draft

    # PUSH MAIN BRANCH
    git push

else
    echo NOT PUSHING TO GTIHUB!
fi

###################################################################################
# Prompt user to push to website
printf 'Do you want to push the website to the Georgetown University domains folder? (y/n)'
read answer 

if [ "$answer" != "${answer#[Yy]}" ] ;then 
    rsync -avz -e "ssh -i ~/.ssh/id_rsa" \
        index.html \
        images \
        dsan5000-project \
        dsan5200-project \
        gelbard_resume.pdf \
        arigelba@gtown03.reclaimhosting.com:/home/arigelba/public_html/
else 
    echo NOT PUSHING TO WEBSITE!
fi
