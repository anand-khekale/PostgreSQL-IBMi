**FREE
        //--------------------------------------------------------------
        Ctl-Opt DftActGrp(*No);
        Ctl-Opt BndDir('JDBC');
        Ctl-Opt Option(*Srcstmt : *NodebugIO);
        Ctl-Opt DatFmt(*ISO);
        //--------------------------------------------------------------
        //Dcl-F QSYSPRT PRINTER;
        //--------------------------------------------------------------
        //Copybook
        //--------------------------------------------------------------
        /copy QRPGLESRC,JDBC_H
        //--------------------------------------------------------------
        //Prototypes
        //--------------------------------------------------------------
        dcl-pr putenv int(10) extproc('putenv');
            *n pointer value options(*string:*trim) ;
        end-pr;

        dcl-pr CHECKSTDIO     extpgm;
        end-pr;
        //--------------------------------------------------------------
        //Program variable definitions...
        //--------------------------------------------------------------
        Dcl-S UserId       Char(50);
        Dcl-S Passwrd      Char(50);
        Dcl-S conn         like(Connection);
        Dcl-S error        Char(50);
        Dcl-S url          Char(50);
        Dcl-S ItemNo       Zoned(29:0);
        Dcl-S Locn         Zoned(2:0);
        Dcl-S Desc         Char(25);
        Dcl-S sql          Varchar(32767);
        Dcl-S sqlQry       Varchar(32767);
        Dcl-S rs           like(ResultSet);
        Dcl-S Connected    Ind Inz(*off);
        Dcl-s Length       packed(15:5);
        Dcl-s EnvVarValue  char(500);
        //==============================================================

        setEnv();
        connectDB();
        If Connected;
        printData();
        Endif;

        *InLR = *On;
        Return;
        //==============================================================
        Dcl-proc connectDB;

        UserId   = 'user01';
        Passwrd  = 'password';
        url      = 'jdbc:postgresql://192.168.0.1:5432/pgsql';

        conn     = JDBC_Connect( 'org.postgresql.Driver' : %trim(url)
                                : %trim(UserId) : %trim(Passwrd));

        If conn  = *null;
          Connected  = *Off;
          Error = 'Connection Failed';
          DSPLY (Error);
        Else;
          Connected  = *On;
        Endif;

        End-proc;
        //==============================================================
        Dcl-proc printData;

         sqlQry= 'Select * from pieces';

         rs = JDBC_ExecQry( conn : sqlQry );

         dow (JDBC_NextRow(rs));
             ItemNo = %int(jdbc_getCol(rs: 1));
             Desc   = jdbc_getCol(rs: 2);

          // Write code to print the data, the scope was to just test
          // the connection and see the data is returned.

         enddo;

         JDBC_FreeResult(rs);

         JDBC_Close(conn);
        End-proc;
        //==============================================================
        Dcl-proc setEnv;

          Monitor;
         // Set CLASSPATH
           EnvVarValue= '/HOME/ANAND/JAVA/JDBC/POSTGRESQL-42.2.14.JAR';
           putenv('CLASSPATH=' + EnvVarValue);

         // Set up parameters for Java exceptions handling
           putenv('QIBM_USE_DESCRIPTOR_STDIO='+ 'Y');

           EnvVarValue = '-Dos400.stderr=file:/HOME/ANAND/mystderr.txt;';
           putenv('QIBM_RPG_JAVA_PROPERTIES='+ EnvVarValue);

           putenv('QIBM_RPG_JAVA_EXCP_TRACE='+ 'Y');

          On-Error;

          Endmon;

         // The below program can be used as part of the setup necessary to see
         // the Java output from an interactive job.This program should be called
         // when the job starts, to ensure that the three "Standard I/O"
         // descriptors 0, 1, and 2 are opened.

           CHECKSTDIO();

        End-proc;
        //==============================================================
