provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = false
    }
  }

  version = "2.90.0"
}

resource "azurerm_resource_group" "aci-rg" {
  name     = var.ContainerInstances.ResourceGroup
  location = var.ContainerInstances.Location
}

resource "azurerm_container_group" "aci" {
  name                = var.ContainerInstances.Name
  resource_group_name = var.ContainerInstances.ResourceGroup
  location            = var.ContainerInstances.Location
  dns_name_label      = var.ContainerInstances.DnsNameLabel
  os_type             = var.ContainerInstances.OsType
  ip_address_type     = var.ContainerInstances.IpAddressType

  container {

    name   = var.ContainerInstances.Container.Name
    image  = var.ContainerInstances.Container.Image
    cpu    = var.ContainerInstances.Container.Cpu
    memory = var.ContainerInstances.Container.Memory

    environment_variables        = var.ContainerInstances.Container.EnvironmentVariables
    secure_environment_variables = var.ContainerInstances.Container.SecureEnvironmentVariables

    ports {
      port     = var.ContainerInstances.Container.Port
      protocol = var.ContainerInstances.Container.Protocol
    }

    dynamic "volume" {

      for_each = [for x in var.ContainerInstances.Container.Volumes :
        {
          name      = lookup(x, "Name", "")
          mountpath = lookup(x, "MountPath", "")
          readonly  = lookup(x, "ReadOnly", "")
          secrets   = { for key, value in lookup(x, "Secrets", {}) : value => base64encode(value) }
        }
      ]

      content {
        name       = volume.value.name
        mount_path = volume.value.mountpath
        read_only  = volume.value.readonly

        secret = volume.value.secrets
      }
    }
  }
}
