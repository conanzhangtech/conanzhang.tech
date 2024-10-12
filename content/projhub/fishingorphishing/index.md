---
title: Fishing or Phishing?
date: 2023-05-28
draft: false
description: The purpose is to showcase the effort and commitment I have invested in achieving my objectives and each accomplishment is described in detail to walk you throught the honourable moments and people that made these happen.
noindex: true
comments: true
series:
  - About Me
categories:
  - Project Hub

tags:
  - events
  - projects
  - timeline
  - personal
  - government

images:
# menu:
#   main:
#     weight: 100
#     params:
#       icon:
#         vendor: bs
#         name: book
#         color: '#e24d0e'
authors:
  - conanzhangtech

---

# IMPORTANT!!

THIS PROJECT IS MADE FOR DEMO AND EDUCATION PURPOSE ONLY AND HENCE, THE USE OF THIS REPOSITORY IS AT YOUR OWN RISK. 

I, SHALL NOT BE LIABLE FOR ANY DAMAGED OR LEGAL CONSENTS BY YOUR USAGE OF THIS PROJECT.

## 1. INTRODUCTION

The following demonstration illustrates how an attacker is able to create a public wireless network, and spoof your data.
At the same time, the demonstration also showcase how the attacker processes your information and using various methods to send these data back to themselves.

## 2. VIDEO DEMO

No video yet, I will make one soon. ^_^. 

## 3. PREREQUISITE

#### In this section, I will be explaining what are the required packages before we start the installation.
1. Ubuntu 18.04 and above
> https://ubuntu.com/download/desktop
2. apache and php web server package
> apt install apache php -y
3. git package
> apt install git
4. Slack workspace webhook integration. (OPTIONAL)
> https://api.slack.com/apps?new_app=1

## 4. INSTALLATION

#### In this section, I will be explaining how to put the files into the webserver and ensure it loads.

1. Clone the git repository into the webserver.
> git clone https://github.com/conan97zhang/NUS-phishing-DBS.git

2. Move the NUS-phishing-DBS folder into the Nginx web server's root directory and rename it into m3.
> mv -v NUS-phishing-DBS/* /var/www/html

3. Associate the domain name internet-banking.dbs.com.sg with localhost IP address.
> nano /etc/hosts

3.1 Amend the following line from

>> 127.0.0.1    localhost

TO

>> 127.0.0.1    internet-banking.dbs.com.sg

4. Start apache web server

> service apache2 start

## 4. EXECUTION (METHOD 1 - TERMINAL BASE)

#### In this section, I will be explaining how will the frontend (victim's browser) sends the data to the backend (attacker's server) seamlessly.

4.1 Load the website on your browser.

> http://internet-banking.dbs.com.sg/IB/Welcome

4.2 Start capturing the user inputs by opening 1 terminal.

##### 4.2.1 Terminal

Give Permission!

> sudo chmod 777 /var/www/html/trace.sh

Run it!

> ./var/www/html/trace.sh 

4.3 Go through all the steps in entering the details (VERY SIMPLE!!!)

## 5. EXECUTION (METHOD 2 - SLACK INTEGRATION)

#### In this section, I will be explaining how will the backend (attacker's terminal) sends the data from the frontend (victim's input) to a slackspace seamlessly. (API Integration link can be found at PREREQUISITE.)

5.1 Load the website on your browser.

> http://internet-banking.dbs.com.sg/IB/Welcome

5.2 Go through all the steps in entering the details (VERY SIMPLE!!!)

5.3 Start capturing the user inputs by opening 1 terminal.

##### 5.3.1 Terminal (Send it to slack)
Give Permission!

> sudo chmod 777 /var/www/html/2slack.sh

Run it!

> ./var/www/html/2slack.sh 

## SAMPLE OUTPUT (END OF DEMO).

#### In the last section, we will be analysing the sample data output from Terminal 1 and Terminal 2 ( REFER TO EXECUTION(2) )

##### 1. METHOD 1

The data presented in this output is the input from the rogue DBS iBanking website.

>UID=1234&PIN=12341234&submit=

From the above data, we can safely deduce the following information:

> User ID: 1234
>
> PIN: 12341234

##### 2. METHOD 2 (YOU NEED TO OPEN YOUR SLACK WORKSPACE TO SEE IT)

The data presented in this output is the input from the rogue DBS iBanking website. 

>DBS Banking Credentials
>UID=dsdsd&PIN=sdsds&submit=
>UID=HACKNROLL%231&PIN=20202020&submit=
>UID=HNR2020%232&PIN=1324EWERW&submit=
>UID=12345T&PIN=123456&submit=
>UID=dfd&PIN=123&submit=
>UID=ee&PIN=dfd&submit=
>UID=1234&PIN=12341234&submit=

From the above data, we can safely deduce the following information: (TAKE THE LATEST DATA)

> User ID: 1234
>
> PIN: 12341234

#### NOTE: TO ENSURE THE YOU GET A MESSAGE TO YOUR SLACK WORKSPACE, CHANGE THE CONTENTS IN > 2slack.sh < ACCORDINGLY!

##### ====================================================================================================================

# CREDIT AND SUPPORT

#### Conan Zhang | https://conan97zhang.info
#### LINKEDIN: https://linkedin.com/in/conan97zhang
