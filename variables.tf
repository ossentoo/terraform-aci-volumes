variable "ContainerInstances" {
  type = object ({
      Name          = string
      ResourceGroup = string
      Location      = string
      DnsNameLabel  = string
      OsType        = string
      IpAddressType = string
      Container     = any
    })

  default = {
    "Name" : "aci-demo-01",
    "ResourceGroup" : "aci-demo-rg",
    "IpAddressType" : "public",
    "DnsNameLabel" : "aci-demo-01",
    "OsType" : "Linux",
    "Container" : {
      "Name" : "app1",
      "Image" : "mcr.microsoft.com/dotnet/core/samples:aspnetapp",
      "Cpu" : "1.0",
      "Memory" : "1.0",
      "Port" : 443,
      "Protocol" : "TCP",
      "EnvironmentVariables" : {
        "Provider" : "sqlsrv",
        "Port" : "1433"
      },
      "SecureEnvironmentVariables" : {
        "servername" : "server1",
      },
      "Volumes" : [
        {
          "Name" : "nginx-certs",
          "MountPath" : "/etc/nginx/certs",
          "ReadOnly" : false,
          "Secrets" : {
            "ssl.crt" : "-----BEGIN CERTIFICATE-----\nMIIFIzCCBAugAwIBAgISA\n-----END CERTIFICATE-----",
            "ssl.key" : "-----BLAH KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBK/ro3dDTa\n3DY6fx0P5vUmk/5sFc0uLXQ=\n-----END BLAH KEY-----"
          }
        },
        {
          "Name" : "nginx-config",
          "MountPath" : "/etc/nginx",
          "ReadOnly" : false,
          "Secrets" : {
            "nginx.conf" : "# nginx Configuration File\n# {hello}"
          }
        }
      ]
    },
    "Location" : "North Europe"
  }
}
