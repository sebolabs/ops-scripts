#!/bin/bash
set -e
#######################################################################################################
template_file=$1
sed -i '/^$/d' $1
output_file=$2
sed -i '/^$/d' $2
#######################################################################################################
new=0
echo "> [INFO] Looking for new variables in '${template_file}'..."
while read line; do
  variable=`echo $line | awk -F'=' '{ print $1 }' | xargs`
  if ( ! grep -Fq $variable $output_file ); then
    new=1
    echo "${variable} = \"\"" >> $output_file
    echo ">> [INFO] '${variable}' variable with empty value added to '${output_file}'."
  fi
done <$template_file
if [ $new == 0 ]; then echo "> [OK] '${output_file}' was in sync - no new variables were added."
else echo "> [OK] '${output_file}' synchronized with new variables."; fi
#######################################################################################################
obsolete=0
echo "> [INFO] Looking for obsolete variables in '${output_file}'..."
while read line; do
  variable=`echo $line | awk -F'=' '{ print $1 }' | xargs`
  if ( ! grep -Fq $variable $template_file ); then
    obsolete=1
    sed -i "/${variable} =/d" $output_file
    echo ">> [INFO] '${variable}' has been removed from '${output_file}'."
  fi
done <$output_file
if [ $obsolete == 0 ]; then echo "> [OK] '${output_file}' was in sync - no obsolete variables were found."
else echo "> [OK] '${output_file}' cleaned up from obsolete variables."; fi
