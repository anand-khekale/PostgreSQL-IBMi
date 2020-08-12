# Connecting PostgreSQL from IBM i 

Recently, my client acquired an application which uses PostgreSQL database. The main application resides on IBM i. They wanted to get the data from PostgreSQL into IBM i. 

I did check, if they are open to install PostgreSQL on IBM i itself, which may save them additional infrastructure costs, but the "management" was not ready and I had no power/influence on their decision.

Long story short, they asked me to confirm if we can connect in any way.

I started on the task, downloaded [Scott Klement's](https://www.scottklement.com/jdbc/) JDBC driver Service Program. 
Here are the steps I took, 

1. Downloaded type 4 JDBC driver jar from [PostgreSQL](https://jdbc.postgresql.org) server, placed it in home folder in IFS. e.g. `/home/UserID/java/jdbc/POSTGRESQL-42.2.14.jar`
2. Derived their Class.forName string `'org.postgresql.Driver'` from their [documentation](https://jdbc.postgresql.org/documentation/documentation.html).
3. There are few `ENVVAR` which needs to be set:
    * the environment variable - `CLASSPATH` for driver **.jar** file in *IFS*.
    * setting `STDIN`, `STDOUT`, `STDERR` to catch Java exceptions, also call `CHEKSTDIO` program to set these open [*More details here*](https://www.ibm.com/developerworks/rational/cafe/docBodyAttachments/2681-102-2-7220/Troubleshooting_RPG_Calls_To_Java_v2.html).
4. `RPGLE` to connect and fetch the data from that server. 
5. Compiled and tested the connection. So *simple!*
</p>

<p align="center">

<img src="https://img.shields.io/badge/_-IBM i-blue">
<img src="https://img.shields.io/badge/_-PostgreSQL-lightgrey">
<img src="https://img.shields.io/badge/+-opensource-yellow">

</p>

---


> [anandkhekale](https://anand-khekale.github.io/) &nbsp;&middot;&nbsp;
> GitHub [@anand-khekale](https://github.com/anand-khekale) &nbsp;&middot;&nbsp;
> Twitter [@anandkhekale](https://twitter.com/anandkhekale)
