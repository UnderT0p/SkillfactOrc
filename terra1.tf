terraform {
    required_providers {
      yandex = {
        source = "yandex-cloud/yandex"
      }
    }

  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "bcommon"
    region     = "ru-central1"
    key        = "state/terra1.tfstate"
    access_key = "LndddgzXSWe6Wm7vUQ0s"
    secret_key = "cqBr-t-QSzSlaG_xGsZZI4364WjL73cpMrejNG4W"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}
provider "yandex" {
  token     = "AQAEA7qiW1QwAATuwUSHH4Y8XU-7q1d_cne6bnE"
  cloud_id  = "b1g5n02maeq7vrb81anq"
  folder_id = "b1grl21r06ntfk66vpia"
  zone      = "ru-central1-a"
}
resource "yandex_vpc_network" "networkans-1" {
  name = "network1"
}
resource "yandex_vpc_subnet" "subnetans-1" {
  name           = "subnetans1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.networkans-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}
resource "yandex_compute_instance" "vm-Master" {
  name = "terraform1"
  hostname = "terraform1"
  zone      = "ru-central1-a"
    resources {
        cores  = 4
        memory = 4
        core_fraction=5
    }
    boot_disk {
        
        initialize_params {
          
          image_id = "fd81d2d9ifd50gmvc03g"#ubu18.04lts
          size=12
          type="network-hdd"
        }
    }
    network_interface {
      subnet_id = yandex_vpc_subnet.subnetans-1.id
      nat       = true
      ipv6 =false
    }
    metadata = {
      user-data = "${file("C:\\Users\\User\\Desktop\\terraform\\user.txt")}"
    }
    scheduling_policy {
      preemptible=true
    }
}
resource "yandex_compute_instance" "vm-slave" {
  name = "terraform2"
  hostname = "terraform2"
  zone      = "ru-central1-a"
  resources {
    cores  = 4
    memory = 4
    core_fraction=5
  }

  boot_disk {
   
      initialize_params {
       
        image_id = "fd81d2d9ifd50gmvc03g"#ubu18.04
        size=12
        type="network-hdd"
      }
   
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnetans-1.id
    nat       = true
    ipv6 =false
  }

  metadata = {
     user-data = "${file("C:\\Users\\User\\Desktop\\terraform\\user.txt")}"
  }
  scheduling_policy {
      preemptible=true
    }
}

output "internal_ip_address_vm-Master" {
  value = yandex_compute_instance.vm-Master.network_interface.0.ip_address
}

output "internal_ip_address_vm-slave" {
  value = yandex_compute_instance.vm-slave.network_interface.0.ip_address
}


output "external_ip_address_vm-Master" {
  value = yandex_compute_instance.vm-Master.network_interface.0.nat_ip_address
}

output "external_ip_address_vm-slave" {
  value = yandex_compute_instance.vm-slave.network_interface.0.nat_ip_address
}