#
# Copyright 2018, Alexis La Goutte <alexis.lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Connect-ArubaCP {

    <#
      .SYNOPSIS
      Connect to an Aruba ClearPass

      .DESCRIPTION
      Connect to an Aruba ClearPass

      .EXAMPLE
      Connect-ArubaCP -Server 192.0.2.1 -token aaaaaaaaaaaaa

      Connect to an Aruba ClearPass with IP 192.0.2.1 using token aaaaaaa

      .EXAMPLE
      Connect-ArubaCP -Server 192.0.2.1 -token aaaaaaaaaaaaa -SkipCertificateCheck

      Connect to an Aruba ClearPass using HTTPS (without check certificate validation) with IP 192.0.2.1 using token aaaaaaa
  #>

    Param(
        [Parameter(Mandatory = $true, position = 1)]
        [String]$Server,
        [Parameter(Mandatory = $false)]
        [String]$token,
        [Parameter(Mandatory = $false)]
        [switch]$SkipCertificateCheck = $false
    )

    Begin {
    }

    Process {

        $connection = @{server = ""; token = ""}

        #Allow untrusted SSL certificat and enable TLS 1.2 (needed by ClearPass)
        Set-ArubaCPCipherSSL
        if ( $SkipCertificateCheck ) {
            Set-ArubaCPuntrustedSSL
        }
        $connection.server = $server
        $connection.token = $token

        set-variable -name DefaultArubaCPConnection -value $connection -scope Global

    }

    End {
    }
}

function Disconnect-ArubaCP {

    <#
        .SYNOPSIS
        Disconnect to a ArubaCP Switches

        .DESCRIPTION
        Disconnect the connection on Aruba ClearPass

        .EXAMPLE
        Disconnect-ArubaCP

        Disconnect the connection

        .EXAMPLE
        Disconnect-ArubaCP -noconfirm

        Disconnect the connection with no confirmation

    #>

    Param(
        [Parameter(Mandatory = $false)]
        [switch]$noconfirm
    )

    Begin {
    }

    Process {

        if ( -not ( $Noconfirm )) {
            $message = "Remove Aruba ClearPass connection."
            $question = "Proceed with removal of Aruba ClearPass connection ?"
            $choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
            $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
            $choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))

            $decision = $Host.UI.PromptForChoice($message, $question, $choices, 1)
        }
        else { $decision = 0 }
        if ($decision -eq 0) {
            Write-Progress -activity "Remove Aruba ClearPass connection"
            write-progress -activity "Remove Aruba ClearPass connection" -completed
            if (Get-Variable -Name DefaultArubaCPConnection -scope global ) {
                Remove-Variable -name DefaultArubaCPConnection -scope global
            }
        }

    }

    End {
    }
}
