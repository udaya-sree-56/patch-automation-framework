pipeline {
    agent any

    stages {

        stage('Windows OS Updates') {
            steps {
                powershell '''
                Import-Module PSWindowsUpdate
                Install-WindowsUpdate -AcceptAll -AutoReboot
                '''
            }
        }

        stage('Chocolatey Updates') {
            steps {
                powershell '''
                choco upgrade all -y
                '''
            }
        }

        stage('Generate Patch Logs') {
            steps {
                powershell '''
                $path = "C:\\patch-automation\\patch-log.txt"
                New-Item -ItemType File -Force -Path $path
                Add-Content $path "Patch Process Completed on $(Get-Date)"
                '''
            }
        }
    }
}
