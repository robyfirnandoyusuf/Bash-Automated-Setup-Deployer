# Bash Automated Setup Deployer
bash script for auto deploying to server when git push

![flow](https://i.postimg.cc/RhY3fjc2/flow.jpg)

## Setup on Production Server : 

1. Clone this repo to your production server run ``` git clone https://github.com/robyfirnandoyusuf/Setup-Auto-Deployer.git```
2. Run ``` chmod +x setup.sh ``` to set executable
3. Run ``` ./setup.sh /path/target/deploy/ projectName```
*/path/target/deploy/ you can replace with /var/www/html,/srv/www,/home/$user/public_html or etc

## Setup on Local Computer : 


1. ``` cd <your/app> ```
2. Initialize your git repo ``` git init ```
3. Run ``` git remote add deploy ssh://<your-name>@<your-ip>/srv/git/<your-app>.git/ ```

## Push to the server (and deploy)
1. Run git command ``` git add .```
2. commit your changes ``` git commit -m 'hello' ```
3. Run ``` git push deploy master ```

## Contact
If you meet any problem when using this tool, file a issue or contact me directly.
[Roby Firnando Yusuf](https://facebook.com/exploreourbrain)
