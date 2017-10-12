Configuration SQLPreReqInstance
{
    #Import-DscResource -ModuleName xStoragePool
    #Import-DscResource -ModuleName xSQLServer

    $credential = Get-AutomationPSCredential -Name 'EYCompassPoCCredential'

    Node "localhost"
    {
        Script MapAzureInstallMediaShare
        {
            
            GetScript = 
            {
        
            }
            TestScript = 
            {
                Test-Path X:
            }
            SetScript = 
            {
                Invoke-Expression -Command "cmdkey /add:eycompasspoc2storage.file.core.windows.net /user:eycompasspoc2storage /pass:6s4GdEDmwiytWa7QoIUzLAEBBaYkEonIcueS9Zn2hBAQjqbwWYW0glyyO7F6iBnRPR2cayTTc38eIPyipRg1aA=="
                Invoke-Expression -Command "net use X: \\eycompasspoc2storage.file.core.windows.net\installmedia"
            }
        
            PsDscRunAsCredential = $credential
        }


        #region Install prerequisites for SQL Server
        WindowsFeature 'NetFramework35'
        {
            Name   = 'NET-Framework-Core'
            Source = 'X:\sxs'
            Ensure = 'Present'
            DependsOn = '[Script]MapAzureInstallMediaShare'
        }

        WindowsFeature 'NetFramework45'
        {
            Name   = 'NET-Framework-45-Core'
            Ensure = 'Present'
        }
        #endregion Install prerequisites for SQL Server

        
        #xStripeSet SQLDataPool
        #{
        #    diskNumbers = 2,3
        #    storagePoolName = "SQLDataPool"
        #    virtualDiskName = "SQLDataVirtual"
        #    driveLetter = "G"
        #    fileSystemLabel = "SQLData"
        #}

        #xStripeSet SQLLogPool
        #{
        #    diskNumbers = 4,5
        #    storagePoolName = "SQLLogPool"
        #    virtualDiskName = "SQLLogVirtual"
        #    driveLetter = "H"
        #    fileSystemLabel = "SQLLog"
        #}

        #xStripeSet SQLTempPool
        #{
        #    diskNumbers = 6,7
        #    storagePoolName = "SQLTempPool"
        #    virtualDiskName = "SQLTempVirtual"
        #    driveLetter = "T"
        #    fileSystemLabel = "SQLTemp"
        #}

        
        ##region Install SQL Server
        #xSQLServerSetup 'InstallDefaultInstance'
        #{
        #    InstanceName         = 'MSSQLSERVER'
        #    Features             = 'SQLENGINE,IS'
        #    SQLCollation         = 'SQL_Latin1_General_CP1_CI_AS'
        #    SQLSvcAccount        = $credential
        #    AgtSvcAccount        = $credential
        #    SQLSysAdminAccounts  = $credential.UserName
        #    InstallSharedDir     = 'C:\Program Files\Microsoft SQL Server'
        #    InstallSharedWOWDir  = 'C:\Program Files (x86)\Microsoft SQL Server'
        #    InstanceDir          = 'C:\Program Files\Microsoft SQL Server'
        #    InstallSQLDataDir    = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\Data'
        #    SQLUserDBDir         = 'G:\SQL_Data'
        #    SQLUserDBLogDir      = 'H:\SQL_Log'
        #    SQLTempDBDir         = 'T:\TEMP'
        #    SQLTempDBLogDir      = 'T:\TEMP'
        #    SQLBackupDir         = 'Z:\Backup'
        #    SourcePath           = 'X:\SQL 2014 SP2 x64'
        #    UpdateEnabled        = 'False'
        #    ForceReboot          = $false

        #    PsDscRunAsCredential = $credential

        #    DependsOn            = '[WindowsFeature]NetFramework35', '[WindowsFeature]NetFramework45'
        #}
        ##endregion Install SQL Server
    }
}