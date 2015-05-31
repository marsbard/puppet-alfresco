#INSTALL_LETTER=
#PROMPT="Please choose an index number to edit, or Q to quit"

alfresco_base_dir=`cat go.pp | grep alfresco_base_dir | cut -f2 -d\'`
echo "alfresco_base_dir=$alfresco_base_dir" >> config/backup_answers.sh



INSTALL_LETTER=A
PROMPT="Please choose an index number to edit, A to apply configuration, or Q to quit"
