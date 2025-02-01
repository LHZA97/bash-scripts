#!/bin/bash

bold=$(tput bold)
grey=$(tput setaf 0)
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
reset=$(tput sgr0)
underline=$(tput smul)


####################################### Functions ####################################### 

# Function for list all profiles in .aws directory
list_profile(){
    echo "Here is your profile list:"
    profiles=($(aws configure list-profiles))
    
    # Display numbered list of profiles
    for i in "${!profiles[@]}"; do
        echo "$((i+1)). ${profiles[$i]}"
    done
}

# Function for list all profiles in .aws directory and do sso login
export_profile_and_login(){
    list_profile

    echo -e "\nPlease give the number of your profile:"
    read profile_number

    # Check if the input is a valid number
    if [[ $profile_number -gt 0 && $profile_number -le ${#profiles[@]} ]]; then
        selected_profile=${profiles[$((profile_number-1))]}
        export AWS_PROFILE=$selected_profile
        echo -e "\nYour profile now is: $AWS_PROFILE, proceed to SSO login..."
        aws sso login
        echo "Checking role and account..."
        aws sts get-caller-identity
        echo -e ${green}"Successfully login to your account."
    else
        echo "Invalid selection. Please try again."
    fi

# Function to configure profile for sso login
}
configured_profile_sso(){
    echo "Configure sso login"
    aws configure sso 
    list_profile 
}

####################################### Main Menu ####################################### 

echo -e "${green}\nI'm in `pwd`"${reset}
echo -e "Please choose your command num
${yellow}1) aws configure list
2) aws configure list-profiles
3) export aws profile and sso login
4) aws sso login
5) configure sso login\n"${reset}


####################################### Switch Case ####################################### 

read -p "Please provide your input ${blue} NUMBER:${reset}" choice

case $choice in
  1) aws configure list ;;
  2) aws configure list-profiles ;;
  3) export_profile_and_login ;;
  4) aws sso login ;;
  5) configured_profile_sso ;;
  *) echo "Unrecognized selection: $choice" ;;
esac

# Exit the script
exit 0