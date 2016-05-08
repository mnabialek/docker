# Docker
This project is intended to help you create and manage your Docker projects (instruction is for Windows but Linux users can also use this for their Docker projects). It contains **PHP 7**, **Nginx** and **MySQL 5.7** server. It's intended only for local usage (no security aspects included);

## Installation

1. Clone this repository

2. Open `Docker Quickstart Terminal` (later in this document we refer this as `terminal`) shortcut and write `pwd`.

3. Into directory you got from `pwd` command you should copy `docker` directory and `.bashrc` file. In case you have either directory or this file already you should merge them manually

4. Open `.bashrc` file now and set:

   ```
   DOCKER_DIR='/c/Users/marcin/docker/';
   DEFINITIONS_DIR='/Users/marcin/docker/definitions/';
   ```
   
   correctly. Probably you should change here only `marcin` into your current Windows user.
   
5. In terminal run now:

   ```
   docc
   ```
   
   you will see aliases and extra commands for managing Docker projects.
   
6. Into `local_directory` of your docker directory you should put public SSH key (in OpenSSH format) into `ssh` subdirectory and you should generate Github access token and put it into `github-oauth` file of `tokens` directory

## Project creation

In terminal run `dcc` to create project, you will see required parameters for this command.

Example creation of project:

    ```
    dcc test.app test 8080 30060 220 10010
    ```

Now if everything goes fine, you can run the project running in terminal:

    ```
    dcu test.app
    ```

Now you can access your site in browser using your Docker IP (usually 192.169.99.100) and port you gave for `dcc` command - in this case it would be 192.169.99.100:8080

If you want to run your site using domain without port, add 

    ```
    192.168.99.100 test.app
    ```
    
into your Windows `hosts` file
    
and run also

```
dcu proxy
```

Now you should be able to access your site using `test.app` in your browser

## Other projects

When you create other projects you should make sure you are using other ports that in different projects, so you should write down those ports each time you add new project to make sure
there won't be any port collisions between projects.

## Other docker commands

To stop, build etc. project please look at `docc` command list. You can also investigate `.bashrc` content to know what exactly those commands do. 

## Usage

You can SSH into PHP container using private key, `root` as user, docker IP and SSH port you gave using `dcc` command.

You can connect to database server using `root` as user, `pass` as password (by default) docker IP and database port you gave using `dcc` command.

To connect database from PHP application you can use `db` as host, `3306` as port, `root` as username and `pass` as password (by default).

## PHP configuration

By default there are a few PHP extensions installed. You can add more in `docker/definitions/php-7.0-fpm/Dockerfile`. Be aware to use them in the project, you need to add more PHP configuration files into `templates/php7-nginx-mysql57/php/config/conf.d` directory. By default only `pdo_mysql` and `xdebug` are turned on however some additional extensions (for example `soap` are already included in build.  

## Licence

This package is licenced under the [MIT license](http://opensource.org/licenses/MIT)
