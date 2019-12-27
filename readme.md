# Docker for developers
This project is intended to help you create and manage your Docker projects. It was tested on MacOS (Docker for Mac) but Linux/Windows users can also use this for their Docker projects (be aware installation instruction is for MacOS users but it should work in similar way for Windows/Linux users). It's intended only for local usage (no security aspects included).
This project is intended to help you create and manage your Docker projects. It was tested on MacOS (Docker for Mac) but Linux/Windows users can also use this for their Docker projects (be aware installation instruction is for MacOS users but it should work in similar way for Windows/Linux users). It's intended only for local usage (no security aspects included).

 
# Available components
 
The following components are available at the moment:
- **PHP 5.6**
- **PHP 7.0**
- **PHP 7.1**
- **PHP 7.2**
- **MySQL 5.6**
- **MySQL 5.7**
- **MySQL 8.0**
- **Nginx**

## Installation

1. Clone this repository

2. Open terminal

3. Into directory of your selection you should create `Docker` directory (you can name it whatever you want). Into directory put content of `docker` directory from this repository, copy also `.bashrc` file to your user directory and make sure it has been loaded. 

4. Open `.bashrc` file now and set:

   ```
   DOCKER_DIR='/Users/marcin/Docker/';
   DEFINITIONS_DIR='/Users/marcin/Docker/definitions/';
   ```
   
   correctly. Probably you should change here only `marcin` into your current MacOS user if you created `Docker` directory in your home directory. Otherwise use custom path.
  
5. Now open `projects/proxy/docker-composer.yml` file inside your DOCKER_DIR directory and update line:

   ```
   /Users/marcin/Docker/local_share/certificates:/etc/nginx/certs:ro
   ```
   
   with valid path.
   
   
6. In terminal run now:

   ```
   docc
   ```
   
   you will see aliases and extra commands for managing Docker projects (If it doesn't work double check if `.bashrc` is loaded).
   
7. Into `local_directory` of your docker directory you should put public SSH key (in OpenSSH format) into `ssh` subdirectory and you should generate Github access token and put it into `github-oauth` file of `tokens` directory

## Project creation

In terminal run `dcc` to create project, you will see required parameters for this command.

Example creation of project:

```
dcc test.local test 8080 18080 30060 220 10010
```

Now if everything goes fine, you can run the project running in terminal:

```
dcu test.local
```

By default 

Now you can access your site in browser using your Docker IP (usually 192.168.0.196) and port you gave for `dcc` command - in this case it would be 192.168.0.196:8080

If you want to run your site using domain without port, add 

```
192.168.99.100 test.local
```
    
into your MacOS `hosts` file
    
and run also

```
dcu proxy
```

Now you should be able to access your site using both `http://test.local` and `https://test.local`.

## Other projects

When you create other projects you should make sure you are using other ports than in different projects, so you should write down those ports each time you add new project to make sure there won't be any port collisions between projects.

## Other docker commands

To stop, build etc. project please look at `docc` command list. You can also investigate `.bashrc` content to know what exactly those commands do. 

## Usage

You can SSH into PHP container using private key, `www-data` as user, docker IP and SSH port you gave using `dcc` command. Alternatively you can also log in using `123` password. You can also log in as root user (same password) but it's recommended to log in as `www-data` user to avoid permissions problems.

You can connect to database server using `root` as user, `pass` as password (by default) docker IP and database port you gave using `dcc` command.

To connect database from PHP application you can use `db` as host, `3306` as port, `root` as username and `pass` as password (by default).

## Available templates

The following predefined templates are available at the moment:

- **PHP 5.6 with MySQL 5.6 and Nginx**
- **PHP 7.0 with MySQL 5.7 and Nginx**
- **PHP 7.1 with MySQL 5.7 and Nginx**
- **PHP 7.2 with MySQL 5.7 and Nginx**
- **PHP 7.2 with MySQL 8.0 and Nginx**
- **PHP 7.3 with MySQL 8.0 and Nginx**

By default when creating new project using `dcc` command will be selected template defined in `.bashrc` for `DEFAULT_TEMPLATE` variable (it's set to **PHP 7.2 with MySQL 5.7 and Nginx** by default).

Obviously depending on your needs you might want to create custom templates (in `templates`) or even brand new components (in `definitions` directory) that will fit better your desired environment.

## Images

This packages uses by default [PHP with Nginx images](https://hub.docker.com/r/mnabialek/laravel-php-nginx/) - you can find their source at [Docker images](https://github.com/mnabialek/docker-images)

## Licence

This package is licenced under the [MIT license](http://opensource.org/licenses/MIT)
